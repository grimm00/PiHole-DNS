# Quality attributes — PiHole-DNS

**Purpose:** Working list for **decisions, reviews, and interview §5** — how cross-cutting “-ilities” show up in *this* repo.  
**Status:** 🟡 Living document  
**Last updated:** 2026-04-18  

---

## Canonical catalog (dev-infra)

The **full** quality attribute catalog and design-step prompts live with **[dev-infra](https://github.com/grimm00/dev-infra)** (see project README and pipeline docs there). This file does **not** duplicate that catalog verbatim; it maps **PiHole-DNS** concerns to common attribute names so §5.2 of the [decision interview](decisions/layer-0-foundation/decision-interview.md) has a local anchor.

Dogfooding note: [dev-infra#78](https://github.com/grimm00/dev-infra/issues/78).

---

## By roadmap track (horizontal)

| Track | Intent (short) | Typical quality attributes to consider |
|-------|----------------|----------------------------------------|
| **A — Deployment & GitOps-lite** | Repo → Pi without drift; pin/cache images | **Deployability**, **reproducibility**, supply-chain / **integrity** (image tags, digests), **configurability** (secrets, `.env`) |
| **B — Observability & engagement** | Stay engaged after install | **Observability** (metrics, logs), **usability** of signals (solo operator), **performance** on Pi-class hardware |
| **C — Workflow, CI, practice** | Branches, PRs, maintainer docs | **Maintainability** (docs structure), **traceability** (research → requirements → ADR), **analysability** (clear runbooks) |
| **D — Household safety & operations** | Opt-in DNS, rollback, backups | **Recoverability**, **operational risk**, **fault tolerance** from the *user’s* perspective (DNS fallback), **usability** of rollback steps |

---

## Layer 0 — requirements as concrete attributes

| ID | Requirement | Quality angle (informal) |
|----|-------------|-------------------------|
| FR-1 | Stable LAN IPv4 | **Reliability** (stable addressing), **operability** |
| FR-2 | Pi-hole Compose v6 baseline | **Compatibility** (upstream), **maintainability** |
| FR-3 | Backup & rollback runbook | **Recoverability**, **operational risk** |
| FR-4 | Minimum deploy path | **Deployability**, **usability** (operator docs) |
| NFR-1 | Pin & cache images | **Reproducibility**, supply-chain **integrity** |
| C-1 | Pi-hole docs first | **Maintainability** / correctness of operational knowledge |

---

## ISO/IEC 25010 style checklist (optional)

Use as a **prompt list** when §5.2 asks for extra acceptance criteria — pick what matters for the change.

| Quality characteristic | Sub-characteristics (examples) |
|------------------------|--------------------------------|
| **Functional suitability** | Completeness, correctness (usually covered by FRs) |
| **Performance efficiency** | Time behavior, resource use (Pi CPU/RAM, DNS latency) |
| **Compatibility** | Co-existence (Compose, other stacks on Pi) |
| **Usability** | Appropriateness recognizability, learnability (runbooks, UI) |
| **Reliability** | Availability, fault tolerance, recoverability |
| **Security** | Confidentiality, integrity (secrets, image trust) |
| **Maintainability** | Modularity, reusability, analysability (docs, ADRs) |
| **Portability** | Adaptability across OS / hardware (Pi OS assumptions) |

---

## Related

| Artifact | Location |
|----------|----------|
| Roadmap tracks | [roadmap.md](../roadmap.md) |
| Layer 0 requirements | [requirements.md](research/layer-0-foundation/requirements.md) |
| Decision interview §5 | [decision-interview.md](decisions/layer-0-foundation/decision-interview.md) |

---

**Last updated:** 2026-04-18
