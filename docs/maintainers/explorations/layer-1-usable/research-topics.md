# Research topics — Layer 1 — Usable

**Status:** 🟡 Stub — fill when exploration is ready to hand off to `/research`  
**Created:** 2026-04-19  
**Exploration:** [exploration.md](exploration.md)  
**Roadmap:** [Layer 1 — Usable](../../../roadmap.md)

---

## When to use this file

After themes in [exploration.md](exploration.md) are stable, break them into **staged research topics** (same pattern as [Layer 0 research topics](../layer-0-foundation/research-topics.md)): Stage 0 prior art, then numbered stages per theme.

---

## Candidate topics (not yet staged)

| # | Theme | Draft question |
|---|--------|----------------|
| 1 | Local DNS + names | How do local apex + subdomains get defined (Pi-hole DNS records, router, split DNS)? |
| 2 | Reverse proxy + TLS | Caddy / nginx / Traefik on Pi: vhosts, Pi-hole behind proxy, LAN TLS options. |
| 3 | Operator access | SSH hardening + recovery runbook; Pi-hole web auth; separation in docs. |
| 4 | Discovery ladder | Minimum runbook steps: router → name → scan → break-glass; canonical “source of truth” for IP/hostname. |
| 5 | Compose stack | OurFileServer (or equivalent) beside Pi-hole: networking, volumes, ordering. |

---

## Next step

```
/research layer-1-usable --from-explore layer-1-usable
```

(When the project scaffolds `docs/maintainers/research/layer-1-usable/` — mirror Layer 0 layout.)

---

**Last updated:** 2026-04-19
