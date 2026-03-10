# Development Mode Context

> Active when writing new code, iterating on features, or prototyping.

---

## Priorities

1. **Working code first** - Get it running, then optimize
2. **Fast feedback loops** - Use hot reload, watch mode, dev servers
3. **Debug-friendly output** - Verbose logging during development
4. **Incremental progress** - Small commits, frequent verification

## Behavior Adjustments

- Prefer `console.log` / `print()` for quick debugging (clean up before commit)
- Use dev-only environment variables (`NODE_ENV=development`)
- Skip heavy optimizations (minification, tree-shaking) during dev
- Enable source maps for easier debugging
- Use mock data when external APIs are unavailable

## Dev Server Commands

Use `detect_pm.py` for the correct package manager:
```bash
python .agent/scripts/detect_pm.py --run dev
python .agent/scripts/detect_pm.py --run start
```

## Error Handling

- Show full stack traces in development
- Use descriptive error messages
- Log request/response bodies for API debugging
- Enable hot module replacement (HMR) when available

## Quick Checks During Development

- `python .agent/scripts/checklist.py .` - Run core checks
- `python .agent/scripts/auto_preview.py start` - Start dev server
