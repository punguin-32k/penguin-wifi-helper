```markdown
<div align="center">
<h1 align="center">Penguin WIFI Helper</h1>

** An Integrated Toolbox for the Portable Wi-Fi Community **

</div>

---

#### ⚠️ No English documentation yet. If needed, please translate manually.

---

## Introduction  
Penguin WIFI Helper is a practical toolbox specifically developed for the "Portable Wi-Fi" community, integrating various hardware debugging and information inspection features.  
It supports a wide range of domestic portable Wi-Fi devices (e.g., ZTE ZXIC, UNISOC SPD, ASR series, etc.).

Main features include:

- Quickly enable ADB, UART, and other debug modes directly through the device's web interface  
- Retrieve parameters and partition information from ZTE ZXIC and similar devices  
- Rapidly modify device parameters and configuration files  
- Flash MTD partitions using dongle_fun  
- Built-in support for multiple drivers and device-specific utilities  

## Compatibility  
Only supports Windows platforms.  
Tested on: Windows 10 / 11

> [!NOTE]  
> Due to the outdated command prompt in Windows 7 / 8 / 8.1 lacking support for modern features like ANSI colors, these versions are no longer supported.<br>  
> If you need to use this helper on those systems, please contact the author for a customized (closed-source) version.

## Usage

### ① Run from Source Code  
After installing Lua 5.4, run the following command in your terminal or CMD:
```shell
lua.exe start_helper.lua
```
or
```shell
lua.exe helper.lua
```

> [!NOTE]  
> To keep the repository size manageable, third-party tools (e.g., drivers, ADB, external dependencies) are not included in the source code.<br>  
> Please download the dependency package from the project’s Releases page and extract it to the root directory of the source code.

### ② Use the Compiled Version  
Download **"Penguin Helper Installer.exe"** from Releases.  
After installation, launch via the desktop shortcut or by running **"home.exe"**.

## Notes

1. This program is still under development and may contain issues—suggestions are welcome.  
2. Server addresses (used by specific modules) are hardcoded and can be found in the open-source file `start_helper.lua`.  
3. Third-party programs included have been authorized by their original authors for distribution with Releases. See `LICENSES\THIRD_PARTY.md` for details.  
4. The compiled `home.exe` is simply a wrapped version of `start.bat` and provides identical functionality.

## Terms of Use

1. This project **must not** be used for any illegal or unethical purposes. Users bear full responsibility for any consequences.<br/>  
   Commercial use is **not recommended**. Any disputes or negative outcomes arising from resale or commercial deployment are the sole responsibility of the reseller.  
2. This project is licensed under **AGPLv3**. If you modify or redistribute it, you **must comply** with the license terms and clearly credit the original author and project link.<br/>  
   If you wish to develop a derivative work while avoiding AGPLv3 obligations, you must follow a clean-room (white-box) development process and document all referenced materials.

## Project Description

1. Penguin WIFI Helper aims to integrate popular community tools into a unified interface, lowering the entry barrier for enthusiasts and improving debugging efficiency.  
2. The project includes a streamlined legacy version of the **"ufiStudio toolset (ZXIC-RomKit)"**. See `LICENSES/ZXIC-RomKit_LICENSE.txt` for licensing details.  
3. Suggestions and contributions from users and developers are highly encouraged to help improve this project.

## Contact & Contributions  
For suggestions, bug reports, or code contributions, please reach out via **Issues** or **Pull Requests**.  
We welcome all community feedback and technical support!
```
