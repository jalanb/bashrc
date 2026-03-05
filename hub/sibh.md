# Sibh

sibh is an intelligent command completion overlay - like fzf but for the entire command ecosystem

## Context

sibh arose from a chat like this:

\alan

I'm using `bash` via `iTerm2`

Gimme 3 way to unobstrusively take over the user's typing experience

/

\claude

Three approaches: readline library hijacking, TTY layer interception, or iTerm2 plugin/accessibility APIs for direct input handling.

/

\alan

I'm building my day-by-day command line

Y'know the way `fzf` takes over the screen to show lotsa search possibilities?
* something similar for builtins, files, aliases, functions, ...
* help user to choose commands (version 2: and args)

/

\claude

Ah, you're building an intelligent command completion overlay! Like `fzf` but for the entire command ecosystem.

**iTerm2 Python API approach:**
- **KeystrokeMonitor** - monitors keystrokes and can intercept them before bash sees them
- **KeystrokeFilter** - can disable regular handling of specific keystroke patterns

/

\alan

> we'll be using `textual`

Can you spot an existing project that we could add it as a feature to?

I do feel drawn to `~/jab/bin` (i.e. `/opt/clones/github/jalanb/bashrcs/jab/bin`)

Because:
* i was emphasizing "my shell"
* that project is primarily to set up my shell

/

\claude

Absolutely right - `~/jab/bin` is the perfect spot for this.

You're building **your shell enhancement**, and `bashrcs/jab` is literally your shell setup project.

So we're looking at:
- `~/jab/bin/command_picker` (or whatever we call it)  
- Python script using iTerm2 API + Textual
- ESC to bail back to normal bash

/

\alan

> What should we call this thing?

What kinds of things (IRL) live in shells, and are helpful?

/

\claude

**Shell helpers/tools:**
- **Pick** (for picking things)
- **Sieve** (for filtering)

My gut says **`pick`** - simple, direct, and fits perfectly with "pick a command".

/

\alan

I want something that sounds more like it's used with a "shell", so with the "sh" sound

So: "shiv"

Which is the kinda tool that ppl would be surprised to find you with
* and might be very helpful to the user
* others: not so much

Is the name in use by other tools?

If so - we'll use an Irish-like spelling

/

\claude

**`shiv`** is definitely taken! LinkedIn's `shiv` is a major Python tool for building self-contained zipapps.

Time for that Irish-like spelling:
- **`sibh`** (Irish: "you plural") - pronounced like "shiv"

I like **`sibh`** - it's authentic Irish (means "you all"), pronounced exactly like "shiv", short to type, and unlikely to conflict with anything.

/

\alan

I like "sibh" too

/

## Idea

sibh is a shell command picker that provides an fzf-style overlay interface for discovering and selecting commands in your terminal. It intercepts keystrokes via iTerm2's Python API and displays a Textual-based interface showing available commands (builtins, aliases, functions, executables), allowing users to filter and select rather than type from memory. Think of it as an intelligent command completion system that takes over the entire screen when triggered, then hands the selected command back to bash for execution. ESC returns to normal shell operation.

## Architecture

### Core Components

- **`~/jab/bin/sibh`** - minimal main executable, calls `main()` only
- **`~/jab/src/python/site/sibh.py`** - orchestration layer, integrates with site-specific utils
- **`pysyte/` additions** - reusable iTerm2 + Textual components for general use

### Integration Approach

Two potential approaches under consideration:

1. **iTerm2 Python API** - KeystrokeMonitor intercepts input, shows overlay proactively
2. **Bash Hook** - integrate with existing `post_pses()` function in `prompt.sh`

The iTerm2 approach is cleaner as it keeps bash completely unaware and lets iTerm2 handle orchestration.

### Data Sources

- Bash builtins, aliases, functions
- PATH executables  
- Scripts registered in existing `script_path.py` registry
- Recent command history
- Current directory files (for arguments)

### User Interface

Textual-based overlay that:
- Expands upward from command prompt (fzf-style)
- Filters options as user types
- Shows categorized results (builtins, aliases, functions, etc.)
- Supports keyboard navigation
- ESC to cancel, Enter to select

## Technical Considerations

### Textual Components

Split between general (in pysyte) and app-specific (in site/):
- **General**: iTerm2 integration, basic filtering widgets, command discovery
- **App-specific**: site-specific command sources, personal aliases/functions

### Prompt Integration

The existing prompt ecosystem in `bashrcs/jab/src/bash/prompt.sh` provides:
- `post_pses()` hook point after prompt setup
- `PROMPT_COMMAND` integration
- Color and status management

sibh can leverage this existing infrastructure.

### Command Discovery

Utilize existing infrastructure:
- `site/script_path.py` for script registry
- Bash completion mechanisms
- PATH scanning
- History parsing

## File Layout

```
~/jab/
├── bin/
│   └── sibh                    # Main executable, handles `sys` for the app
├── src/python/site/
│   └── sibh.py                 # Expands the main logic of the app, introduces dependencies, ...
└── hub/
    └── sibh.md                 # This design doc

~/pysyte/
├── iterm/
│   ├── __init__.py
│   └── api.py                  # iTerm2 Python API wrappers
└── textual/
    ├── __init__.py
    ├── command_picker.py       # General command picking widget
    └── overlay.py              # Screen overlay management
```

## Implementation Phases

### Phase 1: Minimal Viable Product
- Basic `~/jab/bin/sibh` that launches
- Simple Textual app showing "Hello World" overlay
- ESC to exit

### Phase 2: Command Discovery  
- Scan PATH for executables
- Read bash aliases and functions
- Basic filtering interface

### Phase 3: iTerm2 Integration
- KeystrokeMonitor integration
- Proactive triggering after prompt
- Command execution handoff

### Phase 4: Enhanced Features
- History weighting
- Argument completion
- Category-based organization
- Configuration options

## Testing Strategy

- Unit tests for command discovery logic
- Integration tests with sample bash environments  
- Manual testing in controlled iTerm2 profile
- Doctest-style tests following jab Python project patterns

## Prior Art

- `fzf` - fuzzy finder interface pattern tat has a good overlaying UI
- `whyp` - an enhance version of `type`, can help with command discovery/categorisation/...
- iTerm2 Python API examples - keystroke monitoring
- Textual apps - terminal UI patterns

## Name Etymology

`sibh` (pronounced "shiv") is Irish for "y'all", while sounding like a sharp, helpful tool. The name is completely available across PyPI, GitHub, and general programming tool namespaces.
