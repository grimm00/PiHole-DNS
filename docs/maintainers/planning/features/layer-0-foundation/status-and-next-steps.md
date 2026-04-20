# Status & next steps — Layer 0 — Foundation

**Status:** ✅ Complete  
**Last updated:** 2026-04-19  

---

## Merged

| PR | Base | Merged | What shipped |
|----|------|--------|--------------|
| [#1](https://github.com/grimm00/PiHole-DNS/pull/1) | `main` | 2026-04-18 | Runbooks group (Tasks 1–4): `docs/runbooks/` index, backup/restore, minimum deploy, digest workflow; planning updates; Sourcery [`pr1.md`](../../../feedback/sourcery/pr1.md) |
| [#2](https://github.com/grimm00/PiHole-DNS/pull/2) | `develop` | 2026-04-18 | Tasks 5–9: README / `docs/` entry points, `.env.example`, `docker-compose.yml` digest pin, roadmap + planning closure; Sourcery [`pr2.md`](../../../feedback/sourcery/pr2.md) |
| [#3](https://github.com/grimm00/PiHole-DNS/pull/3) | `main` | 2026-04-18 | Release **v0.1.0** — changelog, tag, readiness; post-merge docs; see [`fix/pr3/README.md`](fix/pr3/README.md) |

Layer 0 MVP is on **`develop`**; **v0.1.0** is on **`main`** (PR #3). **`main`** and **`develop`** include the same release line after post-merge doc commits.

---

## Progress summary

**Overall:** 9/9 tasks complete

| Group | Status | Progress | Notes |
|-------|--------|----------|-------|
| Runbooks — operator procedures | ✅ Complete | 4/4 tasks | Tasks 1–4 done |
| Repository entry points | ✅ Complete | 2/2 tasks | Tasks 5–6 done |
| Compose and image pin | ✅ Complete | 2/2 tasks | Digest pinned; verified on Pi |
| Layer 0 closure | ✅ Complete | 1/1 tasks | Roadmap + status updated (Task 9) |

---

## Next steps

1. **Optional:** Use [design retrospective](notes-post-cycle-design-retrospective.md) prompts when starting Layer 1 design (access path, storage/paths — what belongs in design vs runbooks).
2. **Layer 1 — Usable:** See [roadmap](../../../../roadmap.md); start exploration/planning for local DNS, stack merge, and **operator access** (current vs desired SSH/DNS).
3. **Reflection:** [Post–Layer 0 / v0.1.0 reflection](reflections/reflection-post-layer0-v0.1.0-2026-04-19.md) — feed into `/explore layer-1-usable` when ready (`/explore --from-reflect`).
4. **Deferred doc polish:** [PR #3](fix/pr3/README.md) metadata sweep; [PR #2](fix/pr2/README.md) hub (already addressed).

---

## Notes

- **Git workflow:** Feature branches merge into **`develop`**; **`main`** may track releases. PR #1 predates `develop` and landed on `main` first.
- Plan generated from ADRs `docs/maintainers/decisions/layer-0-foundation/`, requirements, and [design-layer-0.md](../../../design/layer-0-foundation/design-layer-0.md) on 2026-04-19.

---

**Last updated:** 2026-04-19
