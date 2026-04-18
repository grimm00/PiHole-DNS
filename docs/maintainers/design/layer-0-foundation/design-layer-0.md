# Design: Layer 0 — Foundation (MVP)

**Topic:** layer-0-foundation  
**Status:** Draft — implementation in progress  
**Created:** 2026-04-19  
**Last updated:** 2026-04-19  

---

## 1. Purpose and scope

**In scope:** How Layer 0 is **represented** in this repository and on the Pi: operator docs, Compose wiring, image pinning, backup/rollback story, and links from the root README.

**Out of scope:** Layer 1+ (OurFileServer merge, local `*.home` names, observability stack); K3s; private registry/mise unless ADR triggers change.

**Sources of truth:**

| Layer | Artifact |
|-------|----------|
| Requirements | [requirements.md](../../../research/layer-0-foundation/requirements.md) |
| Decisions | [ADR-001 … ADR-004](../../../decisions/layer-0-foundation/README.md) |
| Research detail | [research hub](../../../research/layer-0-foundation/README.md) |

---

## 2. Documentation information architecture

### 2.1 Maintainer vs operator paths

| Audience | Path | Role |
|----------|------|------|
| Maintainers | `docs/maintainers/**` | Exploration, research, decisions, **this design**, planning |
| Operators | `docs/runbooks/**`, root `README.md` | Deploy, backup, rollback, verification |

Root **[README.md](../../../../../README.md)** should carry a **short** quickstart (clone, `.env`, `docker compose up`, link to runbooks) and point to **[docs/README.md](../../../README.md)** for the doc map.

### 2.2 Runbooks (`docs/runbooks/`)

Per **ADR-003** and **ADR-004**, Layer 0 procedures live under **`docs/runbooks/`** (initial placement; may split files later).

**Planned pages (suggested names):**

| Doc | Covers | Maps to |
|-----|--------|--------|
| `README.md` | Index + links | Already exists; extend |
| `backup-and-restore.md` (or combined) | What to back up (`./etc-pihole`, `./etc-dnsmasq.d`), **Teleporter required**, order of rollback | FR-3, ADR-003 |
| `minimum-deploy.md` | `git`, `.env`, `docker compose`, verify UI; link Pi-hole [Docker upgrading](https://docs.pi-hole.net/docker/upgrading/) | FR-4, ADR-004 |

Rollback order (design constraint, from research): **client DNS revert → `docker compose down` → restore volumes / Teleporter → `docker compose up -d`**.

### 2.3 Redaction

Public repo: **no** `.env` contents, **no** full MAC addresses or other home-network identifiers unless explicitly needed; mirror **decision-interview** guidance. Operator can keep a private note with reservation details.

---

## 3. Compose and images

### 3.1 Baseline

**ADR-002:** Current [`docker-compose.yml`](../../../../../docker-compose.yml) is the Layer 0 baseline (`FTLCONF_*`, ports 53/80, `./etc-pihole`, `./etc-dnsmasq.d`).

### 3.2 Image pinning (**NFR-1**, **ADR-004**)

**Decision:** After a verified pull, set:

```yaml
image: pihole/pihole@sha256:<digest>
```

**Design choices:**

- Store the digest **in Compose** as the canonical pin (reproducible `docker compose up`).
- Optionally add a one-line comment with human-readable tag or date when the digest was recorded.
- **Bump process:** Document in runbooks: pull new image → inspect digest → update `docker-compose.yml` → test → commit.

Initial bring-up may use `:latest` once; first intentional pin replaces it per ADR-004.

---

## 4. Verification and “Layer 0 done”

Align runbooks and README checklist with research **Stage 1** / **FR-1**:

- Stable IPv4 reachable (e.g. **ADR-001** verification pattern).
- Pi-hole admin UI reachable.
- At least one **opt-in** client using Pi-hole DNS; documented rollback path if wrong.

---

## 5. Deferred / later design

| Item | When |
|------|------|
| Pi-hole volumes on external disk | Only if a later ADR or Layer 1 design changes bind mounts |
| `mise` / ghcr / private registry | Stage 4 triggers (multi-host, air-gap, team) |
| Split deploy vs rollback into separate repos or sites | Optional; current design allows multiple files under `docs/runbooks/` |

---

## 6. Implementation checklist (engineering)

- [ ] Extend `docs/runbooks/README.md` with links to new pages.
- [ ] Author backup/restore + Teleporter steps (**ADR-003**).
- [ ] Author minimum deploy + digest bump procedure (**ADR-004**).
- [ ] Update root `README.md` quickstart + link to runbooks.
- [ ] Replace `image: pihole/pihole:latest` with digest after Pi verifies image.
- [ ] (Optional) Update [roadmap](../../../roadmap.md) Layer 0 status when MVP criteria are met.

---

## References

- [ADR-001 … ADR-004](../../../decisions/layer-0-foundation/README.md)  
- [requirements.md](../../../research/layer-0-foundation/requirements.md)  
- [quality-attributes.md](../../quality-attributes.md)  
- [Roadmap — horizontal tracks](../../../roadmap.md#horizontal-tracks-cross-cutting)

---

**Last updated:** 2026-04-19
