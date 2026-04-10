#!/bin/bash
MUTI_DIR="$(dirname "$0")"
SCORE="$MUTI_DIR/$1.md"
if [ -z "$1" ]; then echo "Usage: RunMusician <ProjectName>"; exit 1; fi
if [ ! -f "$SCORE" ]; then cp "$MUTI_DIR/StartupScore.md" "$SCORE"; fi
TMPFILE=$(mktemp /tmp/muti_prompt.XXXXXX.md)
cat "$MUTI_DIR/MUTI.md" > "$TMPFILE"
echo "" >> "$TMPFILE"
echo "Score: $SCORE" >> "$TMPFILE"
claude --permission-mode acceptEdits --add-dir "$MUTI_DIR" --append-system-prompt-file "$TMPFILE" "You are a Muti musician. Read your instructions and begin the Startup Procedure now."
rm -f "$TMPFILE"
