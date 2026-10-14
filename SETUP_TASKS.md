# Setup Script Task Backlog

This backlog captures the improvements identified during the setup-script review. It is intentionally planning-only; implementation is split into reviewable tasks.

## Current tool choices

- Keep Thaw as the menu-bar utility; do not install Bartender.
- Use OrbStack for containers; do not install Docker Desktop or the `docker` cask.
- Keep Docker-compatible CLI behavior only where it is provided by OrbStack or otherwise explicitly required.

## Priority 0 — make macOS bootstrap safe

### M01 — Bootstrap Homebrew before Homebrew-dependent helpers

- Move the Homebrew existence/install/PATH setup before the first call to `install_if_not_exists`.
- Ensure the script works on a clean Apple Silicon and Intel machine.
- Add a clear prerequisite failure when network access, sudo, or Homebrew installation is unavailable.

### M02 — Replace the current resume mechanism with real step resumption

- Define stable step identifiers.
- Skip completed steps when the user chooses resume.
- Write progress atomically and use a per-user/per-run state path rather than the shared `/tmp/setup_resume`.
- Preserve the state on failure and remove it only after successful completion or an explicit reset.

### M03 — Make downloads and temporary files safe

- Use a dedicated temporary directory created by the script.
- Add `curl --fail --show-error --location` (or equivalent) to all required downloads.
- Clean only files created by this run.
- Avoid deleting arbitrary `*.pkg` or `*.tmp` files in the caller’s working directory.

### M04 — Repair Homebrew permissions and diagnostics handling

- Add a preflight check that reports whether the current user can write to the Homebrew prefix, Cellar, Caskroom, and cache.
- Stop with an actionable message when permissions are insufficient.
- Treat unavailable Homebrew API/network access as a setup failure with a useful explanation.
- Verify formula and cask tap availability before attempting installation.

## Priority 1 — preserve user state and make installs repeatable

### M05 — Make package detection explicit and idempotent

- Distinguish `brew list --formula` from `brew list --cask`.
- Quote package arguments.
- Make repeated runs skip already-installed packages reliably.
- Keep the package catalog aligned with the current choices: Thaw included, Bartender excluded; OrbStack included, Docker Desktop excluded.

### M06 — Make configuration backups non-destructive

- Back up `.zshrc` and `.gitconfig` using collision-free timestamps or a dedicated backup directory.
- Never overwrite an existing backup.
- Preserve unrelated Git configuration instead of replacing `.gitconfig` wholesale.
- Make the personal Git name/email opt-in or configurable.

### M07 — Make shell configuration architecture-aware

- Resolve Homebrew paths with `brew --prefix`.
- Resolve the installed .NET path instead of hard-coding `/usr/local/share/dotnet`.
- Configure NVM using the actual Homebrew prefix and ensure the shell setup matches zsh.
- Quote paths and verify the selected shell is available before calling `chsh`.

### M08 — Handle optional tooling correctly

- Install Git LFS if the generated Git configuration enables it, or omit the LFS filter until explicitly selected.
- Make AWS CLI installation idempotent and architecture-aware.
- Keep .NET LTS discovery resilient to metadata changes and verify the downloaded package before installation.
- Support non-interactive execution with a documented mode or clear refusal.

## Priority 1 — align documentation and behavior

### M09 — Reconcile README and script interface

- Either restore the documented `--no-*` flags or update the README to describe the interactive menu.
- Document the current Thaw and OrbStack choices.
- Document prerequisites, network requirements, sudo prompts, backup behavior, and resume behavior.
- Remove claims about automatic backup or resume until those features are implemented and tested.

## Priority 2 — repair Linux setup scripts

### L01 — Fix Linux entrypoint and shell portability

- Correct the `snapInstall.sh` filename/case mismatch.
- Run scripts relative to the repository/script location rather than the caller’s current directory.
- Add strict error handling, quoting, prerequisite checks, and a consistent sudo strategy.

### L02 — Repair Snap installation helper

- Pass through package options such as `--classic`.
- Use a valid Snap install invocation.
- Detect installed snaps using Snap metadata rather than only `which`.

### L03 — Repair Linux .NET installer

- Fix the concatenated `dpkg`/`apt` command.
- Stop pinning the repository to Ubuntu 20.04.
- Select a supported SDK/runtime version and make the install repeatable.

### L04 — Repair Linux zsh installer

- Replace undefined `info` and `success` calls or define them.
- Make oh-my-zsh and plugin installation idempotent.
- Avoid overwriting an existing `.zshrc` without a backup.

### L05 — Modernize Linux package/repository setup

- Replace deprecated `apt-key` usage for Docker and Yarn repositories.
- Add repository signing-key validation and architecture/distribution checks.
- Clean up downloaded packages after successful installation.

## Validation task

### V01 — Test in disposable environments before implementation merge

- Run shell syntax checks and ShellCheck.
- Test macOS paths with Homebrew already installed and on a clean-machine simulation.
- Test interrupted/resumed runs.
- Test reruns with existing `.zshrc`, `.gitconfig`, packages, and backups.
- Test Linux scripts on a supported Ubuntu image.
- Confirm the final package catalog does not install Bartender or Docker Desktop.
