# PiHole-DNS

**Purpose:** Pi-Hole DNS server on Raspberry Pi with observability, local DNS management, and a custom wrapper application  
**Version:** v0.1.0  
**Last Updated:** 2026-04-18  
**Status:** 🟢 Layer 0 complete — Layer 1 (Usable) next

---

## Overview

A personal infrastructure project running [Pi-Hole](https://pi-hole.net/) on a Raspberry Pi 5 for DNS-level ad blocking, custom local DNS records, and home network observability. Built with platform engineering practices (configuration management, containerization, monitoring) as a learning exercise aligned with an apprenticeship rotation.

### Goals

1. **Working DNS server** — Pi-Hole running in Docker, resolving DNS for opt-in devices
2. **Local service discovery** — Custom DNS records (`files.home`, `pihole.home`) instead of raw IPs
3. **Observability** — Dashboards and monitoring that keep the project engaging beyond initial setup
4. **Platform engineering practice** — Configuration management, container orchestration, GitOps patterns

---

## Operator quickstart

Run Pi-hole from this repo on the Pi (**Track A** — no mise, private registry, or CI required for the minimum path):

1. **Clone** — `git clone https://github.com/grimm00/PiHole-DNS.git` · `git pull` for updates.
2. **Secrets** — Copy [`.env.example`](.env.example) to **`.env`** and set `FTLCONF_webserver_api_password` (see [`docker-compose.yml`](docker-compose.yml)). Never commit `.env`.
3. **Volumes** — `mkdir -p etc-pihole etc-dnsmasq.d` in the repo root on first run.
4. **Up** — `docker compose pull` when you need images from the registry (first clone, after you change the `image:` line or digest in Compose, or when updating); skip if the images you want are already on the machine. Then `docker compose up -d`.
5. **Verify** — `docker compose ps`, open the Pi-hole admin UI, point **one** test client at the Pi for DNS.

**Prerequisites:** Stable LAN IP ([DHCP reservation or static](docs/maintainers/research/layer-0-foundation/research-stage-1-stable-addressing.md)); [Docker](https://docs.docker.com/engine/install/debian/) and [Compose](https://docs.docker.com/compose/install/linux/) on the Pi.

**Full procedures** (backup, Teleporter, rollback order, digest pin): **[Runbooks](docs/runbooks/README.md)** — start with [Minimum deploy](docs/runbooks/minimum-deploy.md) and [Backup and restore](docs/runbooks/backup-and-restore.md). **Documentation map:** [`docs/README.md`](docs/README.md).

---

## Roadmap

Summary only — **full layers, open questions, and cross-cutting tracks** live in [`docs/roadmap.md`](docs/roadmap.md).

| Layer | Name | Description | Status |
|-------|------|-------------|--------|
| 0 | **Foundation (MVP)** | Static IP, Pi-Hole in Docker Compose, DNS working for one device | ✅ Complete |
| 1 | Usable | Custom local DNS records, OurFileServer in same Compose stack | 🟡 Next |
| 2 | Observable | Platform monitoring (container health, Pi resources) + Pi-Hole analytics | Planned |
| 3 | Application | Custom wrapper app/dashboard tying everything together | Future |
| — | K3s Migration | Migrate from Docker Compose to K3s (lightweight Kubernetes) | Future |

---

## Infrastructure

### Target Environment

- **Hardware:** Raspberry Pi 5
- **OS:** Raspberry Pi OS
- **Container runtime:** Docker + Docker Compose
- **Network:** Pi on **Ethernet**; static IP (or DHCP reservation) required for stable DNS targeting
- **Storage:** SD card (OS) + external drive (data)

### Existing Services

- [OurFileServer](https://github.com/grimm00/OurFileServer) — Filebrowser, already running on the Pi

### Deployment Model

GitOps-lite: this repo is the source of truth. The Pi pulls container images from a registry. No manual SSH-and-edit drift.

### Layer 0 — Deploy and operate

Use **[Operator quickstart](#operator-quickstart)** above for the short loop. Detailed steps (verification, image digest pinning, upgrades) live in **`docs/runbooks/`** — see the [runbooks index](docs/runbooks/README.md), [Minimum deploy](docs/runbooks/minimum-deploy.md), and [Backup and restore](docs/runbooks/backup-and-restore.md). Upstream reference: [Pi-hole — Docker upgrading](https://docs.pi-hole.net/docker/upgrading/).

---

## Project Structure

```
PiHole-DNS/
├── docker-compose.yml       # Service definitions (Pi-Hole + future services)
├── start.md                 # Project seed (interview-driven initialization)
├── .cursor/commands/        # Dev-infra workflow commands
├── docs/
│   ├── roadmap.md           # Canonical roadmap (layers + horizontal tracks)
│   ├── runbooks/            # Operator procedures (deploy, backup, digest pin)
│   └── maintainers/         # Explorations, research, decisions, workflow docs
├── scripts/                 # Automation and deployment scripts
└── tests/                   # Infrastructure validation tests
```

---

## Development

### Workflow

This project uses the [dev-infra](https://github.com/grimm00/dev-infra) workflow pipeline:

- **Explore** → **Research** → **Decision** → **Design** → **Plan** → **Implement**
- Feature branches + PRs with AI reviews (Sourcery)
- Review-then-commit pattern for all agentic changes

### Git Flow

- **`main`** — Stable releases
- **`develop`** — Ongoing development
- **`feat/*`** — Feature branches (require PRs)
- **`fix/*`** — Bug fixes (require PRs)
- **`docs/*`** — Documentation (can push directly)

### Getting Started

```bash
git clone https://github.com/grimm00/PiHole-DNS.git
cd PiHole-DNS

# See the project seed for full context
cat start.md
```

---

## Quick Links

- **[Runbooks](docs/runbooks/README.md)** — Deploy, backup, restore, digest pin (Layer 0)
- **[Documentation](docs/README.md)** — Roadmap, runbooks, maintainers hub
- [Project Seed](start.md) — Interview-driven project definition
- [Roadmap](docs/roadmap.md) — Delivery layers, cross-cutting tracks, open questions
- [Maintainers Guide](docs/maintainers/README.md) — Explorations, research, decisions, workflow
- [Workflow Overview](docs/maintainers/WORKFLOW-OVERVIEW.md) — Development workflow reference

---

**Last Updated:** 2026-04-19  
**Status:** Layer 0 — Foundation  
**Next:** Pin `pihole/pihole` with a digest in Compose after a verified deploy on the Pi (`implementation-plan` Tasks 7–8)
