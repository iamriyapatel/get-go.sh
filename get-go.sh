#!/usr/bin/env bash

set -e

# Help message
HELP_MESSAGE="Usage: sudo ./get-go.sh [options]
Options:
  -v, --version   Specify Go version (e.g., 1.21.3)
  -cn, --china    Use China CDN (golang.google.cn)
  -f, --override Force installation even if Go is already installed
  -h, --help     Show this help message"

# Parse command-line options
while [[ $# -gt 0 ]]; do
    case "$1" in
        -v|--version)
            GO_VERSION="$2"
            shift 2
            ;;
        -cn|--china)
            CHINA_CDN="true"
            shift 1
            ;;
        -f|--override)
            OVERRIDE="true"
            shift 1
            ;;
        -h|--help)
            echo "$HELP_MESSAGE"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "$HELP_MESSAGE"
            exit 1
            ;;
    esac
done

# Version validation regex
if [ -n "$GO_VERSION" ]; then
    # Regex pattern for valid version string (x.y.z)
    VERSION_REGEX="^([0-9]+)\.([0-9]+)\.([0-9]+)$"
    
    if ! [[ "$GO_VERSION" =~ $VERSION_REGEX ]]; then
        echo "Invalid version format: $GO_VERSION"
        echo "Expected format: x.y.z (e.g., 1.21.3)"
        exit 1
    fi
fi

# Check if Go is installed (unless --override is set)
if [ "$OVERRIDE" != "true" ] && command -v go &> /dev/null; then
    echo "Go is already installed."
    go version
    exit 0
fi

# Check for jq installation
if ! command -v jq &> /dev/null; then
    echo "jq is not installed. Please install jq to continue."
    exit 1
fi

# Check for root permissions
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root or with sudo privileges"
    exit 1
fi

# Determine Go version
if [ -z "$GO_VERSION" ]; then
    # Get latest Go version
    if [ "$CHINA_CDN" = "true" ]; then
        GO_RELEASE_JSON=$(curl 'https://golang.google.cn/dl/?mode=json')
    else
        GO_RELEASE_JSON=$(curl 'https://go.dev/dl/?mode=json')
    fi
    GO_VERSION=$(echo "$GO_RELEASE_JSON" | jq -r '.[] | select(.stable == true) | .version' | head -n1)
    
    if [ -z "$GO_VERSION" ]; then
        echo "Failed to retrieve the latest Go version."
        exit 1
    fi
else
    # Validate custom version
    if [[ "$GO_VERSION" != "go"* ]]; then
        GO_VERSION="go${GO_VERSION}"
    fi
    
    if [ "$CHINA_CDN" = "true" ]; then
        CHECK_URL="https://golang.google.cn/dl/${GO_VERSION}.linux-amd64.tar.gz"
    else
        CHECK_URL="https://go.dev/dl/${GO_VERSION}.linux-amd64.tar.gz"
    fi
    
    if ! curl -s -f -I "$CHECK_URL"; then
        echo "Invalid Go version: ${GO_VERSION:3}"
        exit 1
    fi
fi

# Determine architecture and OS
ARCH=$(uname -m)
OS=$(uname -s | tr '[:upper:]' '[:lower:]')

# Map OS to Go's naming convention
case "$OS" in
    "linux")
        OS="linux"
        ;;
    "darwin")
        OS="darwin"
        ;;
    *)
        echo "Unsupported operating system: $OS"
        exit 1
        ;;
esac

# Map architecture to Go's naming convention
case "$ARCH" in
    "x86_64")
        ARCH="amd64"
        ;;
    "aarch64")
        ARCH="arm64"
        ;;
    "i386")
        ARCH="386"
        ;;
    "ppc64le")
        ARCH="ppc64le"
        ;;
    "s390x")
        ARCH="s390x"
        ;;
    "riscv64")
        ARCH="riscv64"
        ;;
    *)
        echo "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

# Download URL
if [ "$CHINA_CDN" = "true" ]; then
    GO_TAR_URL="https://golang.google.cn/dl/${GO_VERSION}.${OS}-${ARCH}.tar.gz"
else
    GO_TAR_URL="https://go.dev/dl/${GO_VERSION}.${OS}-${ARCH}.tar.gz"
fi
echo "Downloading Go from $GO_TAR_URL..."

# Create temporary directory
TMPDIR=$(mktemp -d)
cd "$TMPDIR"

# Download with progress bar
curl -LO# "$GO_TAR_URL"

if [ $? -ne 0 ]; then
    echo "Failed to download Go from $GO_TAR_URL"
    rm -rf "$TMPDIR"
    exit 1
fi

# Remove any existing Go installation
if [ -d "/usr/local/go" ]; then
    echo "Removing existing Go installation..."
    sudo rm -rf /usr/local/go
fi

# Extract the downloaded tarball
echo "Extracting Go..."
sudo tar -cn /usr/local -xzf "$(basename "$GO_TAR_URL")"

# Clean up
cd ..
rm -rf "$TMPDIR"

# Set up environment variables
echo "Setting up Go environment variables..."
SHELL_NAME=$(basename "$SHELL")

case "$SHELL_NAME" in
    "bash")
        echo 'export GOPATH=$HOME/go' >> ~/.bashrc
        echo 'export GOROOT=/usr/local/go' >> ~/.bashrc
        echo 'export PATH=$PATH:$GOROOT/bin:$GOPATH/bin' >> ~/.bashrc
        source ~/.bashrc
        ;;
    "zsh")
        echo 'export GOPATH=$HOME/go' >> ~/.zshrc
        echo 'export GOROOT=/usr/local/go' >> ~/.zshrc
        echo 'export PATH=$PATH:$GOROOT/bin:$GOPATH/bin' >> ~/.zshrc
        source ~/.zshrc
        ;;
    *)
        echo "Unsupported shell: $SHELL_NAME"
        echo "Please add '/usr/local/go/bin' to your PATH manually"
        ;;
esac

# Verify installation
echo "Verifying Go installation..."
if command -v go &> /dev/null; then
    echo "Go installation successful."
    go version
else
    echo "Go installation failed."
    exit 1
fi

echo "Please restart your terminal to apply the environment variable changes"
