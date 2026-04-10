# Muti

Muti is an agent conductor framework for coordinating multiple Claude Code instances ("musicians") working in parallel on a software project.

Each musician reads a shared **Score** (a markdown task list), picks one task, locks it, completes it, marks it done, and waits for further instructions. Musicians work on a dedicated branch in the target repo and never interact with remote git servers — all pushes and fetches are done by the human operator.

---

## Prerequisites

- [Claude Code](https://claude.ai/code) installed and authenticated.
- This repo cloned locally.

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

## Starting a New Project

From your target repo directory, run:

```bash
runmusician <ProjectName>
```

This will:
1. Create a new Score file (`<pathToMuti>/<ProjectName>.md`) from the startup template.
2. Launch a musician who will ask you to describe the project, flesh out the tasks, and set up the working branch.

**Example:**
```bash
cd ~/code/my-repo
runmusician <ProjectName>
```

---

## Running a Musician on an Existing Project

```bash
cd ~/code/my-repo
runmusician <ProjectName>
```

The musician will read the Score, pick an eligible task, work on it, and wait for your instructions when done. You can then say:

- `Process the next task` — to have it continue.
- `Keep processing tasks until there are no more` — to run autonomously until done.


---

