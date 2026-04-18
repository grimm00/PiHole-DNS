# Design Hub

**Purpose:** Solution design after research and ADRs — how requirements show up in docs, compose, and operator workflows (before or alongside detailed planning).  
**Status:** ✅ Active  
**Last Updated:** 2026-04-19  

---

## Quick links

### Design by topic

- **[layer-0-foundation](layer-0-foundation/README.md)** — Layer 0 MVP: runbooks, deploy path, compose/image shape, operator UX

---

## Overview

**Design** sits after **decisions** (ADRs) and before or beside **implementation** / [planning](../planning/README.md). Research answers *what* is true; ADRs record *what we commit to*; design describes *how* that commitment appears in the repo: file layout, runbook structure, diagrams, and acceptance-style checks — without re-litigating ADRs.

**Workflow (typical):**

1. [Exploration](../explorations/README.md) → [Research](../research/README.md) → [Decisions](../decisions/README.md)  
2. **Design** (this directory) — shape of the solution  
3. [Planning](../planning/README.md) / transition plan → implement  

---

## Directory structure

```
docs/maintainers/design/
├── README.md                 # 📍 HUB — This file
└── [topic]/                  # Matches research/decisions topic where applicable
    ├── README.md             # Topic design hub
    ├── design-[topic].md     # Main design document(s)
    └── …                     # Optional: diagrams, supplementary notes
```

---

## Related

| Artifact | Location |
|----------|----------|
| Roadmap | [roadmap.md](../../roadmap.md) |
| Quality attributes | [quality-attributes.md](../quality-attributes.md) |
| Operator runbooks (runtime) | [docs/runbooks/](../../../runbooks/README.md) |

---

**Last updated:** 2026-04-19
