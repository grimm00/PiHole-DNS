# Requirements — Layer 1 — Usable

**Status:** 🔴 Draft (setup only)  
**Created:** 2026-05-05  
**Last updated:** 2026-05-05

---

## Overview

Requirements will be discovered during research topic conduct and reconciled during consolidation.

---

## Functional requirements (FR)

- **FR-1:** System should support stable, human-friendly service names (hostname-per-service) for Pi-hole and colocated services.
- **FR-2:** System must support local service names that are stable across reboots and router changes (as long as Pi-hole remains the resolver). **Updated after:** `research-local-dns-names.md`

---

## Non-functional requirements (NFR)

- **NFR-1:** Operator UX should avoid brittle reverse-proxy path rewriting (prefer vhosts/subdomains when exposing multiple services).
- **NFR-2:** Naming choices must be documented as deliberate (domain choice + escape hatch) to reduce future migration cost. **Updated after:** `research-local-dns-names.md`

---

## Constraints (C)

- **C-1:** DNS on port **53** must remain directly reachable on the LAN even if web UI traffic is reverse proxied.
- **C-2:** Avoid `.local` for the primary homenet domain because it overlaps with mDNS behavior. **Updated after:** `research-local-dns-names.md`

---

## Assumptions (A)

- **A-1:** Either `home.arpa` is acceptable as the homenet domain, or a personalized apex is used with documented tradeoffs and recovery.

