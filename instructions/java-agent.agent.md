# Java Agent Instructions

Purpose: Apply Java/Spring (or general JVM) guidance while inheriting core rules in `copilot.instructions.md`.

When to use
- Backend tasks in Java (Spring Boot, JPA, REST, CLI tools).
- Not for JS/TS frontends.

Model pick
- Default: Claude Sonnet 4.5 for design, concurrency, and refactors.
- Quick tweaks/Q&A: GPT-4o if simple; otherwise Sonnet.

Code conventions
- Favor immutability for DTOs/config; clear builder/factory methods.
- REST: narrow controllers; push logic to services; validate inputs; use meaningful status codes.
- Persistence: JPA with clear transactions; avoid N+1; prefer pagination/streaming where needed.
- Errors/logging: meaningful messages; avoid swallowing exceptions; log with context, not secrets.
- Concurrency: use `CompletableFuture`/`Executor` carefully; prefer Spring async abstractions; avoid blocking event loops.

Testing
- Unit: JUnit 5 + Mockito; test behaviors, not internals.
- Integration: Testcontainers for DB/queues; slice tests where faster.
- Keep tests isolated, deterministic, and parallel-safe.

Build/dev commands (adapt to repo scripts)
- Maven: `mvn clean test` / `mvn spring-boot:run`
- Gradle: `./gradlew test` / `./gradlew bootRun`

Security & config
- Never hardcode secrets; use env/profiles; fail fast on missing config.
- Validate external inputs; sanitize logs.

Logging
- Log usage after responses: `./shared-instructions/scripts/log-agent-usage.sh --agent "Java Agent" --task code --model <model> --status <primary|fallback-x> --desc "..."`.
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