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

1. At the **repository root**, create a file named `.env` (same folder as `docker-compose.yml`).
2. Set at least:

   ```bash
   FTLCONF_webserver_api_password=your-secure-password-here
   ```

   Add any other variables your Compose file references.

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

**NFR-1** / **ADR-004:** After a **verified** working deploy, pin `pihole/pihole` using a **digest** in `docker-compose.yml` so rebuilds do not silently re-resolve a moving tag.

**Step-by-step** commands (pull, `docker image inspect`, edit Compose, smoke-test) will be added in this same document as the Layer 0 runbook set is completed. Until then, use [Pi-hole — Docker upgrading](https://docs.pi-hole.net/docker/upgrading/) for image lifecycle (**C-1**) and [ADR-004](../maintainers/decisions/layer-0-foundation/adr-004-minimum-deploy-and-image-pinning.md) for project policy.

---

## See also

- [Backup and restore](backup-and-restore.md) — Teleporter and volume backups before upgrades (**FR-3**)
- [Runbooks index](README.md)
- [ADR-004 — Minimum deploy and image pinning](../maintainers/decisions/layer-0-foundation/adr-004-minimum-deploy-and-image-pinning.md)

---

**Last updated:** 2026-04-17
