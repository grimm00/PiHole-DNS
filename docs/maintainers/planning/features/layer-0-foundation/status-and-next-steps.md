# Status & next steps — Layer 0 — Foundation

**Status:** ✅ Complete  
**Last updated:** 2026-04-19  

---

## Merged to `main`

| PR | Merged | What shipped |
|----|--------|--------------|
| [#1](https://github.com/grimm00/PiHole-DNS/pull/1) | 2026-04-18 | Runbooks group (Tasks 1–4): `docs/runbooks/` index, backup/restore, minimum deploy, digest workflow; planning updates; Sourcery review capture [`pr1.md`](../../../feedback/sourcery/pr1.md) |

Layer 0 **Tasks 5–9** (entry points, Compose digest pin, closure) are on branch **`feat/layer-0-foundation`** / PR to **`develop`** — merge when ready.

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

1. **Merge** open Layer 0 PR into **`develop`** (and to **`main`** when you tag a release), per your branching policy.
2. **Optional:** Run the short [design retrospective](notes-post-cycle-design-retrospective.md) after merge (what belonged in design before implementation vs only in transition-plan tasks).
3. **Layer 1 — Usable:** See [roadmap](../../../../roadmap.md); exploration [`layer-0-foundation`](../../../explorations/layer-0-foundation/README.md) scope shifts to local DNS + stack merge when you start.

---

## Notes

- **Git workflow:** Branch from **`develop`**, merge via PR into **`develop`**. **`main`** may track releases; PR #1 landed on `main` before `develop` existed.
- Plan generated from ADRs `docs/maintainers/decisions/layer-0-foundation/`, requirements, and [design-layer-0.md](../../../design/layer-0-foundation/design-layer-0.md) on 2026-04-19.

---

**Last updated:** 2026-04-19
