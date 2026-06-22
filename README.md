<div align="center">
<h1 align="center">企鹅WIFI助手</h1>

** 随身WiFi社区的整合工具箱 **

</div>

---

#### For English documentation or detatiled information, please refer to [![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/punguin-32k/penguin-wifi-helper).

---

## 介绍 
企鹅WiFi助手 是一个专为“随身WiFi”社区开发的实用工具箱，整合了多种硬件调试和信息查看功能，
适用于多种国产随身WiFi设备（如中兴微、紫光展锐、ASR系列等）。

主要功能包括：

 · 仅通过设备网页即可快速开启 ADB、UART 等调试模式
 
 · 获取中兴微等设备的参数与分区信息
 
 · 快速修改设备参数、配置文件
 
 · 使用 dongle_fun 进行 MTD 分区刷写
 
 · 内置多种驱动与设备支持工具

## 兼容性
仅支持Windows平台使用
已测试系统版本：Windows 10 / 11

> [!NOTE]
> 由于Windows 7 / 8 / 8.1 系统的cmd过于老旧且不支持颜色等功能，现在已舍弃该版本。<br>
> 如果需要在这些系统上使用该助手请联系作者获取对应的定制版本(闭源)

## 使用方法

### ① 克隆源代码后运行
安装 Lua 5.4 环境后，在终端或 CMD 中运行以下命令：
```shell
lua.exe start_helper.lua
```
或
```shell
lua.exe helper.lua
```
> [!NOTE]
> 为避免仓库过大，第三方工具（如驱动、ADB、外部依赖）未包含在源码中<br>
> 请前往项目 Releases 页面下载依赖压缩包，并将其解压至源代码根目录。

### ② 使用编译后的版本
前往 Releases 下载"企鹅助手安装程序.exe"
安装完成后可通过桌面快捷方式或运行"home.exe"启动。

## 注意事项

1. 此程序尚不完善，可能存在一些问题，欢迎提出建议。
2. 项目中硬编码了服务器地址（用于特定模块连接），该地址已包含在开源文件"start_helper.lua"中。
3. 第三方程序已征得原作者许可,可以在附带Release,详情请参考"LICENSES\THIRD_PARTY.md"。
4. 编译后的"home.exe"实际为"start.bat"的封装版，功能一致。

## 使用须知

1. 禁止将此项目用于任何非法和不道德的行为，所造成的任何后果由使用者承担。<br/>
   且不建议将此项目用于商业用途，如遇纠纷及其他不良后果请贩卖者自行承担。
2. 本项目基于 AGPLv3 开源协议，若进行二次开发，请务必遵守其条款，并在显著位置标注原作者及项目链接。<br/>
   如需规避 AGPLv3 进行“仿制开发”，请遵循白盒净室开发流程，并注明所有参考资料。
   
## 项目说明

1. 企鹅WiFi助手旨在将圈内主流工具进行整合，降低爱好者的入门门槛，提升调试效率。
3. 项目附带的第三方工具中包含"ufiStudio系列工具（ZXIC-RomKit）"的精简旧版，详细说明见："LICENSES/ZXIC-RomKit_LICENSE.txt"。
4. 欢迎各位用户和开发者提出建议，协助完善本项目。

## 联系与贡献
如有建议、Bug 报告或想要贡献代码，请通过 Issues 或 Pull Request 与我们联系。
我们欢迎来自社区的一切改进意见与技术支持
