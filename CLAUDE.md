# Muti Repo

This is the Muti agent conductor repository. It stores Score files for projects managed by Muti.

## What is Muti?

Muti coordinates multiple Claude Code instances ("musicians") working in parallel on a project. Each musician reads a shared Score (a markdown task list in this repo), picks one task, locks it, completes it, marks it done, and exits. Musicians work in a target repo on a dedicated branch.

## Repo Contents

| File | Purpose |
|------|---------|
| `MUTI.md` | Immutable rules loaded into every musician via `--append-system-prompt-file`. Never edit this. |
| `StartupScore.md` | Template copied when starting a new project. Contains init instructions for the first musician. |
| `RunMusician.sh` | Bash script to launch a musician. Creates the Score if new, reuses it if it already exists. |
| `GH-<IssueNumber>-<ProjectName>.md` | Score files for active projects |

## Starting a New Project

From the target repo directory, run:

```
~/muti/RunMusician.sh <IssueNumber> <ProjectName>
```

A GitHub issue number is **required**. The Score file will be named `GH-<IssueNumber>-<ProjectName>.md` and all commit messages will be prefixed with `GH-<IssueNumber>-`.

RunMusician.sh will:
1. If `GH-<IssueNumber>-<ProjectName>.md` does not exist, copy `StartupScore.md` to `GH-<IssueNumber>-<ProjectName>.md`.
2. Launch a musician with MUTI.md and the Score path appended to the system prompt, using `--permission-mode acceptEdits` to skip file permission prompts.

On first run, the musician sees the `## Startup` section in the Score, interviews the human, creates tasks, sets up the branch, removes the `## Startup` section, commits the Score, and exits. On subsequent runs, the musician picks an eligible task, works on it, and waits for further instructions.

## Score Format

Tasks use inline status markers:

```markdown
- **[pending]** `task-id`: Task title
  - *Depends on:* none
  - *Description:* What needs to be done

- **[locked by: myapp-x7k2]** `task-id`: Task title
  - *Depends on:* task-1
  - *Description:* What needs to be done

- **[done]** `task-id`: Task title
  - *Depends on:* none
  - *Description:* What needs to be done
```

## Commit Conventions

**Score commits (Muti repo):**
```
GH-<IssueNumber>-initial score for <ProjectName>
GH-<IssueNumber>-lock task <task-id> for <musician-id>
GH-<IssueNumber>-complete task <task-id>
GH-<IssueNumber>-add tasks: <task-id>, <task-id>
GH-<IssueNumber>-refine task <task-id>: <what changed>
```

**Target repo commits:**
```
GH-<IssueNumber>-[muti] <task-id>: <what was done>
```
e.g. `GH-42-[muti] task-3: add user authentication endpoint`

Task IDs are sequential numbers (`task-1`, `task-2`, etc.) but uniqueness matters more than strict sequence — gaps are fine.

## Key Rules

- Musicians work only in their target repo directory and this Muti repo (for Score updates).
- All target repo work happens on the `Muti-<ProjectName>` branch. Never `main` or `master`.
- Musicians never push, fetch, or pull from any remote. The human operator handles all remote git operations.
- MUTI.md never changes. It is the rules of the game.
