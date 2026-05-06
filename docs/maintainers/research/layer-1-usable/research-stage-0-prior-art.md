# Research — Stage 0: Prior art & existing patterns (Layer 1 — Usable)

**Layer:** 1 — Usable  
**Status:** 🔴 Not Started  
**Created:** 2026-05-05  
**Exploration context:** [`layer-1-usable`](../../explorations/layer-1-usable/README.md)

---

## Research question

What existing implementations and patterns (in this repo, OurFileServer, and common homelab practice) should inform Layer 1 so we can adopt the simplest viable approach for naming, proxy/TLS, operator access, and service colocation?

---

## Context

Layer 0 has been stable for real-world use. Layer 1 expands scope (local names, optional reverse proxy/TLS, and a file server in the same stack). Stage 0 is meant to **reduce reinvention** and anchor decisions to practices that are already known to work.

---

## Stage goals

- [ ] Capture “adopt / adapt / avoid” for local naming strategies (`*.home`, subdomains, record location).  
- [ ] Capture prior art for reverse proxy + LAN TLS (including “HTTP-first then TLS” staging).  
- [ ] Capture operator access baseline patterns (SSH posture, recovery) that are appropriate for a homelab Pi.  
- [ ] Capture prior art for colocating services in one Compose stack on a Pi (resource/port concerns, rollback).  
- [ ] Identify any conventions from OurFileServer that should be treated as “upstream” for this repo (Track A parity).

---

## Methodology

Stage 0 should be fast and pragmatic:

- Read existing docs in this repo that already encode working patterns (Layer 0 research + ADRs + runbooks).  
- Review the OurFileServer repo’s deployment habits (Compose layout, env/secrets, volumes, update workflow).  
- Use targeted web research only to fill gaps (proxy choice comparisons, LAN TLS trust options, Pi-hole behind proxy caveats).

**Sources (checklist)**

- [ ] Layer 0 research and ADRs (this repo)  
- [ ] Layer 0 runbooks (this repo)  
- [ ] OurFileServer repo docs / Compose examples  
- [ ] Pi-hole docs relevant to local DNS records and reverse proxies  
- [ ] Reverse proxy docs (Caddy/nginx/Traefik) for homelab usage  
- [ ] LAN TLS trust model references (internal CA, local trust)

---

## Findings

_TBD_

---

## Analysis

_TBD_

---

## Recommendations (adopt / adapt / avoid)

_TBD_

---

## Requirements discovered

_TBD_

---

## Next steps

- After Stage 0, proceed to Topic 1–7 conduct, using Stage 0 conclusions as defaults to reduce thrash.

