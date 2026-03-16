#!/bin/bash
# Second Brain - Session Start Hook
# Injects today's date and active context into every new session

echo "Today's date: $(date '+%Y-%m-%d')"

# Check for active tasks
if [ -f "TASK.md" ]; then
  echo "Active task file found: TASK.md"
fi

if [ -f "PLANNING.md" ]; then
  echo "Planning file found: PLANNING.md"
fi
