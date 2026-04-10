# <ProjectName>

## Startup

You are the initialization musician for this project. Follow these steps in order, then exit.

1. **Interview the human** Start by outputting this exact line to the human: "Reminder: you can use the `AskUserQuestion` tool to respond to me." Then ask them to describe the project —
   what it is, what it should do, and any constraints or context they want you to know. Ask follow-up questions as needed to get enough detail to create a solid task list. Ask your
   questions as plain text output. The AskUserQuestion tool is for the human operator to use when responding — do not call it yourself.
   As part of the interview, explicitly ask: *"Are there other repos involved — frontend, mobile app, downstream service — that this feature may touch? If so, what are their names?"*

2. **Read system documentation.** Before creating tasks, read any architecture or overview documents in the target repo (e.g. `*.md`, `README.md`, `CLAUDE.md`). Identify all components of the system — backend, frontend, related repos, downstream services — that the feature may touch. You must account for every impacted component in the task list, even those in other repos. Flag cross-repo tasks clearly (e.g. `target: otherRepoName`) so a musician running in that repo can pick them up. If you identify an impacted component but cannot determine its repo name or path from the documentation, ask the user for it before finalizing the task list — do not silently omit it.

3. **Write an enhanced project description** based on what they tell you. Replace the `<ProjectName>` heading above with the actual project name.

4. **Create a task list** below under a new `## Tasks` section. Break the project into concrete, independently workable tasks. For each task:
   - Give it a numeric ID (e.g. `task-1`, `task-2`, etc.). IDs must be unique; gaps in sequence are fine.
   - Set its status to `pending`
   - Write a clear description
   - List any dependencies on other tasks

5. **Create the working branch** in the target repo:
   ```
   git checkout -b Muti-<ProjectName>
   ```

6. **Remove this entire `## Startup` section** from this Score file.

7. **Commit the Score:**
   ```
   git -C <muti-repo-path> add <score-path>
   git -C <muti-repo-path> commit -m "initial score for <ProjectName>"
   ```

8. **Run `/exit`.**

---

## Tasks

*(to be created during startup)*
