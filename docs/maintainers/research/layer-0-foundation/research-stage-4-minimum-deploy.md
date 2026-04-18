# Research — Stage 4: Minimum deploy path from repo (Track A)

**Layer:** 0 — Foundation  
**Status:** ✅ Complete  
**Created:** 2026-04-17  
**Completed:** 2026-04-17  
**Exploration topic:** [Topic 4](../../explorations/layer-0-foundation/research-topics.md)

---

## Research question

What is the **smallest** workflow from this repo to a running stack on the Pi **without** requiring registry/mise until Compose + DNS are proven?

---

## Context

GitOps-lite long-term; Layer 0 should not depend on full CI/registry pipeline. Align with **Stage 0** (OurFileServer-style: repo on disk, `docker compose up`). **NFR-1** (pin/cache images) is validated and operationalized here.

---

## Stage goals

- [x] Document a minimal path: clone/pull + `docker compose` + `.env` secrets.  
- [x] Define **deferral criteria**: when to move from public pulls to **cache-first + private registry** (or `docker save`/`load`).  
- [x] Specify **pinning**: **date tags** or **digest** in Compose once vetted; avoid silent `latest` drift for “production” homelab.  
- [x] Secret handling for `.env` and gitignore hygiene.  
- [x] **Cross-stack rule:** any new service in Compose follows the same pull → pin → cache/registry pattern.

---

## Methodology

