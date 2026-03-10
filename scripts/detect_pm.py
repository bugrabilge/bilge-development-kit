#!/usr/bin/env python3
"""BDK Package Manager Auto-Detection

Detects the correct package manager for a JavaScript/TypeScript project.

Priority order:
  1. Lock file in project root
  2. packageManager field in package.json
  3. CLAUDE_PACKAGE_MANAGER env var
  4. Fallback: npm

Usage:
  python detect_pm.py                  # Print detected PM name
  python detect_pm.py --install        # Print install command
  python detect_pm.py --run <script>   # Print run command for script
  python detect_pm.py --test           # Print test command
  python detect_pm.py --exec <pkg>     # Print exec/dlx command
  python detect_pm.py --path <dir>     # Detect in specific directory
"""

import json
import os
import sys
from pathlib import Path


# Lock file -> package manager mapping
LOCK_FILES = {
    "bun.lockb": "bun",
    "bun.lock": "bun",
    "pnpm-lock.yaml": "pnpm",
    "yarn.lock": "yarn",
    "package-lock.json": "npm",
}

# Command mappings per PM
COMMANDS = {
    "npm": {
        "install": "npm install",
        "run": "npm run",
        "test": "npm test",
        "exec": "npx",
        "add": "npm install",
        "add_dev": "npm install -D",
    },
    "yarn": {
        "install": "yarn install",
        "run": "yarn",
        "test": "yarn test",
        "exec": "yarn dlx",
        "add": "yarn add",
        "add_dev": "yarn add -D",
    },
    "pnpm": {
        "install": "pnpm install",
        "run": "pnpm run",
        "test": "pnpm test",
        "exec": "pnpm dlx",
        "add": "pnpm add",
        "add_dev": "pnpm add -D",
    },
    "bun": {
        "install": "bun install",
        "run": "bun run",
        "test": "bun test",
        "exec": "bunx",
        "add": "bun add",
        "add_dev": "bun add -D",
    },
}


def detect_pm(project_dir: str = ".") -> str:
    """Detect package manager for the given project directory."""
    root = Path(project_dir).resolve()

    # 1. Check lock files
    for lock_file, pm in LOCK_FILES.items():
        if (root / lock_file).exists():
            return pm

    # 2. Check package.json packageManager field
    pkg_json = root / "package.json"
    if pkg_json.exists():
        try:
            data = json.loads(pkg_json.read_text(encoding="utf-8"))
            pm_field = data.get("packageManager", "")
            if pm_field:
                # Format: "pnpm@8.6.0" or "yarn@4.0.0"
                name = pm_field.split("@")[0].strip()
                if name in COMMANDS:
                    return name
        except (json.JSONDecodeError, KeyError):
            pass

    # 3. Check environment variable
    env_pm = os.environ.get("CLAUDE_PACKAGE_MANAGER", "").strip().lower()
    if env_pm in COMMANDS:
        return env_pm

    # 4. Fallback
    return "npm"


def get_command(pm: str, action: str, arg: str = "") -> str:
    """Get the full command string for a PM action."""
    cmds = COMMANDS.get(pm, COMMANDS["npm"])
    base = cmds.get(action, f"{pm} {action}")
    if arg:
        return f"{base} {arg}"
    return base


def main():
    args = sys.argv[1:]
    project_dir = "."

    # Parse --path flag
    if "--path" in args:
        idx = args.index("--path")
        if idx + 1 < len(args):
            project_dir = args[idx + 1]
            args = args[:idx] + args[idx + 2:]

    pm = detect_pm(project_dir)

    if not args:
        print(pm)
    elif args[0] == "--install":
        print(get_command(pm, "install"))
    elif args[0] == "--test":
        print(get_command(pm, "test"))
    elif args[0] == "--run" and len(args) > 1:
        print(get_command(pm, "run", args[1]))
    elif args[0] == "--exec" and len(args) > 1:
        print(get_command(pm, "exec", args[1]))
    elif args[0] == "--add" and len(args) > 1:
        print(get_command(pm, "add", args[1]))
    elif args[0] == "--add-dev" and len(args) > 1:
        print(get_command(pm, "add_dev", args[1]))
    elif args[0] == "--json":
        print(json.dumps({"pm": pm, "commands": COMMANDS[pm]}, indent=2))
    else:
        print(pm)


if __name__ == "__main__":
    main()
