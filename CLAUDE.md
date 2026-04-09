# Muti Repo

This is the Muti agent conductor repository. It stores Score files for projects managed by Muti.

## What is Muti?

Muti coordinates multiple Claude Code instances ("musicians") working in parallel on a project. Each musician reads a shared Score (a markdown task list in this repo), picks one task, locks it, completes it, marks it done, and exits. Musicians work in a target repo on a dedicated branch.

## Repo Contents

| File | Purpose |
|------|---------|
| `MUTI.md` | Immutable rules loaded into every musician via `--append-system-prompt-file`. Never edit this. |
| `StartupScore.md` | Template copied when starting a new project. Contains init instructions for the first musician. |
| `RunMusician` | Bash script to launch a musician. Creates the Score if new, errors if the project already exists. |
| `<ProjectName>.md` | Score files for active projects |

## Starting a New Project

From the target repo directory, run:

```
~/muti/RunMusician <ProjectName>
```

RunMusician will:
1. Check that `<ProjectName>.md` does not already exist (errors if it does).
2. Copy `StartupScore.md` to `<ProjectName>.md` in this repo.
3. Launch a musician with MUTI.md as the appended system prompt and the Score path in the startup prompt.

The first musician sees the `## Startup` section in the Score, initializes the project (asks the human for a description, creates tasks, sets up the branch), removes the `## Startup` section, commits the Score, and exits.

## Running a Musician on an Existing Project

From the target repo directory:

```
~/muti/RunMusician <ProjectName>
```

The musician reads the Score, picks an eligible task, locks it, does the work, marks it done, commits, and exits.

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
initial score for <ProjectName>
lock task <task-id> for <musician-id>
complete task <task-id>
add tasks: <task-id>, <task-id>
refine task <task-id>: <what changed>
```

**Target repo commits:**
```
[muti] <task-id>: <what was done>
```
e.g. `[muti] task-3: add user authentication endpoint`

Task IDs are sequential numbers (`task-1`, `task-2`, etc.) but uniqueness matters more than strict sequence — gaps are fine.

## Key Rules

- Musicians work only in their target repo directory and this Muti repo (for Score updates).
- All target repo work happens on the `Muti-<ProjectName>` branch. Never `main` or `master`.
- Musicians never push, fetch, or pull from any remote. The human operator handles all remote git operations.
- MUTI.md never changes. It is the rules of the game.
