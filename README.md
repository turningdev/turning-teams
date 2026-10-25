<p align="center">
  <a href="https://www.turning.work">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset=".github/assets/turning-dark.svg">
      <img alt="Turning (turning.work)" src=".github/assets/turning-light.svg" width="336">
    </picture>
  </a>
</p>

<p align="center"><strong>Write the team. Your agents take the turns.</strong></p>

# Turning Teams

Turning is a small language for describing how a team of AI coding agents takes turns. A `t()` expression names a goal, sets a number of rounds, and lists the participants in order. The Turning Teams skill ([`SKILL.md`](skills/turning-teams/SKILL.md)) teaches Claude Code, OpenAI Codex, Cursor, OpenCode, Gemini CLI, or any other [Agent Skills](https://agentskills.io) host to coordinate that plan using persistent sessions and `tmux`.

## The language

```text
t("Add a clear button to the search field", 2, builder:implementer, critic:reviewer)
```

Two agents, four turns. The builder acts first, then the critic, and they repeat that order for a second round. Each agent returns to its own session, carrying its earlier context forward.

Teams nest, and their round counts multiply the turns within them:

```text
t("Retry failed webhook deliveries", 2,
  builder:implementer,
  t:review("Check retry limits and duplicate deliveries",
    critic:correctness, critic:operations),
  builder:integrator)
```

Four agents, eight turns.

A parallel group, `p(...)`, runs its members at the same time. They do not see each other's work until the group joins at its `)`:

```text
t("Find why clearing search leaves stale results",
  p:reproduce(opus-max:browser-tester, argon-high:api-tester),
  t:diagnosis(2, opus-max:analyst, argon-high:skeptic))
```

Four agents, six turns in five steps. The browser and API testers investigate independently in step 1, and the diagnosis team weighs their findings in the four steps after the join. `team(` is the long form of `t(`, and `parallel(` is the long form of `p(`.

## What the skill coordinates

- **Plan before launch:** prints the team tree, leaf addresses (`root/01`, `root/02/01`), full turn and step schedule, parallel joins, model mapping, workspace scopes, and stopping conditions before starting any worker.
- **Persistent tmux sessions:** runs each leaf in its own `tmux` window and resumes that leaf's CLI session on later rounds; if a harness cannot resume natively, continuation is labeled as reconstructed from committed records.
- **Parallel lanes and git worktrees:** runs `p(...)` and `parallel(...)` members concurrently, keeps them blind to each other until the join, gives each parallel code writer its own git worktree, and leaves merging to a later integrator turn.
- **Context discipline and shared board:** records canonical run events in `.t/runs/<run-id>/events.jsonl`, renders `board.md` and `state.md`, sends `path:line` pointers instead of pasted files, and sends resumed warm sessions only deltas since their last turn plus open requests.
- **Round-robin review modes:** runs bounded **Debate** (multi-lens critique with counter-claims and missing evidence) or **Converge** (assumption-tested evidence relay into `working.md`) when review or diagnosis is requested.

## Install

For Claude Code:

```bash
curl -fsSL https://turning.work/install.sh | bash
```

For Codex:

```bash
curl -fsSL https://turning.work/install.sh | bash -s codex
```

For any other Agent Skills host, end the command with `bash -s ~/path/to/skills`, using that host's skills folder.

The script checks the download's sha256 and backs up any earlier install before copying; [read it first](install.sh).

Or install directly from this repository with the [Agent Skills CLI](https://skills.sh):

```bash
npx skills add turningdev/turning-teams -g
```

Or copy the folder from a clone of this repository:

```bash
mkdir -p ~/.claude/skills
cp -R skills/turning-teams ~/.claude/skills/
```

Standard global skill directories for common Agent Skills hosts:

- **Claude Code:** `~/.claude/skills` (project: `.claude/skills`)
- **Codex:** `~/.agents/skills` (project: `.agents/skills`)
- **OpenCode:** `~/.config/opencode/skills` (project: `.opencode/skills`)
- **Gemini CLI:** `~/.gemini/skills` (project: `.gemini/skills`)
- **Cursor:** `~/.cursor/skills` (project: `.cursor/skills`)
- **GitHub Copilot:** `~/.copilot/skills` (project: `.github/skills`)

Move any earlier `turning-teams` folder out of your skills folder first when copying manually. Then start a new session and run `/turning-teams` in Claude Code or `$turning-teams` in Codex.

Running a team needs `tmux`, Bash on Linux, macOS, or WSL, and the agent CLIs you name, installed and signed in.

## Learn more

- [turning.work](https://www.turning.work): overview and interactive team schedules
- [The language](https://www.turning.work/language): `t()` and `p()` grammar, counting, addresses, parallel groups and steps, the message board, and review modes
- [The skill](https://www.turning.work/skill): install steps, package contents, requirements, and what the skill has an agent do
- [SKILL.md](skills/turning-teams/SKILL.md): the complete skill instructions loaded by your agent
- [Releases](https://github.com/turningdev/turning-teams/releases): versioned `turning-teams` zip archives and sha256 digests

## License

[Apache License 2.0](LICENSE). See [NOTICE](NOTICE). If you build on it, please credit: Turning Teams skill, by JJH Digital (turning.work).
