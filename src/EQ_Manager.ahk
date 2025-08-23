; ======================================================================================================================
; == EQ 配置管理器 (AutoHotkey v1) ==
; ======================================================================================================================

#Persistent
#SingleInstance, Force
FileEncoding, UTF-8

; --- 配置 ---
eqApoConfigPath = C:\Program Files\EqualizerAPO\config\config.txt
presetsFolderName = EQ_Presets
startupRegPath = HKCU\Software\Microsoft\Windows\CurrentVersion\Run
appName = EQ Profile Manager
; ---------------------

; --- 脚本变量 ---
global isEapoInstalled, isCompiled, lang, RootDir, PresetsPath, SettingsPath, LanguagesPath, SourceCodePath
iniFilePath = %A_ScriptDir%\EQ_Manager_State.ini

; ======================================================================================================================
; == 脚本启动时自动执行 ==
; ======================================================================================================================

Log("--- Script starting ---")

; --- 1. 路径初始化 ---
isCompiled := A_IsCompiled
if (isCompiled)
{
    RootDir := A_ScriptDir
    SourceCodePath := RootDir "\src\EQ_Manager.ahk"
    Log("Running as Compiled (.exe). RootDir: " . RootDir)
}
else
{
    SplitPath, A_ScriptDir, , RootDir
    SourceCodePath := A_ScriptFullPath
    Log("Running as Script (.ahk). RootDir: " . RootDir)
}
PresetsPath := RootDir "\EQ_Presets"
SettingsPath := RootDir "\settings.ini"
LanguagesPath := RootDir "\Languages"

; --- 2. 加载设置 ---
IfNotExist, %SettingsPath%
    CreateDefaultSettings()
IniRead, eqApoConfigPath, %SettingsPath%, 配置, EqualizerApoConfigPath, C:\Program Files\EqualizerAPO\config\config.txt
Log("Equalizer APO config path set to: " . eqApoConfigPath)

; --- 3. 加载语言 ---
LoadLanguage()
Menu, Tray, NoStandard
Menu, Tray, Tip, % lang.TrayTip

Menu, SwitchMenu, Add 
Menu, LangMenu, Add

; --- 4. 依赖与环境检测 ---
IfNotExist, %eqApoConfigPath%
    isEapoInstalled := false
else
    isEapoInstalled := true
Log("Equalizer APO installed: " . isEapoInstalled)

IfNotExist, %PresetsPath%
{
    FileCreateDir, %PresetsPath%
    MsgBox, 4160, % lang.Setup, % lang.Msg_PresetsFolderCreated
}

