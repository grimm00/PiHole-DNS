# Requirements — Layer 0 — Foundation

**Source:** Research ([research-summary.md](research-summary.md))  
**Status:** Draft  
**Created:** 2026-04-17  

---

## Overview

Requirements discovered during Layer 0 research. Populate from stage documents as findings solidify.

**Stages:** [0](research-stage-0-prior-art.md) · [1](research-stage-1-stable-addressing.md) · [2](research-stage-2-pihole-compose.md) · [3](research-stage-3-safety-rollback.md) · [4](research-stage-4-minimum-deploy.md)

---

## Functional requirements

### FR-1: Stable LAN IPv4 for the Pi

**Description:** The Raspberry Pi that hosts Pi-hole must have a **stable, documented IPv4 address** on the home LAN for the duration of Layer 0 operation, obtained either by **DHCP reservation** (router assigns fixed IP to the Pi’s MAC) or **manual static configuration** on the Pi (e.g. NetworkManager on Raspberry Pi OS Bookworm). The address must not change unexpectedly across reboots under normal conditions.

**Source:** [research-stage-1-stable-addressing.md](research-stage-1-stable-addressing.md)

**Priority:** High

**Status:** 🔴 Pending

---

### FR-2: Pi-hole Compose — ports, v6 env, and persistence

**Description:** The Layer 0 stack must run **`pihole/pihole`** with **published** host ports **53/tcp**, **53/udp**, and **80/tcp** (minimum for DNS + HTTP admin). Compose must set **Pi-hole v6–compatible** variables: at minimum **`FTLCONF_dns_listeningMode: 'ALL'`** for default bridge networking, **`FTLCONF_webserver_api_password`** (or **`WEBPASSWORD_FILE`**) for the web UI password, and **`FTLCONF_misc_etc_dnsmasq_d: 'true'`** if the repo bind-mounts **`./etc-dnsmasq.d`→`/etc/dnsmasq.d`** (v6 does not load that directory otherwise). Persist **`./etc-pihole`→`/etc/pihole`** for Pi-hole state.

**Source:** [research-stage-2-pihole-compose.md](research-stage-2-pihole-compose.md)

**Priority:** High

**Status:** 🔴 Pending

---

### FR-3: Backup scope and rollback runbook (Layer 0)

