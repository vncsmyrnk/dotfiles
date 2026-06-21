# Agent Instructions for Dotfiles Repository

This file contains custom instructions and behavioral rules that all AI agents MUST strictly follow when working within this workspace.

## 1. Repository Goal & Philosophy
- **Modular Configurations:** This repository is simply a collection of specific, isolated configuration submodules (repos) representing different tools (e.g., `nvim`, `zsh`, `tmux`).
- **Opt-in Architecture:** The user can opt to use or completely ignore any specific configuration.
- **CLI Management:** The repository is meant to be automatically managed via CLI helper scripts and commands, rather than manual intervention.
- **Install Instructions:** Installation of these configuration modules and recipes is handled via `make`.

## 2. Non-Negotiable Workflow Rules

### 2.1. Ask Before Acting (No Undocumented Assumptions)
- **Clarify Requirements:** If the user requests something that introduces a new, undocumented requirement or requires you to make assumptions, you MUST ask the user for clarification before proceeding. Do not guess.

### 2.2. Plan Before Editing
- **Enforced Planning:** Before making ANY code or configuration edits, you MUST present a clear, step-by-step plan to the user.
- **Wait for Approval:** You are strictly prohibited from executing edits until the user has reviewed and explicitly approved the proposed plan.

### 2.3. Strict Shellcheck Verification
- **Zero-Tolerance Linting:** Any modifications or additions to shell scripts (including `dotfiles.sh` or any bash files) MUST be verified with strict linting.
- **Run Shellcheck:** Always run `shellcheck <filename>` after writing shell code.
- **No Warnings:** Code must pass `shellcheck` with zero errors and zero warnings before the task can be considered complete.

### 2.4. Zsh Autocompletion Synchronization
- **Mirror CLI Changes:** The `_dotfiles` script must always be kept perfectly synchronized with any changes to the arguments, flags, or commands in `dotfiles.sh`.

### 2.5. GNU Make Conventions
- **Strict Compliance:** The `Makefile` must strictly abide by standard GNU Make conventions (e.g., proper use of `PREFIX`, `DESTDIR`, `bindir`, `datarootdir`, and standard target names).

### 2.6. Persist Architectural Decisions
- **Document Everything:** If a new workflow, architectural, or design decision is established during a task, you MUST explicitly document it. 
- **Cross-Reference:** This documentation must be written into an appropriate file within the repository (or directly within this `AGENTS.md` file). If documented elsewhere, it MUST be explicitly cross-referenced here in `AGENTS.md` so future agents are immediately aware of the decision.