Docker documentation on [image digests](https://docs.docker.com/dhi/core-concepts/digests/); Pi-hole [Docker versioning](https://docs.pi-hole.net/docker/); `docker compose` behavior; compare with Stage 0 verdicts and this repo’s [`.gitignore`](../../../../.gitignore).

**Sources**

- [x] [Docker — Image digests](https://docs.docker.com/dhi/core-concepts/digests/)  
- [x] [Pi-hole — Docker / upgrading](https://docs.pi-hole.net/docker/upgrading/)  
- [x] Web search: `docker compose` digest pinning, `docker save` / `load`

---

## Findings

### Finding 1: Minimum viable operator workflow (single Pi, no mise/ghcr required)

**Summary**

1. **Get the repo on the Pi:** `git clone` once, then **`git pull`** for updates — same pattern as OurFileServer-style homelab stacks.  
2. **Secrets:** Create **`.env`** alongside `docker-compose.yml` with at least **`FTLCONF_webserver_api_password`** (and any other vars Compose references). **Do not commit** `.env` — this repo already ignores `.env` in [`.gitignore`](../../../../.gitignore).  
3. **Volume directories:** Ensure host paths exist for bind mounts (e.g. **`./etc-pihole`**, **`./etc-dnsmasq.d`**) — `mkdir -p` before first `up` if empty; Pi-hole initializes content on first container start.  
4. **Bring up:** From the repo directory: **`docker compose pull`** (optional but recommended when changing tags) then **`docker compose up -d`**.  
5. **Verify:** `docker compose ps`, browse `http://<Pi_IP>/admin/`, test DNS from an opt-in client (Stage 1 checklist).

No **mise**, **ghcr**, or **CI** is required for this path — they are **deferrable** until multi-environment parity, automated promotion, or team handoff matter.

**Source:** Operational practice; [Pi-hole Docker upgrading](https://docs.pi-hole.net/docker/upgrading/) (`docker compose pull` / `up -d`).

**Relevance:** This is the **Track A minimum** for Layer 0.

---

### Finding 2: When to add registry, mirror, or mise

**Summary**

| Trigger | Consider |
|--------|----------|
| **Single Pi, solo operator** | Public Hub/ghcr + local Docker image cache is usually enough. |
| **Air-gapped or flaky WAN** | **`docker save`** / **`docker load`** tarballs; or a **private registry** on LAN ([Docker Registry](https://hub.docker.com/_/registry) container, NAS, etc.). |
| **Multiple hosts same stack** | Push tested image to **ghcr.io** (or private registry); Pi **pulls** digest-pinned reference. |
| **Toolchain parity** | **mise** (or similar) earns its keep when the same repo expects multiple CLI versions across dev + Pi — **not** a Layer 0 gate. |

**Source:** Homelab norms; roadmap Track A intent.

**Relevance:** Layer 0 **explicitly defers** mise/full GitOps until Compose + DNS are proven.

---

### Finding 3: Pinning images — digests vs date tags

**Summary**

- **Digest** references (`image@sha256:…`) are **immutable**: the same bytes every pull ([Docker — digests](https://docs.docker.com/dhi/core-concepts/digests/)). Compose accepts `image: name@sha256:digest`. Obtain digest after a trusted pull via **`docker images --digests`**, **`docker inspect`**, or **`docker buildx imagetools inspect`** (multi-arch aware).  
- **Date tags** (Pi-hole publishes **YYYY.MM.N** style per [Pi-hole Docker docs](https://docs.pi-hole.net/docker/)) are **better than `latest`** for readability and support, but tags can still move in edge cases — **digest** is strongest for bit-for-bit reproducibility.  
- **`docker compose config --resolve-image-digests`** (where supported) can emit compose with resolved digests for a **snapshot** of what was deployed — useful to commit as a **deployed** artifact or ADR appendix, distinct from always using `latest` in the main branch.

**Source:** [Docker image digests](https://docs.docker.com/dhi/core-concepts/digests/); Pi-hole versioning docs.

**Relevance:** **NFR-1** is satisfied operationally by: (1) document the policy; (2) move Compose from `latest` to **date tag or digest** after first successful bring-up; (3) prefer **cached** local image on rebuild when offline or avoiding re-pull.

---

### Finding 4: Cache-first behavior on the Pi

**Summary**

- If the **same digest** (or tag pointing to the same manifest) already exists in the local Docker store, **`docker compose pull`** may report “already up to date” and **not** hit the network — achieves **cache-first** without a private registry.  
- **Private registry** adds value when **multiple** nodes pull the **same pinned** image or you want **air-gap** push once / pull many.  
- **`docker save` / `docker load`** suit **USB sneakernet** or backup of a known-good image tarball.

**Source:** Docker CLI documentation; community homelab.

**Relevance:** NFR-1 “prefer cached copy” is achievable on a **single Pi** without extra infrastructure.

---

### Finding 5: Cross-stack consistency

**Summary**

- When **OurFileServer** or other services join **the same** `docker-compose.yml`, each **`image:`** line should follow the **same** policy: no unbounded `latest` in long-lived branches; pin after validation; document pulls in changelog or ADR.  
- **One compose file** → one mental model for “what runs on the Pi.”

**Source:** Stage 0; roadmap Layer 1.

**Relevance:** Prevents a two-tier supply chain (Pi-hole pinned, sidecar drifting).

---

## Analysis

**Key insights**

- [x] **Git + `.env` + `docker compose`** is sufficient for Layer 0 MVP deploy.  
- [x] **NFR-1** is actionable: pin after proof, use local cache, escalate to registry/save-load only when triggers appear.  
- [x] **`.gitignore`** already matches secret hygiene for `.env` and volume data.

---

## Recommendations

- [x] Publish a **short deploy section** in the root **README** (or linked doc) with the minimal steps — satisfies **FR-4** and gives operators a single entry point.  
- [x] After first healthy deploy, replace **`pihole/pihole:latest`** in Compose with a **date tag or digest** and record the change in git history or an ADR.  
- [x] Revisit **mise** / **ghcr** when Layer 1 multi-service or multi-host needs appear.

---

## Requirements discovered

See [requirements.md](requirements.md): **FR-4**; **NFR-1** wording finalized via this stage; **A-5**.

---

## Next steps after this stage

- **`/research layer-0-foundation --consolidate`** — clean requirements, then **`/decision layer-0-foundation --from-research`**.

---

**Last Updated:** 2026-04-17
