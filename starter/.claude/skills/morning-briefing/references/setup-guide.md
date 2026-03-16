# Proton Calendar ICS-link instellen

Om je agenda op te halen heb je een openbare ICS-link nodig van Proton Calendar.

## Stappen

1. Ga naar [calendar.proton.me](https://calendar.proton.me)
2. Klik op **Instellingen** (tandwiel-icoon)
3. Ga naar **Kalenders** en kies de kalender die je wilt delen
4. Zoek de optie **Deel via link** (of "Share via link")
5. Maak een nieuwe link aan (kies "Volledige details" zodat alle event-informatie beschikbaar is)
6. Kopieer de gegenereerde URL (eindigt op `.ics`)

## Link opslaan

Geef de ICS-link aan Claude en die slaat het op in `config.json`. Je kunt ook handmatig het bestand aanmaken:

```json
{
  "ics_url": "https://calendar.proton.me/api/calendar/v1/..../export",
  "days_ahead": 7
}
```

Locatie: `~/.claude/skills/morning-briefing/config.json`

## Meerdere kalenders

Als je meerdere kalenders wilt combineren, kun je meerdere ICS-links opgeven:

```json
{
  "ics_urls": [
    "https://calendar.proton.me/api/.../werk",
    "https://calendar.proton.me/api/.../prive"
  ],
  "days_ahead": 7
}
```

(Multi-kalender support is een toekomstige uitbreiding.)

## Privacy

De ICS-link is read-only: niemand kan via deze link afspraken wijzigen. Je kunt de link op elk moment intrekken in Proton Calendar-instellingen.
