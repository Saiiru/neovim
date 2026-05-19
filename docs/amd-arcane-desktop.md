# AMD Arcane Desktop Notes

This repo already has an AMD-safe policy.

## Current Config

```text
config/environment.d/30-amd.conf
```

Current local policy:

```text
AMD_VULKAN_ICD=RADV
```

`RADV_PERFTEST` is intentionally not forced because ACO is already RADV's default on current Mesa.

## Steam

Steam should be launched through:

```text
config/niri/scripts/desktop/steam-safe.sh
```

That wrapper keeps RADV explicit and avoids experimental Vulkan flags that can make debugging worse.

## Useful Packages

Check that the package lists cover the usual AMD workstation baseline:

- `mesa`
- `vulkan-radeon`
- `vulkan-tools`
- `libva-mesa-driver`
- `mesa-vdpau`
- `nvtop`

Do not add every gaming package by default. Keep gaming extras explicit and reviewable.

## Validation

```bash
printenv AMD_VULKAN_ICD
vulkaninfo --summary
```

If `vulkaninfo` is missing, install `vulkan-tools`.

## Relationship To Dr460nized

Garuda Dr460nized is used here as visual/system inspiration, not as an automatic source of AMD settings.

The local AMD policy wins over upstream theme defaults.
