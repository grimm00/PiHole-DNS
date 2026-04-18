# CHANGELOG Draft — v0.1.0

**Draft created:** 2026-04-18  
**Status:** Merged — content lives in the repository root [`CHANGELOG.md`](../../../../../CHANGELOG.md) as of `/release-finalize` (2026-04-18).

---

## [0.1.0] - 2026-04-18

*(Superseded by root `CHANGELOG.md` — kept for release-prep traceability.)*

### Added

- **Layer 0 — Foundation (MVP)** — Documented path to run Pi-hole on a Raspberry Pi with Docker Compose, stable LAN addressing guidance, and conservative rollout assumptions (PR [#1](https://github.com/grimm00/PiHole-DNS/pull/1), [#2](https://github.com/grimm00/PiHole-DNS/pull/2)).
- **Operator runbooks** — Runbooks index, minimum deploy, backup and restore, image digest pinning workflow (`docs/runbooks/`).
- **Maintainer documentation** — Layer 0 research (staged), requirements, ADR-001–004, design and planning hubs, roadmap, post-merge feedback captures.
- **Repository entry points** — Root README operator quickstart; `docs/README.md` documentation map with links to FR/NFR and ADRs.
- **Compose baseline** — `docker-compose.yml` with pinned Pi-hole image digest; `.env.example` for web API password and related variables.

### Changed

- **Planning workflow** — Layer 0 planning tasks closed; opportunities / learnings hub for internal workflow notes.

### Fixed

- **Documentation** — Sourcery PR #2 follow-ups: clarify when `docker compose pull` applies; link FR-3/FR-4/NFR-1 and ADR-003/ADR-004 from `docs/README.md` (direct commits on `develop` after PR #2).

### Documentation

- Extensive additions across `docs/maintainers/` and `docs/runbooks/` as summarized above.

---

## PRs included

| PR | Title | Merged (UTC) |
|----|-------|----------------|
| [#1](https://github.com/grimm00/PiHole-DNS/pull/1) | docs(layer-0-foundation): operator runbooks and planning (Tasks 1–4, 4/9) | 2026-04-18 |
| [#2](https://github.com/grimm00/PiHole-DNS/pull/2) | docs(layer-0-foundation): Layer 0 MVP — runbooks, entry points, compose digest, closure (9/9) | 2026-04-18 |

Post-merge on `develop`: doc nits for Sourcery overall comments (no additional PR).

---

## Review checklist

- [x] All notable changes since repo inception are represented (or consciously out of scope).
- [x] Sections (Added / Changed / Fixed / Documentation) match project conventions in root `CHANGELOG.md`.
- [x] Release date set when tagging (**2026-04-18** in `CHANGELOG.md`).
- [x] Breaking changes: none — confirmed.

---

**Last updated:** 2026-04-18
