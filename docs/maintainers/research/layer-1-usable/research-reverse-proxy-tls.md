# Research: Reverse proxy + TLS (Layer 1 — Usable)

**Status:** 🔴 Not Started  
**Created:** 2026-05-05  
**Exploration topic:** Candidate topic 2 — [Layer 1 research-topics](../../explorations/layer-1-usable/research-topics.md)

---

## Research question

What reverse proxy (Caddy / nginx / Traefik) best fits this stack on the Pi, and what TLS approach works for a LAN (termination, trust model, cert material) without blocking shipping?

---

## Context

- Layer 1 discussion notes point toward subdomain-per-service with a proxy front door.  
- TLS is desired eventually; decisions must account for local trust and operational simplicity.

---

## Topic goals

- [ ] Compare proxy options for this use case (simple vhosts, path behavior, usability).  
- [ ] Determine a viable LAN TLS approach (or staged approach: HTTP now, HTTPS later).  
- [ ] Identify pitfalls for Pi-hole behind a proxy and how to verify.

---

## Methodology

_Fill during conduct._

**Sources (checklist)**

- [ ] Caddy / nginx / Traefik documentation for reverse proxy + TLS  
- [ ] Pi-hole admin UI behind proxy notes / common issues  
- [ ] Homelab LAN TLS trust model references (internal CA, etc.)

---

## Findings

_TBD_

---

## Analysis

_TBD_

---

## Recommendations

_TBD_

---

## Requirements discovered

_TBD_

---

## Next steps

- Run research-conduct for this topic; extract requirements into [`requirements.md`](requirements.md).

