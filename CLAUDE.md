# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal dotfiles/configuration repository. The primary artifact is `emacs/init.el` — a heavily customized Emacs configuration. Other configs are relatively minimal.

## Symlinking

`link.sh` (zsh script) creates symlinks for: `screenrc`, `vimrc.local`, `gitconfig`, `zshrc`, `nethackrc`. It also creates `~/.emacs.d/` and symlinks `init.el` into it. Fish (`config.fish`) and Helix (`helix/config.toml`) must be symlinked manually to their XDG config locations.

Run it with: `zsh link.sh`

## Emacs Configuration Architecture

`emacs/early-init.el` — Runs before packages load. Suppresses GC during startup (restored at end of `init.el`), disables toolbar, sets frame defaults.

`emacs/init.el` — Main config. Requires Emacs 30+. Uses built-in `use-package` with MELPA. Structured with comment-header sections (`;;; --------------------[ Section ]---`).

**Platform guards**: `my-laptop-p` (macOS/darwin), `my-work-machine-p` (Windows/nt). Some packages (pulsar) are skipped on Windows.

**Key architectural choices**:
- Evil mode with `SPC` leader (normal state)
- Completion stack: vertico (minibuffer) + corfu (in-buffer) + orderless (matching style) + consult (enhanced commands) + embark (actions) + marginalia (annotations)
- LSP via eglot (built-in)
- Notes/PKM: denote + denote-journal, rooted at `~/memex/`; org-agenda pulls from gtd.org, todo.org, and files matching `_area` or `_project` patterns
- LLMs: ellama with ollama backend (gemma3, llama3, qwen3, deepseek models)
- `custom.el` is kept separate from `init.el` (written to `~/.emacs.d/custom.el`)
- Backups redirected to `~/.emacs.d/backup/` to avoid littering

**Comment header convention** for new sections in init.el:
```elisp
;;; --------------------[ Section Name ]---------------------------------------
```
Use `insert-comment-header` (interactive function) or `fill-to-eol` to generate these.
