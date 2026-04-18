# Status & next steps — Layer 0 — Foundation

**Status:** ✅ Complete  
**Last updated:** 2026-04-19  

---

## Merged

| PR | Base | Merged | What shipped |
|----|------|--------|--------------|
| [#1](https://github.com/grimm00/PiHole-DNS/pull/1) | `main` | 2026-04-18 | Runbooks group (Tasks 1–4): `docs/runbooks/` index, backup/restore, minimum deploy, digest workflow; planning updates; Sourcery [`pr1.md`](../../../feedback/sourcery/pr1.md) |
| [#2](https://github.com/grimm00/PiHole-DNS/pull/2) | `develop` | 2026-04-18 | Tasks 5–9: README / `docs/` entry points, `.env.example`, `docker-compose.yml` digest pin, roadmap + planning closure; Sourcery [`pr2.md`](../../../feedback/sourcery/pr2.md) |

Layer 0 MVP is **landed on `develop`** via PR #2. Promote or cherry-pick to **`main`** when you cut a release.

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

1. **Optional:** Run the short [design retrospective](notes-post-cycle-design-retrospective.md) (what belonged in design before implementation vs only in transition-plan tasks).
2. **Layer 1 — Usable:** See [roadmap](../../../../roadmap.md); start planning or exploration for local DNS + stack merge when ready.
3. **Deferred doc polish:** [PR #2 follow-up hub](fix/pr2/README.md) (Sourcery overall comments — low priority).

---

## Notes

- **Git workflow:** Feature branches merge into **`develop`**; **`main`** may track releases. PR #1 predates `develop` and landed on `main` first.
- Plan generated from ADRs `docs/maintainers/decisions/layer-0-foundation/`, requirements, and [design-layer-0.md](../../../design/layer-0-foundation/design-layer-0.md) on 2026-04-19.

---

**Last updated:** 2026-04-19
