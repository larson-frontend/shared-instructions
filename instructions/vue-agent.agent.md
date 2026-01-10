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
---

## 📚 Learning Resources

### React Learning

**Beginner:**
- [React Official Docs](https://react.dev) — Modern React with Hooks
- [Create React App](https://create-react-app.dev) — Quickstart guide
- [React Router](https://reactrouter.com) — Client-side routing

**Intermediate:**
- [Advanced Patterns](https://react.dev/learn/render-and-commit) — Rendering & Commits
- [Hooks Deep Dive](https://react.dev/reference/react/hooks) — Custom hooks & performance
- [State Management](https://react.dev/learn/managing-state) — useState, useReducer, Context API

**Advanced:**
- [Performance Optimization](https://react.dev/learn/render-and-commit#epilogue-portals) — memo, useMemo, useCallback
- [Concurrent Features](https://react.dev/reference/react/useTransition) — Suspense, Transitions
- [Testing](https://testing-library.com/docs/react-testing-library/intro) — React Testing Library

---

### Java Learning

**Beginner:**
- [Java Official Docs](https://docs.oracle.com/javase/) — Language reference
- [Spring Boot Starter](https://spring.io/projects/spring-boot) — Getting started guide
- [Java Basics](https://docs.oracle.com/javase/tutorial/java/nutsandbolts/) — Language fundamentals

**Intermediate:**
- [Spring Data JPA](https://spring.io/projects/spring-data-jpa) — Database operations
- [REST API Design](https://spring.io/guides/gs/rest-service/) — Building REST services
- [Maven/Gradle](https://maven.apache.org/guides/) — Dependency management

**Advanced:**
- [Microservices](https://spring.io/microservices) — Spring Cloud architecture
- [Performance Tuning](https://docs.oracle.com/en/java/javase/21/performance/index.html) — JVM optimization
- [Testing](https://junit.org/junit5/docs/current/user-guide/) — JUnit 5, TestContainers