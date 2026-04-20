# Research topics — Layer 1 — Usable

**Status:** 🟡 Stub — fill when exploration is ready to hand off to `/research`  
**Created:** 2026-04-19  
**Amended:** 2026-04-19 — candidate rows aligned to [roadmap Layer 1](../../../roadmap.md) + Theme 5  
**Exploration:** [exploration.md](exploration.md)  
**Roadmap:** [Layer 1 — Usable](../../../roadmap.md)

---

## When to use this file

After themes in [exploration.md](exploration.md) are stable, break them into **staged research topics** (same pattern as [Layer 0 research topics](../layer-0-foundation/research-topics.md)): Stage 0 prior art, then numbered stages per theme. The exploration’s **[roadmap coverage](exploration.md#roadmap-coverage-layer-1)** table maps roadmap bullets to themes.

---

## Candidate topics (not yet staged)

| # | Theme | Draft question |
|---|--------|----------------|
| 1 | Local DNS + names | How do local apex + subdomains get defined (Pi-hole DNS records, router, split DNS)? Align with roadmap examples (`files.home`, `pihole.home`) or chosen apex. |
| 2 | Reverse proxy + TLS | Caddy / nginx / Traefik on Pi: vhosts, Pi-hole behind proxy, LAN TLS options. |
| 3 | Operator access | SSH hardening + recovery runbook; Pi-hole web auth; separation in docs. |
| 4 | Discovery ladder | Minimum runbook steps: router → name → scan → break-glass; canonical “source of truth” for IP/hostname. |
| 5 | Compose stack — OurFileServer | OurFileServer (or equivalent) beside Pi-hole: networking, volumes, **ordering** (DNS vs stack merge), **blast radius**, **rollback**. |
| 6 | Upstream parity (Track A) | How do image/env/volume and GitOps-lite habits match [OurFileServer](https://github.com/grimm00/OurFileServer) and Layer 0 NFR-1 / digest policy? |
| 7 | Safety when colocating (Track D) | How do backup and rollback extend when file server shares the Pi with Pi-hole? |

---

## Next step

```
/research layer-1-usable --from-explore layer-1-usable
```

(When the project scaffolds `docs/maintainers/research/layer-1-usable/` — mirror Layer 0 layout.)

---

**Last updated:** 2026-04-19