; --- 5. 应用上次状态 ---
IniRead, eqState, %iniFilePath%, State, EQ_Status, Off
UpdateTrayIcon(eqState)
if (isEapoInstalled and eqState = "On")
{
    IniRead, lastPreset, %iniFilePath%, State, Last_Preset, 
    if (lastPreset != "" and FileExist(PresetsPath . "\" . lastPreset))
    {
        ApplyPreset(lastPreset)
    }
}

Gosub, BuildMenu
Return

; ======================================================================================================================
; == 菜单构建程序 ==
; ======================================================================================================================
BuildMenu:
    Menu, Tray, DeleteAll

    if (isEapoInstalled)
    {
        ; --- 正常菜单 ---
        IniRead, eqState, %iniFilePath%, State, EQ_Status, Off
        IniRead, lastPreset, %iniFilePath%, State, Last_Preset, 

        if (eqState = "On")
        {
            Menu, Tray, Add, % lang.Menu_EQ_On, ToggleEQState
            Menu, Tray, Check, % lang.Menu_EQ_On
            Menu, Tray, Default, % lang.Menu_EQ_On
        }
        else
        {
            Menu, Tray, Add, % lang.Menu_EQ_Off, ToggleEQState
            Menu, Tray, Uncheck, % lang.Menu_EQ_Off
            Menu, Tray, Default, % lang.Menu_EQ_Off
        }
        Menu, Tray, Add

        Menu, SwitchMenu, DeleteAll
        Menu, SwitchMenu, Add, % lang.Menu_OpenFolder, OpenPresetsFolder
        Menu, SwitchMenu, Add, % lang.Menu_Refresh, BuildMenu
        Menu, SwitchMenu, Add
        Loop, %PresetsPath%\*.txt
        {
            presetName := A_LoopFileName
            Menu, SwitchMenu, Add, %presetName%, SwitchEQ
            if (eqState = "On" and presetName = lastPreset)
                Menu, SwitchMenu, Check, %presetName%
        }
        Menu, Tray, Add, % lang.Menu_SwitchPreset, :SwitchMenu
        Menu, Tray, Add
    }
    else
    {
        ; --- 引导菜单 ---
        Menu, Tray, Add, % lang.Menu_DependencyMissing, DummyLabel
        Menu, Tray, Disable, % lang.Menu_DependencyMissing
        Menu, Tray, Add
        Menu, Tray, Add, % lang.Menu_InstallDependency, ShowInstallInstructions
        Menu, Tray, Add
    }
    
    ; --- 语言菜单 ---
    Menu, LangMenu, DeleteAll
    IniRead, currentLang, %iniFilePath%, State, Language, English
    
    Menu, LangMenu, Add, % lang.Menu_OpenFolder, OpenLanguagesFolder
    Menu, LangMenu, Add, % lang.Menu_Refresh, BuildMenu
    Menu, LangMenu, Add

    foundLangFiles := false
    Loop, Files, %LanguagesPath%\*.ini
    {
        foundLangFiles := true
        SplitPath, A_LoopFileName, langName, , , langNameNoExt
        Menu, LangMenu, Add, %langNameNoExt%, ToggleLanguage
        if (langNameNoExt = currentLang)
            Menu, LangMenu, Check, %langNameNoExt%
    }
    
    Menu, Tray, Add, % lang.Menu_Language, :LangMenu
    if (!foundLangFiles)
    {
        Menu, Tray, Disable, % lang.Menu_Language
    }
    Menu, Tray, Add

    ; --- 通用菜单项 ---
    Menu, Tray, Add, % lang.Menu_FindPresets, GoToAutoEQ
    
    Menu, Tray, Add
    RegRead, tempVar, %startupRegPath%, %appName%
    if ErrorLevel
    {
        Menu, Tray, Add, % lang.Menu_Startup, ToggleStartup
        Menu, Tray, Uncheck, % lang.Menu_Startup
    }
    else
    {
        Menu, Tray, Add, % lang.Menu_Startup, ToggleStartup
        Menu, Tray, Check, % lang.Menu_Startup
    }
    Menu, Tray, Add

    if (!isCompiled)
    {
        Menu, Tray, Add, % lang.Menu_EditScript, EditScript
        Menu, Tray, Add, % lang.Menu_ViewLog, ViewLog
    }
    
    Menu, Tray, Add, % lang.Menu_Restart, RestartScript
    Menu, Tray, Add, % lang.Menu_Exit, ExitScript
Return


; ======================================================================================================================
; == 菜单动作与核心功能 ==
; ======================================================================================================================



ToggleLanguage:
    selectedLang := A_ThisMenuItem
    IniWrite, %selectedLang%, %iniFilePath%, State, Language
    Log("Language switched to: " . selectedLang)
    Reload
Return

ToggleStartup:
    RegRead, tempVar, %startupRegPath%, %appName%
    if ErrorLevel
    {
        RegWrite, REG_SZ, %startupRegPath%, %appName%, %A_ScriptFullPath%
        Log("Startup enabled.")
    }
    else
    {
        RegDelete, %startupRegPath%, %appName%
        Log("Startup disabled.")
    }
    Gosub, BuildMenu
Return

ToggleEQState:
    if (!isEapoInstalled)
        return
    IniRead, eqState, %iniFilePath%, State, EQ_Status, Off
    if (eqState = "On")
    {
        FileDelete, %eqApoConfigPath%
        FileAppend,, %eqApoConfigPath%
        IniWrite, Off, %iniFilePath%, State, EQ_Status
        UpdateTrayIcon("Off")
        Log("EQ turned OFF.")
    }
    else
    {
        IniRead, lastPreset, %iniFilePath%, State, Last_Preset, 
        if (lastPreset = "" or !FileExist(PresetsPath . "\" . lastPreset))
            MsgBox, 4144, % lang.Error, % lang.Msg_PresetNotFound
        else
            ApplyPreset(lastPreset)
    }
    Gosub, BuildMenu
Return

SwitchEQ:
    selectedPreset := A_ThisMenuItem
    ApplyPreset(selectedPreset)
    Gosub, BuildMenu
Return

OpenPresetsFolder:
    Run, %PresetsPath%
Return

OpenLanguagesFolder:
    Run, %LanguagesPath%
Return

ViewLog:
    Run, notepad.exe %RootDir%\debug.log
Return

GoToAutoEQ:
    Run, https://autoeq.app/
    MsgBox, 4160, % lang.Info, % lang.Msg_AutoEQ_Instructions
Return

EditScript:
    Run, notepad.exe %SourceCodePath%
Return

RestartScript:
    Reload
Return

ExitScript:
    ExitApp
Return

DummyLabel:
Return

ShowInstallInstructions:
    MsgBox, 262180, % lang.Msg_DependencyMissing_Title, % lang.Msg_DependencyMissing_Body
    IfMsgBox, Yes
    {
        Run, https://sourceforge.net/projects/equalizerapo/files/latest/download
        Run, notepad.exe %SettingsPath%
    }
Return

; ======================================================================================================================
; == 辅助函数 ==
; ======================================================================================================================
ApplyPreset(presetFileName)
{
    global
    presetFilePath = %PresetsPath%\%presetFileName%
    FileRead, presetContent, *c %presetFilePath%
    FileDelete, %eqApoConfigPath%
    FileAppend, %presetContent%, %eqApoConfigPath%, UTF-8
    IniWrite, On, %iniFilePath%, State, EQ_Status
    IniWrite, %presetFileName%, %iniFilePath%, State, Last_Preset
    UpdateTrayIcon("On")
    Log("Applied preset: " . presetFileName)
}

UpdateTrayIcon(eqState)
{
    global
    if (isEapoInstalled)
    {
        if (eqState = "On" and FileExist(RootDir . "\EQ_On.ico"))
            Menu, Tray, Icon, %RootDir%\EQ_On.ico
        else if (eqState = "Off" and FileExist(RootDir . "\EQ_Off.ico"))
            Menu, Tray, Icon, %RootDir%\EQ_Off.ico
        else
            Menu, Tray, Icon
    }
    else
    {
        if (FileExist(RootDir . "\EQ_Off.ico"))
            Menu, Tray, Icon, %RootDir%\EQ_Off.ico
        else
            Menu, Tray, Icon
    }
}

Log(text)
{
    global RootDir
    FormatTime, TimeString,, yyyy-MM-dd HH:mm:ss
    FileAppend, %TimeString% - %text%`n, %RootDir%\debug.log
}

LoadLanguage()
{
    global lang, LanguagesPath, iniFilePath
    lang := {}
    
    IniRead, langName, %iniFilePath%, State, Language, English
    langFilePath := LanguagesPath "\" langName ".ini"

    if (!FileExist(langFilePath))
    {
        if (!A_IsCompiled)
        {
            MsgBox, 4144, Language Error, Language file not found: %langFilePath%`nFalling back to hardcoded English.
        }
        Log("Language file not found: " . langFilePath . ". Falling back to hardcoded English.")
        ; --- Hardcoded English Fallback ---
        lang.TrayTip := "EQ Profile Manager"
        lang.Setup := "Setup"
        lang.Error := "Error"
        lang.Info := "Information"
        lang.Msg_PresetsFolderCreated := """EQ_Presets"" folder was not found and has been created.`nPlease place your .txt EQ profiles inside it."
        lang.Menu_EQ_On := "EQ: ON (Click to turn OFF)"
        lang.Menu_EQ_Off := "EQ: OFF (Click to turn ON)"
        lang.Menu_SwitchPreset := "Switch Profile"
        lang.Menu_OpenFolder := "Open Folder"
        lang.Menu_Refresh := "Refresh List"
        lang.Menu_DependencyMissing := "Dependency Missing"
        lang.Menu_InstallDependency := "Install Dependency (Equalizer APO)"
        lang.Menu_Language := "Language"
        lang.Menu_FindPresets := "Find EQ Presets (AutoEQ)"
        lang.Menu_Startup := "Start with Windows"
        lang.Menu_EditScript := "Edit Script"
        lang.Menu_ViewLog := "View Log"
        lang.Menu_Restart := "Restart Script"
        lang.Menu_Exit := "Exit"
        lang.Msg_PresetNotFound := "Could not find the last used profile, or the file is missing.`nPlease select a valid profile from the ""Switch Profile"" menu."
        lang.Msg_AutoEQ_Instructions := "Search for your model, select the ""EqualizerAPO ParametricEq"" type, and download the .txt file.`nPlace the downloaded .txt file into the presets folder."
        lang.Msg_DependencyMissing_Title := "Dependency Missing: Equalizer APO"
        lang.Msg_DependencyMissing_Body := "This tool requires Equalizer APO to function.`n`nInstallation and Configuration:`n`n1. Download and install Equalizer APO.`n2. During installation, the ""Configurator"" window will appear.`n3. Under the ""Playback devices"" tab, you MUST check all devices you wish to apply EQ to.`n`n[IMPORTANT]`n- AVOID checking options with ""Hands-Free"" in the name.`n- NOTE: If you connect your Bluetooth headphones with a cable, their name might change (e.g., 'Senary Audio'). Make sure to check that too!`n`n4. After finishing, click ""OK"" and RESTART your computer.`n5. After restarting, run this tool again.`n`n[Configuration Help]`nIf you installed Equalizer APO to a non-default location, you'll need to edit the 'settings.ini' file.`n`nDo you want to open the download page now? (This dialog will close and the settings file will be opened for you)"
        return
    }

    ; --- Load Language from File (Robust Method) ---
    ; ** 最终修正：使用 FileRead + Loop, Parse 来杜绝编译后的编码问题 **
    FileRead, langFileContent, %langFilePath%
    Loop, Parse, langFileContent, `n, `r
    {
        if RegExMatch(A_LoopField, "^\s*([^=]+?)\s*=\s*(.*)", m)
        {
            value := m2
            StringReplace, value, value, ``n, `n, All
            lang[m1] := value
        }
    }
    Log("Language loaded from: " . langFilePath)
}

CreateDefaultSettings()
{
    global SettingsPath
    settingsContent =
    ( LTrim
        [配置]
        ; 请在这里指定您电脑上 Equalizer APO 的 config.txt 文件路径
        ; 如果您不确定，它通常位于 "C:\Program Files\EqualizerAPO\config\config.txt"
        EqualizerApoConfigPath = C:\Program Files\EqualizerAPO\config\config.txt
    )
    FileAppend, %settingsContent%, %SettingsPath%
    Log("Default settings.ini created.")
}
