---
name: morning-briefing
description: Generate a morning briefing with today's calendar events, upcoming schedule, and daily priorities. Use when the user starts their day, asks for a briefing, daily overview, or agenda check. Integrates with Proton Calendar via ICS feeds.
argument-hint: [--days NUMBER]
allowed-tools: Bash(python3:*), Read, Write, Glob, Grep
---

# Morning Briefing Skill

Generate a structured morning overview with today's calendar, upcoming events, and daily priorities.

## Usage

```
/morning-briefing
/morning-briefing --days 5
```

## Setup (first time)

This skill requires a Proton Calendar ICS link. See `references/setup-guide.md` for instructions.

If no config.json exists, ask the user for their ICS URL and create it:

```json
{
  "ics_url": "https://calendar.proton.me/api/calendar/v1/.../export",
  "days_ahead": 7
}
```

Save to: `~/.claude/skills/morning-briefing/config.json`

## Workflow

### Step 1: Fetch Calendar Data

Run the calendar fetch script:
```bash
python3 ~/.claude/skills/morning-briefing/scripts/fetch_calendar.py
```

If the script returns `error: no_config`, guide the user through setup (see references/setup-guide.md).

### Step 2: Format the Briefing

Present the data as a structured briefing:

**Header**: "Good morning! Here's your briefing for [date]."

**Today's Schedule**:
- List all events with times, titles, and locations
- Flag any back-to-back meetings or scheduling conflicts
- Note gaps > 1 hour as "focus time"

**Week Ahead** (next N days):
- Summarize upcoming events grouped by day
- Highlight important meetings or deadlines

**Priorities**:
- If TASK.md or PLANNING.md exists, reference active tasks
- Suggest 3 focus areas for the day based on the schedule

### Step 3: Offer Follow-up

After presenting the briefing, offer:
- "Want me to prepare for any of today's meetings?" (/meeting-prep)
- "Should I check your task list?"
- "Need me to block focus time in your schedule?"

## Language

Default: Dutch. Switch to English if the user's CLAUDE.md specifies English.

## Notes

- The fetch script requires `icalendar` and `recurring_ical_events` Python packages
- Install with: `pip3 install icalendar recurring_ical_events`
- Calendar data is fetched live each time (not cached)
- The ICS link is read-only: no one can modify your calendar through it
