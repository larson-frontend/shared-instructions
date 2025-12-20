# Vue Agent Instructions

Purpose: Apply Vue 3 guidance (SFC, `<script setup>`, TypeScript) while inheriting core rules in `copilot.instructions.md`.

When to use
- Frontend tasks in Vue 3 SFCs, Vite/Nuxt-style setups, Pinia/Vuex state, composables.
- Not for React/Svelte/Angular.

Model pick
- Default: Claude Sonnet 4.5 for component/composable architecture.
- Quick tweaks/Q&A: GPT-4o if simple; otherwise Sonnet.

Code conventions
- Prefer `<script setup>` with TypeScript; keep templates declarative and lean.
- State: Pinia for shared state; avoid overusing global stores—favor props/emits when local.
- Refs/computed: keep derived data computed; avoid side effects inside computed.
- Lifecycle: prefer `onMounted`/`onBeforeUnmount` with cleanup; avoid heavy logic in templates.
- Routing: use named routes; keep guards small and reusable.

Testing
- Default: Vitest + Vue Test Utils.
- Assert rendered output/ARIA, not internals. Use stubs for heavy children.

Build/dev commands (adapt to repo scripts)
- `npm run dev` / `npm run build`
- `npm run test` (or `npm run test:unit`)
- `npm run lint` / `npm run format`

Performance & UX
- Avoid excessive watchers; prefer computed and events.
- Lazy-load routes/components where sensible; keep hydration errors out with consistent markup.

Logging
- Log usage after responses: `./shared-instructions/scripts/log-agent-usage.sh --agent "Vue Agent" --task code --model <model> --status <primary|fallback-x> --desc "..."`.
