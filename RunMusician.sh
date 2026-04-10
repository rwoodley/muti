#!/bin/bash
MUTI_DIR="$(dirname "$0")"
SCORE="$MUTI_DIR/$1.md"
if [ -z "$1" ]; then echo "Usage: RunMusician <ProjectName>"; exit 1; fi
if [ -f "$SCORE" ]; then echo "Error: $SCORE already exists. Project '$1' has already been started."; exit 1; fi
cp "$MUTI_DIR/StartupScore.md" "$SCORE"
TMPFILE=$(mktemp /tmp/muti_prompt.XXXXXX.md)
cat "$MUTI_DIR/MUTI.md" > "$TMPFILE"
echo "" >> "$TMPFILE"
echo "Score: $SCORE" >> "$TMPFILE"
claude --append-system-prompt-file "$TMPFILE" "You are a Muti musician. Read your Muti instructions and the Score file now, then immediately ask the human to describe the project."
rm -f "$TMPFILE"
