# PiHole-DNS

**Purpose:** Pi-Hole DNS server on Raspberry Pi with observability, local DNS management, and a custom wrapper application  
**Version:** v0.0.1  
**Last Updated:** 2026-04-16  
**Status:** 🟡 Layer 0 — Foundation

---

## Overview

A personal infrastructure project running [Pi-Hole](https://pi-hole.net/) on a Raspberry Pi 5 for DNS-level ad blocking, custom local DNS records, and home network observability. Built with platform engineering practices (configuration management, containerization, monitoring) as a learning exercise aligned with an apprenticeship rotation.

### Goals

1. **Working DNS server** — Pi-Hole running in Docker, resolving DNS for opt-in devices
2. **Local service discovery** — Custom DNS records (`files.home`, `pihole.home`) instead of raw IPs
3. **Observability** — Dashboards and monitoring that keep the project engaging beyond initial setup
4. **Platform engineering practice** — Configuration management, container orchestration, GitOps patterns

---

## Roadmap

| Layer | Name | Description | Status |
|-------|------|-------------|--------|
| 0 | **Foundation (MVP)** | Static IP, Pi-Hole in Docker Compose, DNS working for one device | 🟡 Current |
| 1 | Usable | Custom local DNS records, OurFileServer in same Compose stack | Planned |
| 2 | Observable | Platform monitoring (container health, Pi resources) + Pi-Hole analytics | Planned |
| 3 | Application | Custom wrapper app/dashboard tying everything together | Future |
| — | K3s Migration | Migrate from Docker Compose to K3s (lightweight Kubernetes) | Future |

---

## Infrastructure

### Target Environment

- **Hardware:** Raspberry Pi 5
- **OS:** Raspberry Pi OS
- **Container runtime:** Docker + Docker Compose
- **Network:** Wi-Fi (Ethernet planned), static IP required
- **Storage:** SD card (OS) + external drive (data)

### Existing Services

- [OurFileServer](https://github.com/grimm00/OurFileServer) — Filebrowser, already running on the Pi

### Deployment Model

GitOps-lite: this repo is the source of truth. The Pi pulls container images from a registry. No manual SSH-and-edit drift.

---

## Project Structure

```
PiHole-DNS/
├── docker-compose.yml       # Service definitions (Pi-Hole + future services)
├── start.md                 # Project seed (interview-driven initialization)
├── .cursor/commands/        # Dev-infra workflow commands
├── docs/
│   └── maintainers/         # Planning, research, decisions, workflow docs
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

- [Project Seed](start.md) — Interview-driven project definition
- [Maintainers Guide](docs/maintainers/README.md) — Planning, research, and decisions
- [Workflow Overview](docs/maintainers/WORKFLOW-OVERVIEW.md) — Development workflow reference

---

**Last Updated:** 2026-04-16  
**Status:** Layer 0 — Foundation  
**Next:** Static IP configuration + Pi-Hole Docker Compose setup
