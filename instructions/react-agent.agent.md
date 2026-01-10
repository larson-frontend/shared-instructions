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