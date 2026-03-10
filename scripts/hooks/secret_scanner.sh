#!/bin/bash
# BDK Hook: Secret/Credential Scanner
# Scans file content being written for potential secrets
# Exit 0 = allow, Exit 2 = block

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')

# Get file path and content based on tool type
if [ "$TOOL_NAME" = "Write" ]; then
  FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')
  CONTENT=$(echo "$INPUT" | jq -r '.tool_input.content // empty')
elif [ "$TOOL_NAME" = "Edit" ]; then
  FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')
  CONTENT=$(echo "$INPUT" | jq -r '.tool_input.new_string // empty')
else
  exit 0
fi

# Skip non-sensitive file types
case "$FILE_PATH" in
  *.md|*.txt|*.json.example|*.template|*hooks/*.sh|*hooks/*.py)
    exit 0
    ;;
esac

# Secret patterns (regex)
SECRET_PATTERNS=(
  'AKIA[0-9A-Z]{16}'                          # AWS Access Key
  'sk-[a-zA-Z0-9]{20,}'                       # OpenAI/Stripe secret key
  'ghp_[a-zA-Z0-9]{36}'                       # GitHub PAT
  'gho_[a-zA-Z0-9]{36}'                       # GitHub OAuth
  'glpat-[a-zA-Z0-9\-]{20,}'                  # GitLab PAT
  'xox[bpors]-[a-zA-Z0-9\-]+'                 # Slack token
  'sk_live_[a-zA-Z0-9]+'                      # Stripe live key
  'rk_live_[a-zA-Z0-9]+'                      # Stripe restricted key
  'SG\.[a-zA-Z0-9_\-]+\.[a-zA-Z0-9_\-]+'     # SendGrid
  'AIza[0-9A-Za-z_\-]{35}'                    # Google API Key
  'ya29\.[0-9A-Za-z_\-]+'                     # Google OAuth
  'eyJ[a-zA-Z0-9_\-]*\.eyJ[a-zA-Z0-9_\-]*'   # JWT token
)

# Check content against patterns
for pattern in "${SECRET_PATTERNS[@]}"; do
  if echo "$CONTENT" | grep -qE "$pattern"; then
    echo "BLOCKED: Potential secret/credential detected in $FILE_PATH matching pattern: $pattern. Use environment variables or a secrets manager instead." >&2
    exit 2
  fi
done

# Check for common secret variable assignments
ASSIGNMENT_PATTERNS=(
  '(api_key|apikey|api_secret|secret_key|private_key|access_token|auth_token|password|passwd)\s*=\s*["\x27][^\s"'\'']{8,}'
  '(DATABASE_URL|MONGO_URI|REDIS_URL|AMQP_URL)\s*=\s*["\x27][^\s"'\'']+@'
)

for pattern in "${ASSIGNMENT_PATTERNS[@]}"; do
  if echo "$CONTENT" | grep -iqE "$pattern"; then
    # Exclude template/example values
    MATCH=$(echo "$CONTENT" | grep -ioE "$pattern" | head -1)
    if ! echo "$MATCH" | grep -qiE '(your_|example|placeholder|xxx|changeme|TODO|<|{)'; then
      echo "BLOCKED: Hardcoded credential detected in $FILE_PATH. Use environment variables (.env) instead of hardcoding secrets." >&2
      exit 2
    fi
  fi
done

exit 0
