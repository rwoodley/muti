#!/bin/bash
MUTI_DIR="$(dirname "$0")"
if [ -z "$1" ] || [ -z "$2" ]; then echo "Usage: RunMusician <IssueNumber> <ProjectName>"; exit 1; fi
ISSUE="$1"
PROJECT="$2"
SCORE="$MUTI_DIR/GH-${ISSUE}-${PROJECT}.md"
if [ ! -f "$SCORE" ]; then cp "$MUTI_DIR/StartupScore.md" "$SCORE"; fi
TMPFILE=$(mktemp /tmp/muti_prompt.XXXXXX.md)
cat "$MUTI_DIR/MUTI.md" > "$TMPFILE"
echo "" >> "$TMPFILE"
echo "Score: $SCORE" >> "$TMPFILE"
claude --permission-mode acceptEdits --add-dir "$MUTI_DIR" --append-system-prompt-file "$TMPFILE" "You are a Muti musician. Read your instructions and begin the Startup Procedure now. The GitHub issue number for this project is GH-${ISSUE}."
rm -f "$TMPFILE"
