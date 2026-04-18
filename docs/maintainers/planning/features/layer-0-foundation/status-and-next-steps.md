# Status & next steps — Layer 0 — Foundation

**Status:** 🟠 In Progress  
**Last updated:** 2026-04-19  

---

## Merged to `main`

| PR | Merged | What shipped |
|----|--------|--------------|
| [#1](https://github.com/grimm00/PiHole-DNS/pull/1) | 2026-04-18 | Runbooks group (Tasks 1–4): `docs/runbooks/` index, backup/restore, minimum deploy, digest workflow; planning updates; Sourcery review capture [`pr1.md`](../../../feedback/sourcery/pr1.md) |

---

## Progress summary

**Overall:** 8/9 tasks complete

| Group | Status | Progress | Notes |
|-------|--------|----------|-------|
| Runbooks — operator procedures | ✅ Complete | 4/4 tasks | Tasks 1–4 done |
| Repository entry points | ✅ Complete | 2/2 tasks | Tasks 5–6 done |
| Compose and image pin | ✅ Complete | 2/2 tasks | Digest pinned in repo; verified on Pi (`docker compose config`, restart) |
| Layer 0 closure | 🔴 Not Started | 0/1 tasks | Optional roadmap update |

---

## Next steps

1. **Task 9** — When MVP criteria are met: refresh [roadmap](../../../../roadmap.md) Layer 0 line and this file; run [design retrospective](notes-post-cycle-design-retrospective.md) if closing the cycle.
2. Merge Layer 0 work via PR into **`develop`** (and **`main`** when you cut a release), per your branching policy.

---

## Notes

- **Git workflow:** Branch from **`develop`**, merge via PR into **`develop`** (dev-infra–style integration). **`main`** may track releases; PR #1 landed on `main` before `develop` existed.
- Plan generated from ADRs `docs/maintainers/decisions/layer-0-foundation/`, requirements, and [design-layer-0.md](../../../design/layer-0-foundation/design-layer-0.md) on 2026-04-19.
- **After Layer 0 closes:** run the short retrospective in [notes-post-cycle-design-retrospective.md](notes-post-cycle-design-retrospective.md) (what belonged in design before implementation vs only in transition-plan tasks).

---

**Last updated:** 2026-04-19
