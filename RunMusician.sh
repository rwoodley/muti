#!/bin/bash
MUTI_DIR="$(dirname "$0")"
SCORE="$MUTI_DIR/$1.md"
if [ -z "$1" ]; then echo "Usage: RunMusician <ProjectName>"; exit 1; fi
if [ -f "$SCORE" ]; then echo "Error: $SCORE already exists. Project '$1' has already been started."; exit 1; fi
cp "$MUTI_DIR/StartupScore.md" "$SCORE"
claude --append-system-prompt-file "$MUTI_DIR/MUTI.md" --append-system-prompt "Score: $SCORE"
