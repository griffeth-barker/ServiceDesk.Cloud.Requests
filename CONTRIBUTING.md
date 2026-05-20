# Contributing

## Development Setup

1. **Clone the repo** and open the root in your editor.
2. **PowerShell 7+** is required. Install from [aka.ms/powershell](https://aka.ms/powershell) if needed.
3. **Install dependencies:**

```powershell
Install-Module platyPS -Scope CurrentUser
Install-Module Pester  -Scope CurrentUser -MinimumVersion 5.0
```

4. **Import the module locally:**

```powershell
Import-Module ./ServiceDesk.Cloud.Requests/ServiceDesk.Cloud.Requests.psd1 -Force
```

## Project Layout

```
.
├── ServiceDesk.Cloud.Requests/   # Module root
│   ├── Classes/                # Output classes (load order via numeric prefix)
│   ├── Private/                # Internal helpers (not exported)
│   ├── Public/                 # Exported functions (one file per cmdlet)
│   └── en-US/                  # Compiled MAML help (generated — do not edit)
├── docs/
│   └── en-US/                  # platyPS Markdown source (edit these)
├── tests/                      # Pester tests
├── build.ps1                   # Build script
├── CONTRIBUTING.md
└── README.md
```

## Adding a New Function

1. Create a `.ps1` file in `Public/` named after the cmdlet (`Verb-SDPNoun.ps1`).
2. Use an approved verb (`Get-Verb` to check). Use the `SDP` prefix on all nouns.
3. Add `[CmdletBinding(SupportsShouldProcess)]` for any function that modifies state. Use `ConfirmImpact = 'High'` on `Remove-*` functions.
4. Declare `[OutputType('TypeName')]` using a string (not a type literal) to avoid parse-time resolution issues with dot-sourced classes.
5. Add comment-based help with at minimum `.SYNOPSIS`, `.PARAMETER` for each parameter, and at least one `.EXAMPLE`.
6. Register the function name in `FunctionsToExport` in `ServiceDesk.Cloud.Requests.psd1`.
7. Run the build script to regenerate docs.

## Adding a New Output Class

1. Add a new numbered `.ps1` file in `Classes/` (e.g. `011-SDPNewThing.ps1`). The numeric prefix controls load order.
2. Use `[SDPReference]` for `{id, name}` sub-objects and `[SDPUtil]::ParseTime()` for epoch-millisecond timestamps.
3. Add a `[pscustomobject]$RawData` property and assign the full API response object to it in the constructor.

## Updating Documentation

After changing comment-based help or adding new functions, regenerate the docs:

```powershell
./build.ps1 -Task Docs
```

The Markdown files in `docs/en-US/` are the source of truth. The MAML XML in `ServiceDesk.Cloud.Requests/en-US/` is compiled output — always regenerate it via `build.ps1` rather than editing it directly.

## Running Tests

```powershell
./build.ps1 -Task Test
```

Or run Pester directly:

```powershell
Invoke-Pester ./tests/ -Output Detailed
```

## Pull Request Guidelines

- Keep each PR focused on a single concern.
- All new public functions must have comment-based help and at least one Pester test.
- Run `./build.ps1` (all tasks) before opening a PR and confirm it completes without errors.
- Use past-tense commit messages that describe *what changed and why* (e.g. `Add Set-SDPRequestTask to support task updates`).
