#!/bin/bash
set -euxo pipefail

# Variables
PREFIX=/opt/jab
SYSTEM_PYTHON=/usr/bin/python3

# Functions

in_tmp_dir() {
    (
        cd "$(mktemp -d)"
        "$@"
        rm -rf "$(readlink -f .)"
    )
}

detect_arch() {
    uname -m
}

uv_url() {
    local arch
    arch=$(detect_arch)
    case "$arch" in
        x86_64)
            echo "https://github.com/astral-sh/uv/releases/latest/download/uv-x86_64-apple-darwin.tar.gz"
            ;;
        arm64)
            echo "https://github.com/astral-sh/uv/releases/latest/download/uv-aarch64-apple-darwin.tar.gz"
            ;;
        *)
            echo "❌ Unsupported architecture: $arch" >&2
            exit 1
            ;;
    esac
}

pull_uv_to() {
    local target_dir="$1"
    mkdir -p "$target_dir"
    local url
    url=$(uv_url)
    curl -L "$url" | tar -xz
    mv uv "$target_dir/uv"
    chmod +x "$target_dir/uv"
}

install_python() {
    "$SYSTEM_PYTHON" -m venv "$PREFIX/python"
}

make_symlinks() {
    ln -sf "$PREFIX/venv/bin/python" "$PREFIX/bin/python"
    ln -sf "$PREFIX/venv/bin/pip" "$PREFIX/bin/pip"
}

main() {
    in_tmp_dir pull_uv_to "$PREFIX/bin"
    install_python
    make_symlinks
    echo "✅ Bootstrapped uv and Python into $PREFIX"
}

main "$@"
