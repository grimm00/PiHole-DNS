# Research — Stage 4: Minimum deploy path from repo (Track A)

**Layer:** 0 — Foundation  
**Status:** 🔴 Research  
**Created:** 2026-04-17  
**Exploration topic:** [Topic 4](../../explorations/layer-0-foundation/research-topics.md)

---

## Research question

What is the **smallest** workflow from this repo to a running stack on the Pi **without** requiring registry/mise until Compose + DNS are proven?

---

## Context

GitOps-lite long-term; Layer 0 should not depend on full CI/registry pipeline. Align with patterns noted in **Stage 0** (OurFileServer, etc.).

**Image supply chain (project-wide pattern — deferred detail to this stage):** After the first successful pull from a public tag, prefer **pinned references** (immutable **date tag** or **digest**) and **reuse a cached artifact** on rebuilds—either the **local Docker store** on the Pi or a **private registry** you control. Apply the **same pattern to every base image** used in this repo (Pi-hole, Filebrowser / OurFileServer when unified, future services)—not only Pi-hole. Layer 0 may temporarily use `latest` while proving the stack; Stage 4 turns this into a concrete workflow (save/load, `docker compose` with digest, or push to private registry).

---

## Stage goals

- [ ] Document a minimal path: clone/pull + `docker compose` + `.env` secrets.  
- [ ] Define **deferral criteria**: when to move from “pull from Docker Hub / ghcr publicly” to **cache-first + private registry** (or documented `docker save`/`load` on the Pi).  
- [ ] Specify **pinning**: use **date tags** or **digest** (`image@sha256:…`) in Compose once vetted; avoid silent `latest` drift in production.  
- [ ] Secret handling for `.env` and gitignore hygiene.  
- [ ] **Cross-stack rule:** any new service added to Compose follows the same pull → pin → cache/registry pattern.

---

## Methodology

Compare with Stage 0 verdicts; repo’s own README and scripts (when present). Review Docker documentation: `docker save` / `docker load`, registry mirror, or private registry (e.g. local registry container, ghcr private repo) for homelab scale.

---

## Findings

### Finding 1:

**Source:**

**Relevance:**

---

## Analysis

**Key insights**

- [ ]

---

## Recommendations

- [ ]

---

## Requirements discovered

- [ ]

---

## Next steps after this stage

- Consolidate requirements → `/research layer-0-foundation --consolidate` (when all stages complete).  
- `/decision layer-0-foundation --from-research` → ADRs.

---

**Last Updated:** 2026-04-17
