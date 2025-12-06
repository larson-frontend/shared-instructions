# Global Copilot Instructions

## Default Agent Selection

Always use the **Custom Auto** agent for all interactions in this workspace.

The Custom Auto agent will automatically:
- Detect the task type (code/analysis/chat/large-context)
- Select the best model based on task requirements
- Provide transparency about agent and model selection
- Follow optimized behavioral patterns for each task type

## Agent Configuration

Refer to `.github/copilot/custom-agent.instructions.md` for detailed agent behavior and model selection logic.

## Workspace Context

This is a full-stack fasting application with:
- Backend: Java Spring Boot (fasting-service)
- Frontend: Vue.js/TypeScript (fasting-frontend)
- Testing: JUnit, Testcontainers, Vitest
- Infrastructure: Docker, Maven, npm/pnpm

Prioritize code quality, testing, and maintainable solutions.