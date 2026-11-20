# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Godot 4.7 project ("test-2") using the Forward Plus renderer (D3D12 on Windows) and Jolt Physics for 3D. It is a small 2D prototype:
- `main.tscn` (the main scene): a screen-sized room (1152x648) with a `ColorRect` floor, four `StaticBody2D` walls just outside the edges, and a `Player` instance.
- `player/player.tscn` + `player/player.gd`: a `CharacterBody2D` with four-directional movement (no diagonals). If several direction keys are held, the most recently pressed one wins. Held keys are tracked in `_held` and updated by polling in `_physics_process`.
- Input actions `move_up`/`move_down`/`move_left`/`move_right` (WASD + arrow keys) are defined in `project.godot`.
- `node_2d.tscn` is the unused original starter scene.

Current state worth knowing:
- This project lives in a subfolder of a git repository (the repo root is the parent `test-1` folder, which has its own broader Godot `.gitignore`). `res://` refers to this `test-2` folder, not the repo root. The `git` command is not on PATH on this machine.

## Commands

No Godot executable is on PATH. Use the full path to the editor/console binary (referred to as `godot` below). On this machine: `C:\Users\juumy\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe` (note: the `.exe`-named path segment is a folder). On Windows, the `_console.exe` build prints output to the terminal.

```
godot --path . -e                 # open the project in the editor
godot --path . node_2d.tscn       # run a specific scene
godot --path . --headless --quit  # import resources and check scripts for parse errors
godot --path . --headless --script res://some_script.gd   # run a standalone script (must extend SceneTree or MainLoop)
```

There is no test framework, linter or export preset set up yet.

## Conventions

- Files are UTF-8 (`.editorconfig`). GDScript uses tabs for indentation, as in the editor's default template. Use static typing (`-> void`, `delta: float`).
- Reference resources with `res://` paths. Godot 4 writes `*.uid` sidecar files for scripts and `uid://` references in `.tscn` files. When you move or rename a script or resource, keep its `.uid` file with it and don't hand-edit UIDs.
- Prefer changing `project.godot`, `.tscn` and `*.import` files through the editor. If you edit them by hand, keep the existing format exactly.
- `.godot/` is a generated cache and is git-ignored. Never edit it.
