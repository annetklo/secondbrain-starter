#!/usr/bin/env python3
"""Fetch Proton Calendar ICS feed and output structured JSON for morning briefing."""

import json
import os
import sys
import urllib.request
import ssl
from datetime import datetime, timedelta, date, time

from icalendar import Calendar
import recurring_ical_events


SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
SKILL_DIR = os.path.dirname(SCRIPT_DIR)
CONFIG_PATH = os.path.join(SKILL_DIR, "config.json")

DUTCH_DAYS = {
    0: "maandag", 1: "dinsdag", 2: "woensdag",
    3: "donderdag", 4: "vrijdag", 5: "zaterdag", 6: "zondag"
}

DUTCH_MONTHS = {
    1: "januari", 2: "februari", 3: "maart", 4: "april",
    5: "mei", 6: "juni", 7: "juli", 8: "augustus",
    9: "september", 10: "oktober", 11: "november", 12: "december"
}


def dutch_date(d):
    """Format a date in Dutch: 'maandag 1 maart 2026'."""
    return f"{DUTCH_DAYS[d.weekday()]} {d.day} {DUTCH_MONTHS[d.month]} {d.year}"


def format_time(dt_val):
    """Extract HH:MM from a datetime or time object."""
    if isinstance(dt_val, datetime):
        return dt_val.strftime("%H:%M")
    if isinstance(dt_val, time):
        return dt_val.strftime("%H:%M")
    return None


def extract_event(component):
    """Extract relevant fields from an icalendar event component."""
    summary = str(component.get("SUMMARY", "Geen titel"))
    location = str(component.get("LOCATION", "")) or None
    description = str(component.get("DESCRIPTION", "")) or None

    dtstart = component.get("DTSTART")
    dtend = component.get("DTEND")

    if dtstart:
        dtstart = dtstart.dt if hasattr(dtstart, "dt") else dtstart
    if dtend:
        dtend = dtend.dt if hasattr(dtend, "dt") else dtend

    # Determine if all-day event
    all_day = isinstance(dtstart, date) and not isinstance(dtstart, datetime)

    start_time = None if all_day else format_time(dtstart)
    end_time = None if all_day else format_time(dtend)

    event = {"summary": summary, "all_day": all_day}
    if start_time:
        event["start"] = start_time
    if end_time:
        event["end"] = end_time
    if location:
        event["location"] = location
    if description and len(description.strip()) < 200:
        event["description"] = description.strip()

    return event


def fetch_calendar(ics_url, days_ahead=7):
    """Fetch ICS feed and return today's events + week ahead."""
    ctx = ssl.create_default_context()
    req = urllib.request.Request(ics_url, headers={"User-Agent": "MorningBriefing/1.0"})
    response = urllib.request.urlopen(req, context=ctx, timeout=15)
    data = response.read()

    cal = Calendar.from_ical(data)

    today = date.today()
    today_start = datetime.combine(today, time.min)
    today_end = datetime.combine(today, time.max)
    week_end = datetime.combine(today + timedelta(days=days_ahead), time.max)

    # Today's events
    today_components = recurring_ical_events.of(cal).between(today_start, today_end)
    today_events = sorted(
        [extract_event(e) for e in today_components],
        key=lambda e: e.get("start", "00:00")
    )

    # Week ahead (tomorrow through days_ahead)
    tomorrow = today + timedelta(days=1)
    week_ahead = []
    for day_offset in range(1, days_ahead + 1):
        d = today + timedelta(days=day_offset)
        d_start = datetime.combine(d, time.min)
        d_end = datetime.combine(d, time.max)
        day_events = recurring_ical_events.of(cal).between(d_start, d_end)
        if day_events:
            week_ahead.append({
                "date": d.isoformat(),
                "day": DUTCH_DAYS[d.weekday()],
                "events": sorted(
                    [extract_event(e) for e in day_events],
                    key=lambda e: e.get("start", "00:00")
                )
            })

    return {
        "today": today.isoformat(),
        "today_formatted": dutch_date(today),
        "today_events": today_events,
        "week_ahead": week_ahead,
        "error": None
    }


def main():
    # Load config
    if not os.path.exists(CONFIG_PATH):
        print(json.dumps({
            "error": "no_config",
            "message": "config.json niet gevonden. Stel eerst je Proton Calendar ICS-link in."
        }))
        sys.exit(0)

    with open(CONFIG_PATH, "r") as f:
        config = json.load(f)

    ics_url = config.get("ics_url")
    if not ics_url:
        print(json.dumps({
            "error": "no_url",
            "message": "Geen ics_url gevonden in config.json."
        }))
        sys.exit(0)

    days_ahead = config.get("days_ahead", 7)

    try:
        result = fetch_calendar(ics_url, days_ahead)
        print(json.dumps(result, ensure_ascii=False, indent=2))
    except urllib.error.URLError as e:
        print(json.dumps({
            "error": "fetch_failed",
            "message": f"Kan de kalender niet ophalen: {e}"
        }))
    except Exception as e:
        print(json.dumps({
            "error": "parse_failed",
            "message": f"Fout bij verwerken van kalenderdata: {e}"
        }))


if __name__ == "__main__":
    main()
