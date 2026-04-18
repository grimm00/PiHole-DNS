# Release Notes — v0.1.0

**Version:** v0.1.0  
**Release date:** 2026-04-18  
**Status:** Final

---

## Highlights

This release captures **Layer 0 — Foundation**: a documented, repeatable way to run **Pi-hole in Docker Compose** on a Raspberry Pi, with **backup/rollback** guidance, a **minimum deploy** path (Track A — no mise/private registry/CI required for the baseline), and **image pinning** via digest in Compose. Maintainer-facing **research, requirements, ADRs, and roadmap** are in place so later layers build on decisions instead of re-litigating them.

---

## What you get

### Operator-facing

- **Runbooks** — Start at [`docs/runbooks/README.md`](../../../../runbooks/README.md): minimum deploy, backup and restore, rolling forward with a new image digest.
- **Quickstart** — Root [`README.md`](../../../../../README.md) clone → `.env` → volumes → `docker compose` → verify.
- **Compose** — [`docker-compose.yml`](../../../../../docker-compose.yml) with **pinned image digest**; copy [`.env.example`](../../../../../.env.example) to `.env`.

### Maintainer-facing

- **Roadmap** — [`docs/roadmap.md`](../../../../roadmap.md) — Layer 0 complete; Layer 1 (**Usable**) next.
- **Decisions** — ADR-001–004 under [`docs/maintainers/decisions/layer-0-foundation/`](../../../decisions/layer-0-foundation/).

---

## Improvements

- Planning and post-merge hubs updated through PR #2 closure and follow-up documentation polish.
- `docs/README.md` links requirements (FR-3, FR-4, NFR-1) and ADRs (003, 004) for faster navigation.

---

## Bug fixes

- None applicable — documentation and infrastructure-as-docs release.

---

## Documentation

- Large addition of maintainer and operator documentation as listed in the root [`CHANGELOG.md`](../../../../../CHANGELOG.md).

---

## Breaking changes

None — first versioned release snapshot; no prior public API or tag.

---

## Migration

Not applicable — new deployments should follow current runbooks and Compose.

---

## Statistics

| Metric | Value |
|--------|--------|
| Merged PRs (milestone) | 2 (#1, #2) |
| Prior git tag | *(none before v0.1.0)* |
| Approx. contributors (all time) | 2 |

---

## Compare

[Initial commit…v0.1.0](https://github.com/grimm00/PiHole-DNS/compare/531a22e9790b75a5bd48b9a518e0bd65d5c53031...v0.1.0) *(after the `v0.1.0` tag is created on the release commit)*

---

**Last updated:** 2026-04-18
