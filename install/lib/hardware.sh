#!/usr/bin/env bash

# Hardware detection helpers for installer workflows.
# This file is intentionally conservative: it reports and selects package
# groups, but does not install drivers by itself.

detect_gpu_summary() {
  if command -v lspci >/dev/null 2>&1; then
    lspci -nnk | awk '
      /VGA compatible controller|3D controller|Display controller/ {
        print
        in_gpu=1
        next
      }
      in_gpu && /Kernel driver in use|Kernel modules/ {
        print
        next
      }
      in_gpu && /^[0-9a-fA-F:.]+ / {
        in_gpu=0
      }
    '
  else
    printf 'lspci not available\n'
  fi
}

detect_gpu_vendor_set() {
  local gpu_info
  gpu_info="$(detect_gpu_summary 2>/dev/null || true)"

  if grep -Eiq 'nvidia' <<<"$gpu_info"; then
    printf '%s\n' nvidia
  fi
  if grep -Eiq 'amd|advanced micro devices|radeon|ati' <<<"$gpu_info"; then
    printf '%s\n' amd
  fi
  if grep -Eiq 'intel' <<<"$gpu_info"; then
    printf '%s\n' intel
  fi
}

detect_gpu_driver_group() {
  local vendors=()
  mapfile -t vendors < <(detect_gpu_vendor_set | sort -u)

  case "${#vendors[@]}" in
    0)
      printf '%s\n' gpu-generic
      ;;
    1)
      case "${vendors[0]}" in
        amd) printf '%s\n' gpu-amd ;;
        intel) printf '%s\n' gpu-intel ;;
        nvidia) printf '%s\n' gpu-nvidia-proprietary ;;
        *) printf '%s\n' gpu-generic ;;
      esac
      ;;
    *)
      printf '%s\n' gpu-hybrid
      ;;
  esac
}

print_hardware_report() {
  printf 'Hardware report\n'
  printf '===============\n\n'
  printf 'GPU summary:\n'
  detect_gpu_summary | sed 's/^/  /'
  printf '\nDetected GPU vendors:\n'
  local vendors
  vendors="$(detect_gpu_vendor_set | sort -u | paste -sd ', ' -)"
  printf '  %s\n' "${vendors:-none}"
  printf '\nRecommended driver package group:\n'
  printf '  %s\n' "$(detect_gpu_driver_group)"
}
