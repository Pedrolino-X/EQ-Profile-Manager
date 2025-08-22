<p align="center">
  <strong>EQ Profile Manager</strong><br>
  A lightweight, tray-based utility for quickly switching Equalizer APO profiles.
</p>

<p align="center">
  <a href="#-english">English</a> •
  <a href="#-简体中文">简体中文</a>
</p>

---

![Screenshot](https://github.com/Pedrolino-X/EQ-Profile-Manager/blob/main/screenshot.png) 

---

## <a name="english"></a>🇬🇧 English

### ✨ Features

- **Profile Switching**: Quickly switch between your EQ presets via a tray menu.
- **Dependency Check**: Automatically detects if Equalizer APO is installed and provides guidance.
- **Smart Start**: Remembers your last used EQ profile and applies it on startup.
- **Start with Windows**: Easy toggle to run the program automatically on system startup.
- **Dynamic & Extendable**: Simply drop new `.txt` profiles or `.ini` language files into their folders to extend functionality.
- **Multi-language**: Supports multiple languages and allows users to add their own.
- **Developer Friendly**: Provides debugging tools like "Edit Script" and "View Log" in the source version.

### 🚀 How to Use (for Users)

1.  **Download**: Go to the **[Releases page](https://github.com/Pedrolino-X/EQ-Profile-Manager/releases)** and download the latest `.zip` file.
2.  **Extract**: Unzip the file to a location of your choice.
3.  **Configure (Important!)**:
    - Open the `settings.ini` file with a text editor.
    - If you installed Equalizer APO to a **non-default location**, you must update the `EqualizerApoConfigPath` to point to your `config.txt` file.
4.  **Add Profiles**: Place your Equalizer APO `.txt` profile files into the `EQ_Presets` folder.
5.  **Run**: Double-click `EQ_Manager.exe`. The program will run in your system tray.

**Usage:**

- **Right-click** the tray icon to open the main menu.
- **Double-click** the tray icon to quickly toggle the EQ on and off.

### 🔧 How to Develop (for Developers)

1.  **Install**: Make sure you have [AutoHotkey v1.1](https://www.autohotkey.com/) installed.
2.  **Get Source**: Clone this repository or download the source code.
3.  **Run**: Execute the `/src/EQ_Manager.ahk` file.
4.  **Compile**: To create an `.exe` for distribution, use the `Ahk2Exe` compiler that comes with AutoHotkey.

### 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## <a name="chinese"></a>🇨🇳 简体中文

### ✨ 功能亮点

- **配置切换**: 通过系统托盘菜单，快速切换您的EQ预设。
- **依赖检测**: 自动检测 Equalizer APO 是否已安装，并提供安装指引。
- **智能启动**: 记忆您上次使用的EQ配置，并在启动时自动应用。
- **开机自启**: 方便地开关程序是否随Windows系统启动。
- **动态可扩展**: 只需将新的`.txt`配置文件或`.ini`语言文件放入对应文件夹，即可扩展功能。
- **多语言**: 支持多种语言，并允许用户添加自己的语言包。
- **开发者友好**: 在源码版本中，提供了“编辑脚本”和“查看日志”等调试工具。

### 🚀 如何使用 (普通用户)

1.  **下载**: 前往 **[Releases 页面](https://github.com/Pedrolino-X/EQ-Profile-Manager/releases)** 下载最新的 `.zip` 文件。
2.  **解压**: 将压缩包解压到您选择的任意位置。
3.  **配置 (重要!)**:
    - 用文本编辑器打开 `settings.ini` 文件。
    - 如果您将 Equalizer APO 安装到了**非默认路径**，您必须将 `EqualizerApoConfigPath` 的值修改为您电脑上 `config.txt` 文件的实际路径。
4.  **添加配置**: 将您的 Equalizer APO `.txt` 配置文件放入 `EQ_Presets` 文件夹内。
5.  **运行**: 双击 `EQ_Manager.exe`。程序将在您的系统托盘区运行。

**操作方式:**

- **右键单击**托盘图标，打开主菜单。
- **双击**托盘图标，快速开启或关闭EQ。

### 🔧 如何开发 (开发者)

1.  **安装**: 确保您已经安装了 [AutoHotkey v1.1](https://www.autohotkey.com/)。
2.  **获取源码**: 克隆此仓库，或下载源代码。
3.  **运行**: 直接执行 `/src/EQ_Manager.ahk` 文件。
4.  **编译**: 如需为他人分发 `.exe` 文件，请使用 AutoHotkey 自带的 `Ahk2Exe` 编译器进行编译。

### 📜 许可证

本项目遵循 MIT 许可证 - 详情请参阅 [LICENSE](LICENSE) 文件。
