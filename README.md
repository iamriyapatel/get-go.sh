get-go.sh

A lightweight Bash utility for installing Go (Golang) seamlessly on Linux and macOS.

✨ Key Highlights

🚀 Installs the most recent stable release of Go automatically

🎯 Allows installing a specific Go version by flag

🌏 Optional China CDN mirror for faster downloads

🔄 Reinstall even if Go is already present

🏗️ Multi-architecture support: amd64, arm64, 386, ppc64le, s390x, riscv64

🖥️ Works across Linux and macOS

⚙️ Automatically configures environment variables

✅ Verifies installation on completion

📦 Requirements

curl → to fetch release files

jq → to parse release JSON

Installing jq
# Ubuntu/Debian
sudo apt update && sudo apt install jq  

# CentOS/RHEL/Fedora
sudo yum install jq  
# or
sudo dnf install jq  

# Arch Linux
sudo pacman -Sy jq  

# macOS
brew install jq  

🚀 Usage
Run directly
sudo ./get-go.sh


or via curl/wget:

curl -fsSL https://raw.githubusercontent.com/iamriyapatel/get-go.sh/main/get-go.sh | sudo bash

wget -qO- https://raw.githubusercontent.com/iamriyapatel/get-go.sh/main/get-go.sh | sudo bash

Download first, then execute
curl -fsSL -o get-go.sh https://raw.githubusercontent.com/iamriyapatel/get-go.sh/main/get-go.sh
chmod +x get-go.sh
sudo ./get-go.sh

⚙️ Options
Usage: sudo ./get-go.sh [options]

  -v, --version   Specify Go version (e.g., 1.21.3)
  -cn, --china    Use China CDN mirror
  -f, --override  Force reinstall Go
  -h, --help      Display help

🔧 Examples

Install Go 1.21.3:

sudo ./get-go.sh -v 1.21.3


Use China CDN:

sudo ./get-go.sh -cn


Force reinstall with a chosen version:

sudo ./get-go.sh -v 1.20.5 -f

🔍 How It Works

Validates parameters and dependencies

Detects latest or specified Go version

Identifies system OS/architecture

Downloads the matching binary

Removes any old Go installation

Installs Go into /usr/local/go

Adds required environment variables

Confirms installation with go version

🌍 Environment Setup

Automatically adds:

GOROOT=/usr/local/go

GOPATH=$HOME/go

Updates PATH

Updates .bashrc or .zshrc depending on shell.

🛠️ Troubleshooting

Permission denied → Run with sudo

Go not found → Restart shell or source ~/.bashrc

Slow downloads in China → Use -cn flag

Invalid version → Check format (e.g., 1.21.3)

🔐 Security

Downloads only from official Go sources (go.dev / golang.google.cn)

HTTPS enforced

Validates inputs before installation

🤝 Contributions

Improvements, bug reports, and feature requests are welcome.

📜 License

Released under GPL-3.0.
