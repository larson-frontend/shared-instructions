---
applyTo: "**/*.test.ts,**/*.test.tsx,**/*.spec.ts,**/*.spec.tsx,**/tests/**/*,**/test/**/*,cypress/**/*"
description: "Use when writing or reviewing tests — unit, integration, or E2E"
---

# Testing Rules

## Grundprinzipien

- AAA-Pattern: Arrange, Act, Assert.
- Jeder Test ist unabhängig und deterministisch.
- Beschreibende Testnamen: `should [erwartetes Verhalten] when [Bedingung]`.
- Verhalten testen, nicht Implementierung.

## Unit Tests

- Eine Einheit pro Test.
- Externe Abhängigkeiten mocken.
- Edge Cases und Fehlerfälle abdecken.

## Integration Tests

- Echte Abhängigkeiten soweit sinnvoll.
- API-Endpunkte end-to-end testen.
- Testdatenbank oder Testcontainers verwenden.

## E2E Tests

- User-Flows testen, nicht einzelne Klicks.
- Stabile Selektoren (data-testid, aria-Rollen).
- Mocks nur für externe Services.

## Coverage

- Minimum 80% für neue Features.
- 100% für kritische Business-Logik.
- Coverage als Orientierung, nicht als Selbstzweck.
