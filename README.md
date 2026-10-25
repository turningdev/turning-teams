<p align="center">
  <a href="https://turning.work">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset=".github/assets/turning-dark.svg">
      <img alt="turning.work" src=".github/assets/turning-light.svg" width="336">
    </picture>
  </a>
</p>

<h3 align="center">Write the team. Your agents take the turns.</h3>

Turning is a small language for describing how a team of AI agents takes turns. A `t()` expression names a goal, sets a number of rounds, and lists the participants in order. The Turning Teams skill teaches Claude Code, Codex or any other Agent Skills host to coordinate that plan using persistent sessions and tmux.

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

The script checks the download's sha256 before installing anything; [read it first](install.sh).

Or copy the folder from a clone of this repository. For Codex, use `~/.agents/skills` instead.

```bash
mkdir -p ~/.claude/skills
cp -R skills/turning-teams ~/.claude/skills/
```

Move any earlier `turning-teams` folder out of your skills folder first. Then start a new session and run `/turning-teams` in Claude Code or `$turning-teams` in Codex.

Running a team needs `tmux`, Bash on Linux, macOS or WSL, and the agent CLIs you name, installed and signed in.

## Learn more

- [turning.work](https://turning.work)
- [The language](https://turning.work/language): grammar, counting, addresses, parallel groups and steps, the message board and review modes
- [The skill](https://turning.work/skill): install steps, requirements and what the skill has an agent do
- [SKILL.md](skills/turning-teams/SKILL.md): the skill itself

## License

[Apache License 2.0](LICENSE). See [NOTICE](NOTICE). If you build on it, please credit: Turning Teams skill, by JJH Digital (turning.work).
