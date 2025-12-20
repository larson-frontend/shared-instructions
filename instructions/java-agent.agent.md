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
