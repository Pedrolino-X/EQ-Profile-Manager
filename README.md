# EQ Profile Manager

A lightweight, tray-based utility for quickly switching Equalizer APO profiles.

![Screenshot](https://i.imgur.com/your-screenshot-url.png) <!-- 强烈建议您截一张图并替换此链接 -->

## ✨ Features

- **Profile Switching**: Quickly switch between your EQ presets via a tray menu.
- **Dependency Check**: Automatically detects if Equalizer APO is installed and provides guidance.
- **Smart Start**: Remembers your last used EQ profile and applies it on startup.
- **Start with Windows**: Easy toggle to run the program automatically on system startup.
- **Dynamic & Extendable**: Simply drop new `.txt` profiles or `.ini` language files into their folders to extend functionality.
- **Multi-language**: Supports multiple languages (currently English & Chinese).
- **Developer Friendly**: Provides debugging tools like "Edit Script" and "View Log" in the source version.

## 🚀 How to Use (for Users)

1.  **Download**: Go to the [Releases page](https://github.com/your-username/your-repo-name/releases) and download the latest `.zip` file.
2.  **Extract**: Unzip the file to a location of your choice.
3.  **Configure (Important!)**:
    - Open the `settings.ini` file with a text editor.
    - If you installed Equalizer APO to a **non-default location**, you must update the `EqualizerApoConfigPath` to point to your `config.txt` file.
4.  **Add Profiles**: Place your Equalizer APO `.txt` profile files into the `EQ_Presets` folder.
5.  **Run**: Double-click `EQ_Manager.exe`. The program will run in your system tray.

**Usage:**

- **Right-click** the tray icon to open the main menu.
- **Double-click** the tray icon to quickly toggle the EQ on and off.

## 🔧 How to Develop (for Developers)

1.  **Install**: Make sure you have [AutoHotkey v1.1](https://www.autohotkey.com/) installed.
2.  **Get Source**: Clone this repository or download the source code.
3.  **Run**: Execute the `/src/EQ_Manager.ahk` file.
4.  **Compile**: To create an `.exe` for distribution, use the `Ahk2Exe` compiler that comes with AutoHotkey.

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
