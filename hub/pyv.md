# pyv

Python version switching via `/opt/pythons` PATH manipulation

## Context

We got fed up with package managers telling us "you can't do that" when trying to install Python packages. The fundamental issue was lack of ownership - we wanted a Python installation that's completely under our control, with no tool getting in the way.

The triggering incident was `pip install html2text` landing in `/Library/Frameworks/Python.framework/Versions/3.10/bin/` which wasn't on PATH, combined with `uv` being overly opinionated about where and how to install things.

## Requirements

What we actually wanted:
- Auto-updated to a safe distance behind bleeding edge
- Old versions still available for switching
- Auto-prune patch versions (keep only latest patch in each minor)
- Auto-prune minor versions (keep only latest minor in each major)
- Locally available without permission bollocks
- Simple switching between versions - no shims, no indirection layers

## Design Decision

Rejected `pyenv` because of its shim layer - we've been there, done that, didn't want another layer of indirection that could go wrong.

Chose a simpler approach:
- Direct Python binaries in known locations: `/opt/pythons/3.11.9/bin/python3`
- Control via PATH order - latest version's bin directory goes first
- Explicit switching via bash function

## Implementation

Added to `/opt/clones/github/jalanb/bashrcs/jab/src/bash/python.sh`:

### `latest_python_bin()`

Finds most recent Python in `/opt/pythons` by:
1. Listing subdirectories
2. Reverse version sort (`sort -V -r`)
3. Checking for executable `bin/python3`
4. Returning first valid match

### `pyv()`

Switches Python version with these sub-functions:

#### `_pyv_find_exact_version()`
Handles three version pattern types:
- `pyv 3` → most recent `3.X.Y`
- `pyv 3.13` → most recent `3.13.Z`
- `pyv 3.13.1` → exactly `3.13.1`

Uses regex patterns:
- Full version (e.g., `3.13.1`): exact match `^3\.13\.1$`
- Partial (e.g., `3.13`): prefix match `^3\.13\.`
- Major only (e.g., `3`): prefix match `^3\.`

Checks for both `python3` and `python` executables. Fails with red error if multiple matches found (indicates problem under `/opt/pythons`, call sysadmin).

#### `_pyv_strip_pythons()`
Removes all `/opt/pythons/*/bin` entries from PATH using `tr` and `grep -v`.

#### `_pyv_strip_trailing_colons()`
Cleans up PATH with `sed 's/:*$//'`.

#### `_pyv_validate_first()`
Warns (yellow) if first PATH entry isn't `/opt/pythons`, indicating unexpected state.

#### `_pyv_has_spaces_in_path()`
Fails immediately if PATH contains spaces, as our manipulation logic can't handle them safely.

#### `_pyv_offer_download()`
Stub for future feature - should offer to download/compile missing versions, or suggest available alternatives. User should be able to put on coffee while it compiles.

### Startup Integration

In `~/.bashrc`'s `__main__()`, after the `bashrc` call:
```bash
local python_bin=$(latest_python_bin)
[[ $python_bin ]] && export PATH="$python_bin:$PATH"
```

This ensures latest Python is always first in PATH on shell startup, and won't be overwritten by later PATH manipulations.

## Edge Cases Handled

1. Empty PATH → valid if we just want `/opt/pythons/X.Y.Z/bin`
2. Trailing colons in PATH → stripped
3. No `/opt/pythons` directory → fails gracefully
4. Multiple matching versions → error, not silent wrong choice
5. Spaces in PATH → immediate failure with error
6. Missing python3 but has python → checks both
7. Partial version ambiguity → well-defined prefix matching

## Edge Cases Not Yet Handled

1. Symlinks in `/opt/pythons` → currently follows them, might want to verify they're valid
2. PATH is readonly → would `export PATH=` fail? Unlikely but unchecked
3. Download/compile workflow → `_pyv_offer_download()` is a stub

## Future Improvements Needed

### Version Selection UI

When user requests a version we don't have (e.g., `pyv 3.1`), we should:
1. Confirm it's really `3.1` they want (not `3.10`, `3.11`, `3.12`)
2. Offer to download and compile (estimate: under an hour probably)
3. List available alternatives with more recent versions
4. Be friendly about user confusion without mentioning PEBKAC

### Auto-Update Mechanism

Still need to design:
- How to fetch new Python versions (cron? manual script?)
- How to detect new releases (poll python.org? RSS feed?)
- How to trigger pruning of old patch versions
- How to balance "safe distance behind bleeding edge" vs "actually current"

### Pruning Logic

Need functions to:
- List all installed versions
- Identify which are latest patch in their minor version
- Identify which are latest minor in their major version
- Remove others (with confirmation?)

### Population of `/opt/pythons`

Still need to design how to actually get Pythons into `/opt/pythons`:
- Download pre-built binaries? From where?
- Use `python-build` standalone (without pyenv)?
- Compile from source with `--prefix=/opt/pythons/X.Y.Z`?
- All of the above depending on platform/availability?

### List Available Versions

Probably want `pyv -l` or similar to show what's currently installed.

## Testing Status

Currently in planning stage. No `/opt/pythons` directory exists yet. Will create it when ready to test actual switching logic.

## Usage Examples

Once implemented:

```bash
# Show current Python
pyv

# Switch to latest Python 3.13.x
pyv 3.13

# Switch to latest Python 3.x
pyv 3

# Switch to exactly Python 3.13.1
pyv 3.13.1
```

## Philosophy

This is about ownership and control. We're paying for these tools, and they should work for us, not impose arbitrary restrictions. The implementation favors simplicity and directness over cleverness - just manipulate PATH, no magic.

Part of a broader pattern of taking control of the development environment rather than accepting tool defaults.

\claude

Note the vim syntax highlighting issue we encountered during development - `[[` brackets being highlighted red in `which_python()` even though they balanced correctly. We confirmed the code worked (`source src/bash/python.sh && echo ok` succeeded) and moved on rather than debugging vim's parser confusion. Not worth the fuss.

The code emphasizes defensive programming throughout - checking directory existence, validating executables, failing with clear colored error messages (using existing `red`, `green`, `yellow` functions from `crayons.sh`).

All function names follow existing conventions in `python.sh` - using underscores, descriptive names, and `__doc__` strings where helpful.

/

## Citations

/opt/clones/github/jalanb/bashrcs/jab/src/bash/python.sh
/opt/clones/github/jalanb/jalanb/hub/hub/howtomarkdown.md
/opt/clones/github/jalanb/bashrcs/jab/hub/howtohub.md
