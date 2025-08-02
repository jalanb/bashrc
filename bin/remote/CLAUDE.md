# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Remote Scripts Directory

This directory (`/opt/clones/github/jalanb/bashrcs/jab/bin/remote`) is part of the larger bashrc project and contains subdirectories for organizing scripts that interact with remote hosts/servers.

### Directory Structure

Each subdirectory represents a different remote host or server environment:
- `book/` - Scripts for the "book" remote host
- `builder/` - Scripts for the "builder" remote host  
- `mac/` - Scripts for the "mac" remote host
- `mini/` - Scripts for the "mini" remote host
- `portal/` - Scripts for the "portal" remote host

### Pattern and Purpose

Based on the parent bashrc project architecture, these directories are intended to contain:
- Host-specific bash scripts and utilities
- Remote connection and management scripts
- Environment setup scripts for each remote host
- Automation scripts for remote operations

### Related Components

This directory is part of the larger jab bashrc ecosystem which includes:
- `../iterm/` - Scripts for iTerm2 profiles and AI environments
- `../` - Various utilities and helper scripts
- `../../src/bash/` - Core bash functions and utilities
- `../../src/python/` - Python utilities and scripts

### Development Guidelines

When working with remote host scripts:
1. Place host-specific scripts in the appropriate subdirectory
2. Follow the existing naming conventions from the parent project
3. Consider reusability across multiple hosts
4. Use the established bash function patterns from `../../src/bash/functons.sh`
5. Leverage existing utilities like `pong.sh` for network connectivity testing

### Common Commands

From the parent bashrc project context:
- Build/test: No specific build system identified - this is a bash scripting environment
- The project uses git for version control with custom aliases in `../../home/gitconfig`
- Scripts should be executable and follow bash best practices

### Integration

These remote scripts integrate with:
- The host detection system in `../../src/bash/hosts.sh`
- Network utilities in `../../src/bash/pong.sh`
- SSH configuration management
- The broader keyboard shortcut system in `../../src/bash/keyboard/`