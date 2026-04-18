# Project Seed: PiHole-DNS

**Purpose:** Seed document for PiHole DNS project — grows through interview  
**Status:** ✅ Interview Complete  
**Created:** 2026-04-16  
**Last Updated:** 2026-04-16

---

## What We Know (Day Zero)

**Project name:** PiHole-DNS  
**Target users:** Me (primary), Family (secondary)  
**Team size:** 1  
**Project type:** Regular project  
**Motivation:** "This will be my look into having my own DNS server."

---

## Interview Log

Answers captured here as the interview progresses. Each section builds on the previous.

### Section 1: Motivation & Vision

**1.1 — What's driving the project?**
> Already owns a Raspberry Pi running a containerized file browser (managed via SSH from another device). Apprenticeship coach suggested Pi-Hole. Has always thought about running own DNS server. Sees ad-blocking and site restrictions as a plus, but the core motivation is experimentation and learning on the Pi.

**1.2 — Prior exposure to Pi-Hole?**
> None. No prior exposure to Pi-Hole running anywhere.

**1.3 — What does "done" look like day-to-day?**
> No frame of reference yet. Brief video research surfaced IFTTT and smart device integration possibilities. Wants **observability** — staying engaged with the project beyond initial setup. Past projects (Google Cloud to-do list website) suffered from "set up and forget" because there was no ongoing engagement surface. Observability could be the engagement mechanism.

**1.4 — Learning vs. shipping?**
> Primarily learning, but wants a working DNS server too. Doesn't need fundamentals (DNS basics, networking 101, Pi basic setup). Wants to learn **configuration management** and **platform engineering** patterns — directly aligned with current apprenticeship rotation as a platform engineer.

### Section 2: Domain Knowledge & Prior Experience

