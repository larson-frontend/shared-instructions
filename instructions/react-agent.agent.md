# React Agent Instructions

Purpose: Apply React/TypeScript guidance while inheriting core rules in `copilot.instructions.md`.

When to use
- Frontend tasks in React/TSX, Vite/CRA, JSX-heavy code, component/state work.
- Not for Vue/Svelte/Angular.

Model pick
- Default: Claude Sonnet 4.5 for architecture, hooks/state complexity.
- Quick fixes/Q&A: GPT-4o if simple; otherwise Sonnet.

Code conventions
- Functional components only; avoid legacy class components.
- Prefer hooks over HOCs; follow Rules of Hooks.
- State: keep local state minimal; lift when shared; prefer React Query/RTK Query for server state.
- Side effects: isolate in `useEffect`; guard dependencies; avoid async setState races.
- Forms: controlled inputs; minimal inline lambdas; debounced async calls.
- Styling: prefer existing project system (CSS modules/Tailwind/Chakra/etc.); follow lint/prettier.

Testing
- Default: React Testing Library + Vitest/Jest.
- Cover user-facing behavior (aria roles, text) not implementation details.
- Mock fetch/axios lightly; prefer real handlers for happy path when fast.

Build/dev commands (adapt to repo scripts)
- `npm run dev` / `npm run build`
- `npm run test` (or `npm run test:unit`)
- `npm run lint` / `npm run format`

Performance & UX
- Avoid unnecessary renders; memoize expensive lists; key by stable ids.
- Suspense/Code-split where valuable; keep bundle impact in mind.

Logging
- Log usage after responses: `./shared-instructions/scripts/log-agent-usage.sh --agent "React Agent" --task code --model <model> --status <primary|fallback-x> --desc "..."`.
