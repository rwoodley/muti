# Muti

Muti is an agent conductor framework for coordinating multiple Claude Code instances ("musicians") working in parallel on a software project.

Each musician reads a shared **Score** (a markdown task list), picks one task, locks it, completes it, marks it done, and waits for further instructions. Musicians work on a dedicated branch in the target repo and never interact with remote git servers — all pushes and fetches are done by the human operator.

---

## Prerequisites

- [Claude Code](https://claude.ai/code) installed and authenticated.
- This repo cloned locally.

> **Note:** `RunMusician.sh` launches Claude with `--permission-mode acceptEdits`, which automatically accepts file read and edit operations without prompting. Bash commands that could be dangerous will still require your approval.

Add this alias to your shell profile (`.zshrc`, `.bashrc`, etc.), replacing `<pathToMuti>` with the path where you cloned this repo:

```bash
alias runmusician='~/<pathToMuti>/RunMusician.sh'
```

---

## How It Works

- The **Score** is a markdown file in this repo describing the project and its tasks.
- Each task has a status: `pending`, `locked by: <musician-id>`, or `done`.
- Musicians pick eligible tasks (respecting dependencies and avoiding tasks already locked by others), do the work in the target repo, and update the Score.
- All target repo work happens on a branch named `Muti-<ProjectName>`.

---

## Starting or Resuming a Project

From your target repo directory, run:

```bash
runmusician <ProjectName>
```

- **First run:** creates a new Score from the startup template, then launches a musician who interviews you, fleshes out the tasks, and sets up the working branch.
- **Subsequent runs:** launches a musician who reads the existing Score, picks an eligible task, works on it, and waits for your instructions when done.

You can then say:

- `Process the next task` — to have it continue.
- `Keep processing tasks until there are no more` — to run autonomously until done.


---

