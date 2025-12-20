# Global Copilot Instructions

## Default Agent Selection

**Always use the Custom Auto agent** for all interactions in this workspace.

The Custom Auto agent will automatically:
- 🎯 Detect the task type (code / analysis / chat / large-context)
- 🤖 Select the best model based on task requirements
- 📊 Provide transparency about agent and model selection
- ✨ Follow optimized behavioral patterns for each task type

---

## Model Selection Rules (Priority Order)

### **Primary Model: Claude Sonnet 4.5** (Default for most tasks)
**Use for:**
- Complex code refactoring and architecture decisions
- Deep reasoning on ambiguous problems
- Multi-file context understanding
- Long documents and large codebases
- Analysis and design planning

### **Fallback 1: GPT-4o** (Fast alternative)
**Use for:**
- Simple Q&A and quick explanations
- Straightforward code fixes
- When Sonnet unavailable or overloaded

### **Fallback 2: GPT-5.1-Codex** (Code-specific)
**Use for:**
- Syntax-heavy tasks when available
- Language-specific idioms
- When Sonnet/GPT-4o unavailable

### **Fallback 3: Claude Haiku 4.5** (Budget option)
**Use for:**
- Very simple tasks
- When all others unavailable
- Cost-sensitive scenarios

---

## Task Classification & Model Assignment

| Task Type | Model | Reasoning |
|-----------|-------|-----------|
| **Code refactoring** | Claude Sonnet 4.5 | Complex logic, architecture decisions |
| **Bug fixes** | Claude Sonnet 4.5 | Deep context, edge cases |
| **New features** | Claude Sonnet 4.5 | Design decisions, multi-file changes |
| **Analysis** | Claude Sonnet 4.5 | Deep reasoning, synthesis |
| **Quick Q&A** | GPT-4o | Speed, efficiency |
| **Documentation** | GPT-4o | Clarity, quick turnaround |
| **Code review** | Claude Sonnet 4.5 | Architecture, patterns |
| **Testing** | Claude Sonnet 4.5 | Edge cases, coverage |

---

## Workspace Context

This instruction set is project-agnostic. Adapt guidance to your stack:

- Backend: Replace with your language/framework/tooling
- Frontend: Replace with your framework/tooling
- Mobile: Include only if applicable
- Testing/Infra/Deployment: Use the tools relevant to your project

Key principles (universal):
- ✅ Prioritize code quality and maintainability
- ✅ Comprehensive testing (unit + integration)
- ✅ Security-first practices for secrets and environments
- ✅ Performance-awareness appropriate to your stack

---

## Transparency Header (Every Response)

Every Copilot response includes transparency about model choice:

```
**Agent: Custom Auto | Task: [type] | Model: [model] | Reason: [why] | Status: [primary/fallback]**
```

Example:
- `**Agent: Custom Auto | Task: code | Model: claude-sonnet-4.5 | Reason: Complex refactoring requires deep reasoning | Status: primary**`

---

## Communication Style

- Direct and concise (match response depth to task)
- Code-focused, with explanations when needed
- Clear reasoning for recommendations
- Include code examples for technical guidance

---

## Additional Resources

 - **Custom Agent Details:** `shared-instructions/instructions/custom-agent.agent.md`
 - **Agent Usage History:** `shared-instructions/docs/agent-usage.md`
- Project-specific deployment/readiness guides: See your project's documentation

---

**Last Updated:** December 13, 2025