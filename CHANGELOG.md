# Changelog

All notable changes to this project are documented in this file.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project uses [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.0] - 2026-04-18

### Added

- **Layer 0 — Foundation (MVP)** — Documented path to run Pi-hole on a Raspberry Pi with Docker Compose, stable LAN addressing guidance, and conservative rollout assumptions ([PR #1](https://github.com/grimm00/PiHole-DNS/pull/1), [PR #2](https://github.com/grimm00/PiHole-DNS/pull/2)).
- **Operator runbooks** — Runbooks index, minimum deploy, backup and restore, image digest pinning workflow (`docs/runbooks/`).
- **Maintainer documentation** — Layer 0 research (staged), requirements, ADR-001–004, design and planning hubs, roadmap, post-merge feedback captures.
- **Repository entry points** — Root README operator quickstart; `docs/README.md` documentation map with links to FR/NFR and ADRs.
- **Compose baseline** — `docker-compose.yml` with pinned Pi-hole image digest; `.env.example` for web API password and related variables.

### Changed

- **Planning workflow** — Layer 0 planning tasks closed; opportunities / learnings hub for internal workflow notes.

### Fixed

- **Documentation** — Sourcery PR #2 follow-ups: clarify when `docker compose pull` applies; link FR-3/FR-4/NFR-1 and ADR-003/ADR-004 from `docs/README.md` (commits on `develop` after PR #2).

### Documentation

- Extensive additions across `docs/maintainers/` and `docs/runbooks/` as summarized above.
