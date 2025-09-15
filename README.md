# get-go.sh

A bash script to automatically download and install the latest version of Go (Golang) on Linux and macOS systems.

## Features

- 🚀 Automatically downloads and installs the latest stable Go version
- 🎯 Supports custom Go version specification
- 🌏 China CDN support for users in China
- 🔄 Force reinstallation option
- 🏗️ Multi-architecture support (amd64, arm64, 386, ppc64le, s390x, riscv64)
- 🖥️ Cross-platform support (Linux, macOS)
- ⚙️ Automatic environment variable setup
- ✅ Installation verification

## Prerequisites

- `curl` - for downloading Go releases
- `jq` - for parsing JSON responses

### Install jq

```bash
sudo apt update && sudo apt install jq             # Ubuntu/Debian
sudo yum install jq                                # CentOS/RHEL/Fedora
sudo dnf install jq                                # CentOS/RHEL/Fedora
sudo pacman -Sy jq                                 # Arch Linux
brew install jq                                    # MacOS
```

## Usage

### Direct

Install the latest stable Go version:

```bash
sudo ./get-go.sh
```
OR
```bash
curl -fsSL https://raw.githubusercontent.com/BRAVO68WEB/get-go.sh/refs/heads/master/get-go.sh | sudo bash 
```
OR
```bash
wget -qO- https://raw.githubusercontent.com/BRAVO68WEB/get-go.sh/refs/heads/master/get-go.sh | sudo bash
```

### Download & Run

If you prefer to download first and then execute:

1. Download the script
```bash
curl -fsSL -o get-go.sh https://raw.githubusercontent.com/BRAVO68WEB/get-go.sh/refs/heads/master/get-go.sh
```

2. Add execute permissions
```bash
chmod +x get-go.sh
```

3. Execute the script
```bash
sudo ./get-go.sh
```

### Options

```
Usage: sudo ./get-go.sh [options]

Options:
  -v, --version   Specify Go version (e.g., 1.21.3)
  -cn, --china     Use China CDN (golang.google.cn)
  -f, --override  Force installation even if Go is already installed
  -h, --help      Show help message
```

### Examples

**Install a specific Go version:**
```bash
sudo ./get-go.sh -v 1.21.3
```
OR
```bash
curl -fsSL https://raw.githubusercontent.com/BRAVO68WEB/get-go.sh/refs/heads/master/get-go.sh | sudo bash -s -- -v 1.21.3
```

**Install using China CDN:**
```bash
sudo ./get-go.sh -cn
```
OR
```bash
curl -fsSL https://raw.githubusercontent.com/BRAVO68WEB/get-go.sh/refs/heads/master/get-go.sh | sudo bash -s -- -cn
```

**Force reinstall with specific version:**
```bash
sudo ./get-go.sh -v 1.20.5 -f
```
OR
```bash
curl -fsSL https://raw.githubusercontent.com/BRAVO68WEB/get-go.sh/refs/heads/master/get-go.sh | sudo bash -s -- -v 1.20.5 -f
```

## What the Script Does

1. **Validates input parameters** and checks for required dependencies
2. **Determines the Go version** to install (latest stable or specified version)
3. **Detects system architecture and OS** automatically
4. **Downloads the appropriate Go binary** from official sources
5. **Removes any existing Go installation** from `/usr/local/go`
6. **Extracts and installs Go** to `/usr/local/go`
7. **Sets up environment variables** in your shell configuration
8. **Verifies the installation** by running `go version`

## Environment Variables

The script automatically adds these environment variables to your shell configuration:

- `GOROOT=/usr/local/go` - Go installation directory
- `GOPATH=$HOME/go` - Go workspace directory
- `PATH` - Updated to include Go binaries

## Supported Platforms

### Operating Systems
- Linux
- macOS (Darwin)

### Architectures
- x86_64 (amd64)
- aarch64 (arm64)
- i386 (386)
- ppc64le
- s390x
- riscv64

## Supported Shells

The script automatically configures environment variables for:
- Bash (`.bashrc`)
- Zsh (`.zshrc`)

For other shells, you'll need to manually add `/usr/local/go/bin` to your PATH.

## Troubleshooting

### Permission Denied
Make sure to run the script with sudo privileges:
```bash
sudo ./get-go.sh
```

### Go Command Not Found After Installation
Restart your terminal or source your shell configuration:
```bash
source ~/.bashrc  # for bash
source ~/.zshrc   # for zsh
```

### Network Issues in China
Use the China CDN option:
```bash
sudo ./get-go.sh -cn
```

### Invalid Version Error
Ensure you're using the correct version format (x.y.z):
```bash
sudo ./get-go.sh -v 1.21.3  # Correct
```

## Security

- The script downloads Go directly from official sources (`go.dev` or `golang.google.cn`)
- All downloads are verified through HTTPS
- The script validates version formats and checks for file existence before installation

## Contributing

Feel free to submit issues and pull requests to improve this script.

## License

This script is provided as-is under the GPL-3.0 License.
