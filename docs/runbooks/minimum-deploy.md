# Minimum deploy (Layer 0)

**Purpose:** **Track A** — repo on the Raspberry Pi, secrets in `.env`, Docker Compose up, verify (**FR-4**). This path does **not** use mise, a private registry, or GitHub Container Registry for Layer 0 ([ADR-004](../maintainers/decisions/layer-0-foundation/adr-004-minimum-deploy-and-image-pinning.md)).

**Status:** 🟢 Operator-ready (deploy steps; digest workflow in [Pinning the Pi-hole image](#pinning-the-pi-hole-image))

---

## Prerequisites

1. **Stable Pi IPv4** — The Pi should keep the same LAN address (e.g. DHCP reservation on your router). Context and verification ideas: [ADR-001 — Stable LAN IPv4](../maintainers/decisions/layer-0-foundation/adr-001-stable-lan-addressing.md).
2. **Docker Engine** and the **Docker Compose plugin** installed on Raspberry Pi OS (or your chosen Pi OS), following Docker’s current docs for ARM if applicable.
3. **Network** — You can SSH to the Pi from a machine on your LAN and reach the Pi’s IP from clients you will point at Pi-hole for DNS.

---

## Obtain this repository

On the Pi, pick a directory for the project (example: your home directory).

**First clone:**

```bash
git clone https://github.com/grimm00/PiHole-DNS.git
cd PiHole-DNS
```

**Updates later:**

```bash
cd PiHole-DNS
git pull
```

Deploy from this directory so paths like `./etc-pihole` match [`docker-compose.yml`](../../docker-compose.yml).

---

## Secrets (`.env`)

1. At the **repository root**, create a file named `.env` (same folder as `docker-compose.yml`). You can copy the committed template:

   ```bash
   cp .env.example .env
   ```

2. Set at least (edit `.env` with a strong password):

   ```bash
   FTLCONF_webserver_api_password=your-secure-password-here
   ```

   See [`.env.example`](../../.env.example) for the same layout. Add any other variables your Compose file references.

3. **Never commit `.env`.** It is listed in [`.gitignore`](../../.gitignore). Do not paste real passwords into issues or public docs.

---

## Prepare bind-mount directories

Before first `up`, ensure these exist next to `docker-compose.yml` (empty directories are fine on first run):

```bash
mkdir -p etc-pihole etc-dnsmasq.d
```

They map to `/etc/pihole` and `/etc/dnsmasq.d` in the container per Compose.

---

## Bring up the stack

From the repo root:

```bash
docker compose pull    # optional on first run; fetches the image in docker-compose.yml
docker compose up -d
```

For image updates and restore nuances, prefer upstream docs (**C-1**): [Pi-hole — Docker upgrading](https://docs.pi-hole.net/docker/upgrading/).

---

## Verify

1. **Containers running**

   ```bash
   docker compose ps
   ```

   The `pihole` service should be **running**.

2. **Web UI** — Compose publishes **port 80** to the Pi. Open a browser to `http://<pi-stable-ipv4>/admin` (or your Pi’s hostname if it resolves). Log in with the password from `FTLCONF_webserver_api_password`.

3. **DNS** — On **one test client** (opt-in), set its DNS server to the Pi’s stable IPv4. Query a known name (e.g. `dig @<pi-ip> example.com` or use the OS network UI). Confirm queries succeed and appear in Pi-hole as expected.

---

## What Layer 0 does *not* require

Per [ADR-004](../maintainers/decisions/layer-0-foundation/adr-004-minimum-deploy-and-image-pinning.md), you do **not** need **mise**, a **private registry**, or **ghcr** for this minimum path. Registry tooling may appear in a later stage if multi-host or air-gap needs arise.

---

## Pinning the Pi-hole image

**NFR-1** / **ADR-004:** Set `pihole/pihole` to an **image digest** (`pihole/pihole@sha256:…`) in [`docker-compose.yml`](../../docker-compose.yml) after a **verified** working deploy, so rebuilds do not silently re-resolve a moving tag. For Pi-hole–specific upgrade behavior, prefer upstream docs (**C-1**): [Pi-hole — Docker upgrading](https://docs.pi-hole.net/docker/upgrading/).

### Why pin

- **Reproducibility** — The same `docker compose up` uses the same image bits.
- **Control** — You choose when to adopt a new digest; tags like `latest` can move independently of your expectations.

### When to pin or bump

- **First pin:** After **[Verify](#verify)** succeeds with the build you want to keep (often while `image:` still uses a tag such as `latest` or a version tag).
- **Bump to a newer build:** After you decide to upgrade — **back up first** (see below), then pull, pin the new digest, and smoke-test.

Always complete a [Backup and restore](backup-and-restore.md) pass (**Teleporter** + `./etc-pihole` / `./etc-dnsmasq.d`) before `docker compose pull`, image changes, or destructive volume edits.

### Pin or bump (example flow)

Run on the **Pi** from the repository root (where `docker-compose.yml` lives).

1. **Pull** the image you intend to run (skip if you only need to record the digest of an image already present):

   ```bash
   docker compose pull
   ```

   Or pull an explicit tag:

   ```bash
   docker pull pihole/pihole:latest
   ```

2. **Read the digest** Docker associated with that image:

   ```bash
   docker image inspect pihole/pihole --format '{{index .RepoDigests 0}}'
   ```

   Expect `pihole/pihole@sha256:…`. If `RepoDigests` is empty or you have several Pi-hole images, run `docker image inspect` (or `docker images`) and take the digest from the `RepoDigests` entry for the image ID you just pulled.

3. **Edit** `docker-compose.yml` — set the `pihole` service `image:` to that digest (no tag after `@sha256:…`):

   ```yaml
   # e.g. verified 2026-04-17 from tag …
   image: pihole/pihole@sha256:0123456789abcdef…
   ```

4. **Apply** the change:

   ```bash
   docker compose up -d
   ```

5. **Smoke-test** — Repeat [Verify](#verify): `docker compose ps`, Pi-hole admin UI, DNS from an opt-in client.

6. **Commit** the pin so the repo stays reproducible:

   ```bash
   git add docker-compose.yml
   git commit -m "chore(compose): pin pihole image to digest"
   ```

### Cache and offline use

**NFR-1:** On the same host, Docker **reuses the local image store** when the digest matches; you are not forced to re-pull from the registry every time. **Private registry**, **`docker save` / `load`**, and **air-gap** workflows stay **out of scope** for Layer 0 until multi-host or air-gap needs arise ([ADR-004](../maintainers/decisions/layer-0-foundation/adr-004-minimum-deploy-and-image-pinning.md), roadmap).

---

## See also

- [Backup and restore](backup-and-restore.md) — Teleporter and volume backups before upgrades (**FR-3**)
- [Runbooks index](README.md)
- [ADR-004 — Minimum deploy and image pinning](../maintainers/decisions/layer-0-foundation/adr-004-minimum-deploy-and-image-pinning.md)

---

**Last updated:** 2026-04-19