**Description:** The project must document a **minimal** operator runbook for conservative home use: (1) **what to back up** — at least the host directory bind-mounted to **`/etc/pihole`** (`./etc-pihole`), and **`./etc-dnsmasq.d`** if customized; optional **Teleporter** export for a portable settings archive. (2) **when** — before material Compose/image changes or destructive edits. (3) **rollback** — in order: revert **opt-in client DNS** to router or prior resolvers; **`docker compose down`** if the stack must stop; restore **`./etc-pihole`** from a copy or use **Teleporter** restore per [Pi-hole Docker upgrading](https://docs.pi-hole.net/docker/upgrading/); then **`docker compose up -d`**. (4) **factory reset** — optional note that deleting volume data and recreating the container yields a fresh Pi-hole (acceptable for lab recovery).

**Source:** [research-stage-3-safety-rollback.md](research-stage-3-safety-rollback.md)

**Priority:** Medium

**Status:** 🔴 Pending

---

### FR-4: Documented minimum deploy path (Layer 0, Track A)

**Description:** The project must document a **minimum** operator path to run the stack on the Raspberry Pi **without** requiring mise, private registry, or CI: obtain the repo on the Pi (**`git clone`** / **`git pull`**), create **`.env`** with **`FTLCONF_webserver_api_password`** (and any other variables referenced by Compose), ensure bind-mount directories exist (**`./etc-pihole`**, **`./etc-dnsmasq.d`**), run **`docker compose pull`** (as needed) and **`docker compose up -d`**, then verify with **`docker compose ps`** and the Pi-hole admin UI. The document must reference **image pinning / cache** per **NFR-2** and link to Pi-hole [Docker upgrading](https://docs.pi-hole.net/docker/upgrading/) for image updates.

**Source:** [research-stage-4-minimum-deploy.md](research-stage-4-minimum-deploy.md)

**Priority:** Medium

**Status:** 🔴 Pending

---

## Non-functional requirements

### NFR-1: Pi-hole v6–compatible configuration

**Description:** Docker Compose and environment variables for `pihole/pihole` must match **Pi-hole v6** expectations (e.g. web password via `FTLCONF_webserver_api_password` or documented secret-file mechanism), not legacy v5-only variable names.

**Source:** [research-stage-0-prior-art.md](research-stage-0-prior-art.md)

**Priority:** High

**Status:** 🔴 Pending

---

### NFR-2: Pin and cache container images (project-wide)

**Description:** For **every** container base image used in this project (Pi-hole, file services, future stacks): (1) obtain the image from the upstream tag (prefer **immutable date tags** or record **digest** after verify — see [Docker image digests](https://docs.docker.com/dhi/core-concepts/digests/)); (2) on subsequent deploys or rebuilds, **prefer a cached copy**—either the image already present in the local Docker store or an image stored in a **private registry** / offline artifact (`docker save` / `load`)—so rebuilds do not silently re-resolve `latest` from the public internet. Initial Layer 0 bring-up may use `latest` or a single explicit pull; **after** a verified deploy, move **`image:`** in Compose toward a **Pi-hole date tag** or **`@sha256:…`** and treat **Stage 4** findings + **FR-4** as the operational baseline. **Defer** private registry / ghcr until multi-host or air-gap needs arise (see [research-stage-4-minimum-deploy.md](research-stage-4-minimum-deploy.md)).

**Source:** [research-stage-4-minimum-deploy.md](research-stage-4-minimum-deploy.md); operator direction 2026-04-17.

**Priority:** Medium (high for long-term reproducibility; after Stages 1–2 stable runtime)

**Status:** 🔴 Pending

---

## Constraints

### C-1: Upstream documentation as primary reference

**Description:** Host port conflicts (especially **53**), upgrade paths, and dnsmasq volume behavior must be resolved using **[Pi-hole Docker documentation](https://docs.pi-hole.net/docker/)** before relying on third-party tutorials.

**Source:** [research-stage-0-prior-art.md](research-stage-0-prior-art.md)

---

## Assumptions

### A-1: Prior homelab stack pattern

**Description:** Deployment may follow the same **Compose + bind mounts + restart policy** pattern already used for **OurFileServer** on the Pi, extended with Pi-hole-specific ports and volumes.

**Source:** [research-stage-0-prior-art.md](research-stage-0-prior-art.md)

---

### A-2: Router may participate in stable addressing

**Description:** If **DHCP reservation** is chosen, the home router (or DHCP server) supports assigning a fixed IP to the Pi’s **MAC address**. If the router cannot, manual static IP on the Pi remains valid per Stage 1.

**Source:** [research-stage-1-stable-addressing.md](research-stage-1-stable-addressing.md)

---

### A-3: Host port 53 available for Docker publish

**Description:** No other host service permanently binds **0.0.0.0:53** (or the address Docker maps) in a way that prevents the Pi-hole container from publishing DNS. On Raspberry Pi OS Bookworm, **`systemd-resolved`** stub on **127.0.0.53** is often absent; if **`docker compose up`** fails on port **53**, diagnose with **`ss`/`lsof`** before applying Ubuntu-specific **`resolved`** workarounds.

**Source:** [research-stage-2-pihole-compose.md](research-stage-2-pihole-compose.md)

---

### A-4: Opt-in clients can fall back without router-only dependency

**Description:** For Layer 0, **non-participating devices** continue to use normal router/DHCP DNS. **Opted-in** test clients can revert DNS settings locally without requiring a router reconfiguration, so rollback does not depend on a single network chokepoint beyond “use Pi-hole IP or don’t.”

**Source:** [research-stage-3-safety-rollback.md](research-stage-3-safety-rollback.md)

---

### A-5: Secrets and volume data stay out of git

**Description:** Operator-created **`.env`** (and similar) holding **`FTLCONF_webserver_api_password`** and other secrets is **not** committed; runtime data under **`./etc-pihole`** and **`./etc-dnsmasq.d`** remains on the Pi only, consistent with [`.gitignore`](../../../../.gitignore).

**Source:** [research-stage-4-minimum-deploy.md](research-stage-4-minimum-deploy.md)

---

**Last Updated:** 2026-04-17
