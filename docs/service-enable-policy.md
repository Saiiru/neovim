# Service Enable Policy

Services are grouped because they change system behavior.

## Safe Base

- `network`: `NetworkManager.service`
- `audio`: user `pipewire.socket`, `pipewire-pulse.socket`, `wireplumber.service`
- `desktop-core`: `sddm.service`, if SDDM remains the chosen login manager
- `power`: `power-profiles-daemon.service`

## Explicit Optional

- `bluetooth`: `bluetooth.service`
- `printing`: `cups.service`, `cups-browsed.service`, `avahi-daemon.service`
- `docker`: `docker.service`
- `firewall-firewalld`: `firewalld.service`
- `firewall-ufw`: `ufw.service`
- `locate`: `plocate-updatedb.timer`

## Rules

- Do not enable Docker without accepting the `docker` group threat model.
- Do not enable printing or Avahi/mDNS by default.
- Do not enable Firewalld and UFW together.
- Do not enable KDE/Hyprland-specific services for the Niri profile.
- Use dry-run before applying.
- Use `--rollback-plan` before enabling optional network-exposed services.

## Commands

```bash
bash install/install.sh arcane-niri --list-groups
bash install/install.sh arcane-niri --enable-service-group bluetooth
bash install/install.sh arcane-niri --apply --enable-service-group bluetooth
bash install/install.sh arcane-niri --rollback-plan
```
