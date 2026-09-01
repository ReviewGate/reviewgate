# ReviewGate

**AI code review by your team's standards** — in the editor while the agent works, at the
pre-push hook, and again on the pull request.

Free. Self-hosted. Bring your own model key: the code never leaves your infrastructure,
and nothing is reported back to the vendor.

- Site and documentation: **https://reviewgate.dev**
- Live reviews on 13 real pull requests: **https://reviewgate.dev/demo**
- Русская версия: **https://reviewgate.dev/ru/**
- License: see [LICENSE](LICENSE) — free, including commercial use

This repository distributes the **releases**. The source is not published; the binaries below
are the same artifacts served from the site.

---

## Why it is not another AI reviewer

A general-purpose model tells you about SQL injection in the abstract. ReviewGate reads the
agreements your team actually wrote — the ADRs, the conventions, the rules in
`.reviewgate/config.yml` — and reports the places where this change breaks them. A finding
that quotes your own rule is one a reviewer can act on; a finding that quotes a textbook is
one they scroll past.

The review runs in three places, on the same rules and the same judge:

| Where | What it does |
|---|---|
| **CLI** | `reviewgate review` over staged, uncommitted or committed changes |
| **Pre-push hook** | refuses a `git push` that carries blocking findings |
| **MCP server** | the coding agent calls the review itself, before the request exists |
| **Bot on GitLab / GitHub** | summary, inline findings, one-click fixes, a gate on the merge |

Two passes under the hood: a cheap generator looks for problems, a stronger judge refutes
them against the code, and only what survives is published. That is what keeps the noise
down — the numbers behind it are on the site.

## Install

### CLI — one file, no Node and no Docker

Download the archive for your platform from
[the latest release](https://github.com/ReviewGate/reviewgate/releases/latest), unpack, put
it on your `PATH`:

```bash
curl -fsSLO https://github.com/ReviewGate/reviewgate/releases/latest/download/reviewgate-latest-linux-x64.xz
xz -d reviewgate-latest-linux-x64.xz
chmod +x reviewgate-latest-linux-x64 && sudo mv reviewgate-latest-linux-x64 /usr/local/bin/reviewgate
reviewgate doctor
```

Platforms: `darwin-arm64`, `darwin-x64`, `linux-x64`, `linux-x64-musl`, `linux-arm64`,
`win-x64`. Checksums are published with every release as `SHA256SUMS`.

The same files are served from the site — https://reviewgate.dev/dl/ — use whichever is
faster for you.

### Claude Code plugin

Two commands wire everything at once: the MCP tools (`get_team_rules`,
`review_changes`), a pre-push review gate, and the skills that make the agent
review its changes before calling work done. The plugin needs the CLI binary
from the section above.

```
/plugin marketplace add ReviewGate/reviewgate
/plugin install reviewgate@reviewgate
```

Or from the shell: `claude plugin marketplace add ReviewGate/reviewgate`,
then `claude plugin install reviewgate@reviewgate`.

### Bot on a pull request

```bash
curl -fsSLO https://reviewgate.dev/docker-compose.yml
docker compose up -d
```

The image is `registry.reviewgate.dev/reviewgate-bot`, mirrored on Docker Hub as
`novohudonossor/reviewgate-bot`. Full walkthrough, webhook setup and the list of environment
variables: https://reviewgate.dev/docs/install

## Where the data goes

Nowhere. The bot and the CLI talk to the model provider you configured, on your key, from
your network. There is no telemetry, no call home and no vendor account. Review metadata —
counts, severities, tokens spent — stays in your own database, and source code is never
written to logs or to disk.

How that is arranged, and how to verify it yourself: https://reviewgate.dev/security

## Support

The product is free and stays free. If it earns its place in your pipeline, the most useful
thing you can do is use it and tell a colleague: https://reviewgate.dev/donate

Questions and feedback: [@ReviewGate](https://t.me/ReviewGate) on Telegram.
