# Research summary — Layer 1 — Usable

**Status:** 🟡 In progress — Stage 0 complete  
**Created:** 2026-05-05  
**Last updated:** 2026-05-05

---

## Overview

This document rolls up key findings across Layer 1 research topics as they are completed.

**Stages/topics:** 8 (Stage 0 + 7 topics)  
**Complete:** 2/8

---

## Key findings (to be filled)

- **Stage 0 (prior art):** Prefer **hostname-per-service** (subdomains) over path-prefix routing for Pi-hole; `/admin` path assumptions make shared-hostname subpaths brittle.  
  - Source: [`research-stage-0-prior-art.md`](research-stage-0-prior-art.md)
- **Stage 0 (prior art):** Consider **`home.arpa`** as the standards-backed homenet domain (RFC 8375) vs a personalized `.home` apex; treat the choice as explicit.  
  - Source: [`research-stage-0-prior-art.md`](research-stage-0-prior-art.md)
- **Topic 1 (local DNS + names):** Keep a small curated set of service names in **Pi-hole’s local DNS UI/API** as the canonical source; treat conditional forwarding as optional coupling to the router/DHCP.  
  - Source: [`research-local-dns-names.md`](research-local-dns-names.md)

---

## Requirements summary (pointer)

See [`requirements.md`](requirements.md). Requirements are drafted during topic conduct and cleaned/deduped during consolidation.

---

## Topic status

| # | Topic | Status |
|---:|------|--------|
| 1 | Local DNS + names | ✅ Complete |
| 2 | Reverse proxy + TLS | 🔴 Not Started |
| 3 | Operator access | 🔴 Not Started |
| 4 | Discovery ladder | 🔴 Not Started |
| 5 | Compose stack — OurFileServer | 🔴 Not Started |
| 6 | Upstream parity (Track A) | 🔴 Not Started |
| 7 | Safety when colocating (Track D) | 🔴 Not Started |

---

## Next steps

1. Conduct Topic 1–7 research (fill the per-topic documents).  
2. Consolidate and reconcile requirements.  
3. Move to decisions (ADRs) once requirements are stable.

