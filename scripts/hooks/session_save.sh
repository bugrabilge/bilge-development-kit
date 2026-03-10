#!/bin/bash
# BDK Hook: Session Context Save
# Saves a lightweight session summary on Stop event
# Used for memory persistence across sessions

INPUT=$(cat)
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // "unknown"')
CWD=$(echo "$INPUT" | jq -r '.cwd // empty')
TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path // empty')

# Memory directory
MEMORY_DIR="$CWD/.agent/.claude/memory"
mkdir -p "$MEMORY_DIR" 2>/dev/null

TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
SESSION_FILE="$MEMORY_DIR/session_$TIMESTAMP.md"

# Extract basic session info
cat > "$SESSION_FILE" << EOF
# Session: $TIMESTAMP
- **Session ID:** $SESSION_ID
- **Working Directory:** $CWD
- **Transcript:** $TRANSCRIPT_PATH
- **Saved:** $(date -Iseconds)
EOF

# Output confirmation (fed to Claude's context)
echo "Session context saved to $SESSION_FILE"

exit 0