**2.1 — Current Pi setup?**
> Running [OurFileServer](https://github.com/grimm00/OurFileServer) — Filebrowser in Docker Compose, accessible via host IP + port from any browser on the network. Docker is already installed and operational on the Pi. Sees this as an opportunity to eventually get an actual domain name.

**2.2 — Docker Compose vs. heavier orchestration?**
> Didn't know K3s (lightweight Kubernetes) existed. Interested in trying it — would align directly with K8s work at the apprenticeship rotation. Open to heavier orchestration if it's a learning opportunity.

**2.3 — OS-level administration comfort?**
> Mostly "install Docker, run containers, SSH in to check." Limited experience with systemd, package management, firewall rules. **This project is explicitly a way to develop those skills.**

**2.4 — DNS understanding?**
> Understands DNS resolution flow. Has manually configured DNS (to Google) on individual machines before. May be able to configure at router level but wants to **start opt-in (per-device)** until confident in the setup. Conservative approach — don't break the family's internet.

### Section 3: Environment & Hardware

**3.1 — Pi model?**
> Raspberry Pi 5. Plenty of resources for Pi-Hole + Filebrowser + K3s if pursued.

**3.2 — OS?**
> Raspberry Pi OS. Open to other operating systems.

**3.3 — Storage?**
> External drive connected (used by Filebrowser). SD card for boot/OS.

**3.4 — Networking?**
> Wi-Fi currently. Ethernet coming soon. **No mention of static IP — needs to be addressed before DNS server is viable.**

**3.5 — Development machine?**
> Steam Deck running Arch Linux (main home laptop died), usually connected to a monitor. Functions as a full Arch workstation when docked. This Mac (current machine) is not the primary dev machine. Development will happen from the Steam Deck — either via SSH to the Pi or with a local editor + remote execution.

### Section 4: Project Shape

**4.1 — Config repo or application?**
> Wants a **full application that wraps Pi-Hole** — dashboards, observability UI, more than just config files. Sees dev-infra's quality attribute catalog and design step as a process to dogfood here: staged implementations, requirements-driven, MVP first with iterative improvement. Not just "deploy Pi-Hole and forget" — this is an application project.

**4.2 — K3s approach?**
> Start with Docker Compose (like OurFileServer). K3s is a future stage on the roadmap. Aligns with the staged implementation philosophy.

**4.3 — Observability scope?**
> Both. Pi-Hole-level (query logs, blocked domains, network stats) AND platform-level (CPU, memory, container health, uptime). Observability is the engagement mechanism that prevents this from becoming a "set up and forget" project.

**4.4 — Domain name?**
> Yes, part of this project. Even if it's just local DNS — resolving service names instead of raw IPs. Pi-Hole's custom DNS records can serve this natively (e.g., `files.home` → Pi IP, `pihole.home` → Pi IP). Potential future scope: real domain for remote access / HTTPS.



### Section 5: Development Workflow

**5.1 — Full pipeline or lighter-weight?**
> Full dev-infra pipeline. Believes it adjusts to both small and complex projects — the ceremony scales with the project, not against it. Also serves as dogfooding for the pipeline itself.

**5.2 — Git workflow?**
> Feature branches + PRs, even solo. Wants AI reviews (Sourcery). Consistent with dev-infra practices.

**5.3 — Editor situation?**
> Cursor available on the Steam Deck. Full IDE experience, not terminal-only.

**5.4 — Repo-to-Pi relationship?**
> Repo as source of truth, deployed to Pi. Suggested approach: mise file on the Pi that pulls tooling and images. Container image could live in GitHub Container Registry (ghcr.io) or similar. The Pi pulls from the registry rather than building locally. **This is a GitOps-lite model** — code in repo, deploy to target.



### Section 6: Scope & MVP

**6.1 — MVP layers?**
> Agrees with proposed layering. **MVP = Layer 0:** Static IP on the Pi, Pi-Hole running in Docker Compose, working DNS resolution for at least one opt-in device. Layers 1-3 are roadmap items, not MVP.
>
> **Proposed layers:**
> - **Layer 0 (Foundation/MVP):** Static IP, Pi-Hole in Docker Compose, DNS working for one device
> - **Layer 1 (Usable):** Custom local DNS records (`files.home`, `pihole.home`), OurFileServer in same Compose stack
> - **Layer 2 (Observable):** Platform monitoring (container health, Pi resources) + Pi-Hole dashboards beyond built-in admin
> - **Layer 3 (Application):** Custom wrapper app/dashboard tying everything together

**6.2 — Timeline?**
> Aim to get something done this weekend. Flexible timeline — no external stakeholders pressuring delivery.

**6.3 — Anything else?**
> This repo will be handed off to the home Steam Deck machine. Work will continue there with Cursor Pro's free/auto/composer-2 models. Constrained usage limits on that plan, but expected to be sufficient for infrastructure-focused work.

---

## Derived Decisions

Synthesized from interview answers. These feed into README, project structure, and tooling choices.

### D1: Project Identity
This is a **learning-oriented infrastructure project** with a working deliverable. Not a tutorial, not pure config management — an application that wraps Pi-Hole with observability, dashboards, and local DNS management. Platform engineering skills (config management, containerization, monitoring) are the primary learning objective.

### D2: Architecture — Staged
- **Stage 1 (MVP/Layer 0):** Docker Compose on Pi, Pi-Hole + basic DNS
- **Stage 2 (Layer 1):** Local DNS records for home services, unified Compose stack with OurFileServer
- **Stage 3 (Layer 2):** Observability — platform metrics + Pi-Hole analytics
- **Stage 4 (Layer 3):** Custom wrapper application / dashboard
- **Future:** K3s migration, real domain name, remote access

### D3: Deployment Model — GitOps-lite
Repo is the source of truth. Pi pulls from GitHub Container Registry (or similar). Mise on the Pi handles tooling and deployment. No manual SSH-and-edit drift.

### D4: Development Workflow
Full dev-infra pipeline (explore → research → decision → design → plan → implement). Feature branches + PRs with AI reviews. Cursor on Steam Deck (Arch Linux, docked to monitor) as primary dev environment.

### D5: Immediate Prerequisites
- [ ] Static IP for the Pi (required before DNS server is viable)
- [x] Ethernet connection (in use for the Pi as of 2026-04-17 — improves DNS reliability vs Wi‑Fi on the server)
- [ ] GitHub repo created and seed pushed

### D6: Template Cleanup Needed
The current project scaffolding (from dev-infra standard-project template) includes `backend/`, `frontend/`, `tests/`, `scripts/` directories and a heavily templated README. These need to be reshaped for an infrastructure project, not a web application. The interview has provided enough context to do this intelligently now.

### D7: Dev-Infra Feedback Loop
This project serves as a real-world test of:
- **Seed-based project init** (interview instead of static form) → learnings doc for dev-infra
- **Quality attribute catalog** (dogfooding the design step) → feeds back to dev-infra int-opp
- **Pipeline at small scale** → evidence for whether the pipeline adjusts to simple projects

---

## Current environment (post-interview)

Facts that change over time; the interview log above stays as-is.

- **2026-04-17:** Raspberry Pi uses **Ethernet** for LAN access (updated from interview note that expected Wi‑Fi first). Interview section **3.4** remains historical.

### Meta — quality, dogfood, and feedback (not part of the original interview)

While working this repo, **keep in mind** cross-cutting **quality attributes** and **dev-infra** experiments (e.g. **agentic workflow modernization**, evolving explore/research/decision flows). No extra ceremony here — D7 already points at dogfooding.

When you have something concrete: **open a GitHub issue** in **this** repo (or the relevant **dev-infra** repo) to report **what worked**, **what hurt**, and **what you’d change**. That stays lighter than extending this seed file for every lesson learned.

---

**Last Updated:** 2026-04-17
