# Backup and restore

**Purpose:** Minimal operator runbook for Pi-hole on this repo (**FR-3**). **Teleporter** is **required** in this process ([ADR-003](../maintainers/decisions/layer-0-foundation/adr-003-backup-rollback-runbook.md)), alongside copies of the bind-mounted host directories.

**Status:** 🟢 Operator-ready (Layer 0)

---

## What to back up

Deploy from the repo root on the Pi (or your chosen host). [`docker-compose.yml`](../../docker-compose.yml) bind-mounts:

| Host path (repo root) | Inside the container | What it holds |
|----------------------|----------------------|---------------|
| `./etc-pihole` | `/etc/pihole` | Pi-hole / FTL configuration and state you care about for recovery |
| `./etc-dnsmasq.d` | `/etc/dnsmasq.d` | Custom dnsmasq snippets (if you added any) |

**Include both in your backup habit:**

1. **Directory copies** — Copy `./etc-pihole` and, if customized, `./etc-dnsmasq.d` to safe storage (another disk, your normal backup tool, etc.). These are the ground truth for files on disk.
2. **Teleporter** — In Pi-hole admin, use **Teleporter** to export a portable archive of Pi-hole settings. This repo treats Teleporter as **mandatory**, not optional-only: use it on a schedule you define, and **always** before image upgrades or destructive changes (see below). Official overview: [Teleporter](https://docs.pi-hole.net/teleporter/).

Store Teleporter exports and directory copies **outside** this git repository (e.g. home backup drive, NAS). **Never** commit exports, copies of `etc-pihole`, or secrets.

---

## When to back up

At minimum, back up (directories + Teleporter export) **before**:

- `docker compose pull` or any image tag/digest change
- Major edits to `FTLCONF_*` or other environment-driven settings in [`.env`](../../.env) / Compose
- Deleting or replacing volume data under `./etc-pihole` or `./etc-dnsmasq.d`

You may also run Teleporter on a calendar schedule if that fits how you maintain the network.

---

## Rollback order (strict)

Follow this order so clients are not left pointing at a broken resolver while you fix the Pi.

1. **Revert opt-in clients** — On machines that use the Pi as DNS, switch them back to the router’s DNS, a public resolver, or whatever you used before the change. Do this **first** so workstations keep working if the Pi is down or mid-restore.
2. **Stop the stack if needed** — From the repo directory: `docker compose down` when you must take Pi-hole offline for restore or disk work.
3. **Restore data** — Either:
   - Restore `./etc-pihole` (and `./etc-dnsmasq.d` if applicable) from your file backup, **or**
   - Restore using **Teleporter** in the Pi-hole admin UI, following upstream guidance for your Pi-hole version — see [Pi-hole — Docker upgrading](https://docs.pi-hole.net/docker/upgrading/) for restore/upgrade nuance (**C-1**).
4. **Bring the stack back** — `docker compose up -d`, then verify the admin UI and DNS from a client after you point DNS at the Pi again.

If something still misbehaves after a restore, check upstream docs for version-specific steps before following random tutorials (**C-1**).

---

## Factory reset (optional)

For **lab or test** recovery only: you can remove the contents of `./etc-pihole` (and optionally `./etc-dnsmasq.d`), remove/recreate containers, and run `docker compose up -d` to get a fresh Pi-hole. You will lose local settings unless you have a Teleporter export or file backup. Do not treat this as a routine production procedure without understanding the impact on your LAN.

---

## Secrets and redaction

- Do **not** paste real passwords or API keys into issues, chats, or committed docs.
- Web password and related values belong in **`.env`** (untracked) and the Pi-hole UI — refer to those, do not copy values into runbooks.

---

## See also

- [ADR-003 — Backup scope and rollback runbook](../maintainers/decisions/layer-0-foundation/adr-003-backup-rollback-runbook.md)
- [Runbooks index](README.md)
- [Pi-hole — Docker upgrading](https://docs.pi-hole.net/docker/upgrading/)

---

**Last updated:** 2026-04-17
