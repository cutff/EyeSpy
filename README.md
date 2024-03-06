# EyeSpy

![EyeSpy Logo](https://github.com/Miiden/EyeSpy/blob/main/eyespy_logo.png)

EyeSpy is a tool designed to enumerate and gain access to IP Cameras via RTSP. It provides a flexible and efficient way to scan for open RTSP ports, discover available paths, and attempt common credential spraying attacks.

OpSec Info:
This tool is not quiet at all.

## Table of Contents

- [Introduction](#introduction)
- [Installation](#installation)
- [Usage](#usage)
- [Examples](#examples)
- [Contributing](#contributing)
- [License](#license)

## Introduction

EyeSpy is developed by Miiden and is available on [GitHub](https://github.com/Miiden). It utilizes PowerShell scripting to perform various tasks related to IP camera enumeration and access.
EyeSpy is designed to enumerate and gain access to IP Cameras via RTSP. It provides a flexible and efficient way to scan for open RTSP ports, discover available paths, and attempt common credential spraying attacks.

It is currently a work in progress and as always has a few bugs, feel free to Contribute

## Installation

There is no specific installation required for EyeSpy. Simply download or clone the script from the [GitHub repository](https://github.com/Miiden/EyeSpy) and run it using PowerShell.

## Usage

EyeSpy provides several command-line options to customize its behavior:

- `-Scan <IP/CIDR>`: Scan a single IP or CIDR range for open RTSP ports.

- `-PathScan <IP/CIDR>`: Scan for open RTSP ports and spray for common paths. Returns any camera with no authentication required, and a list of 401 and 403 responses showing possible paths, Drops 404's.
  
- `-FullAuto <IP/CIDR>`: Perform a fully automatic scan within a specified IP range (CIDR notation). This scan will find open ports, and bruteforce each 401/403 status code path with around 1000 combinations of common credentials.
  
- `-Help`: Display the help menu, showing usage instructions and examples.

## Examples


### Scan the Network Provided
```powershell
EyeSpy -Scan 192.168.0.123
```
### Path Scan
```powershell
EyeSpy -PathScan 10.0.0.0/16
```
### Full Automatic Scan
```powershell
EyeSpy -FullAuto 192.168.0.1/24
```
### Display Help
```powershell
EyeSpy -Help
```

## Contributing
Contributions to EyeSpy are welcome. Feel free to fork the repository, make improvements, and submit pull requests.

## License
EyeSpy is licensed under the [MIT](https://github.com/Miiden/EyeSpy/blob/main/LICENSE.md) License.