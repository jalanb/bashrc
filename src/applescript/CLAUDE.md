# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

# AppleScript Utilities

This directory contains AppleScript utilities that automate macOS system interactions, primarily for VPN management and system administration tasks.

## Architecture

The directory contains several types of AppleScript automation:

- **VPN Management Scripts**: `connect_wwts_vpn.scpt` and `disconnect_wwts_vpn.scpt` use System Events to manage a "WWTS VPN" connection through macOS network preferences
- **System Administration**: `restore_sudo.scpt` fixes root filesystem permissions using administrator privileges
- **Application Automation**: `command-n.scpt` sends Command+N keystrokes to Xcode
- **Automator Workflow**: `Untitled 3.workflow` is a macOS Automator workflow using "Watch Me Do" actions for UI automation

## Script Execution

All `.scpt` files can be executed with:
```bash
osascript filename.scpt
```

The VPN scripts include shebang lines (`#!/usr/bin/osascript`) making them directly executable.

## Key Components

- **VPN Scripts**: Use AppleScript's System Events to interact with network preferences, checking for service existence before attempting connection/disconnection
- **Permission Script**: Uses `do shell script` with administrator privileges to reset root directory ownership and permissions
- **UI Automation**: Uses AppleScript's `key code` and System Events to send keyboard commands to applications

## Security Considerations

- `restore_sudo.scpt` requires administrator privileges and modifies system-level permissions
- VPN scripts interact with system network configuration
- All scripts use legitimate macOS automation APIs (System Events, AppleScript)