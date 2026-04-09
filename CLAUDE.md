# Muti Repo

This is the Muti agent conductor repository. It stores Score files for projects managed by Muti.

## What is Muti?

Muti coordinates multiple Claude Code instances ("musicians") working in parallel on a project. Each musician reads a Score (a markdown task list), picks a task, locks it, completes it, and exits.

## Repo Contents

| File | Purpose |
|------|---------|
| `MasterPlan.txt` | Original design document for Muti |
| `MUTI.md` | Template system prompt file loaded by musicians via `--append-system-prompt-file` |
| `ScoreTemplate.md` | Template for creating new project Score files |
| `<ProjectName>.md` | Score files for active projects |

## Starting a New Project

1. Copy `ScoreTemplate.md` to `<ProjectName>.md` and fill it in. It can be as minimal as a description and a single task asking a musician to flesh out the plan.
2. Copy `MUTI.md` into the root of the **target repo** and fill in `<SCORE_PATH>` and `<MUTI_REPO_PATH>`.
3. Commit the Score to this repo:
   ```
   git add <ProjectName>.md
   git commit -m "initial score for <ProjectName>"
   ```

## Starting a Musician

From the target repo directory:

```
claude --append-system-prompt-file MUTI.md
```

The musician will read MUTI.md, pick a task from the Score, work on it, and exit.

## Score Commit Convention

All Score commits should have concise messages describing the change:

- `initial score for <ProjectName>`
- `lock task <task-id> for <musician-id>`
- `complete task <task-id>`
- `add tasks: <task-id>, <task-id>`
- `refine task <task-id>: <what changed>`
