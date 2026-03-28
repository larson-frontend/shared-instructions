---
applyTo: "src/routes/**/*,src/services/**/*,src/middleware/**/*,server/**/*"
description: "Use when working on API routes, services, validation, and backend architecture"
---

# Backend Rules

## API Design

- Input immer validieren (Zod, Joi, oder vergleichbar).
- Business-Logik in Services halten, nicht in Route-Handlern.
- Fehler mit einheitlichen Error-Objekten behandeln.
- HTTP Status Codes korrekt verwenden.

## Security

- Keine Secrets im Code oder in Logs.
- Externe Inputs sanitizen.
- Authentication und Authorization an zentraler Stelle prüfen.

## Datenbank

- N+1 Queries vermeiden.
- Transaktionen für zusammenhängende Operationen.
- Migrations versionieren.

## Testing

- Unit Tests für Service-Logik.
- Integration Tests für API-Endpunkte.
- Testdaten isoliert halten.
