# Arduino Neovim Pipeline

This repo already has a multi-board Arduino workflow in:

```text
config/nvim/lua/config/arduino.lua
config/nvim/lua/config/servers/arduino_language_server.lua
config/nvim/lua/config/servers/clangd.lua
```

## What Is Already Done

- Uno, Nano, Mega, ESP32 Dev Module, ESP32 DOIT, ESP32-S3, and ESP32-C3 profiles.
- FQBN state stored in `vim.g.arduino_fqbn`.
- Baud state stored in `vim.g.arduino_baud`.
- Port state stored in `vim.g.arduino_port`.
- Auto port detection using `arduino-cli board list --format json` with `/dev/ttyUSB*`, `/dev/ttyACM*`, and `/dev/serial/by-id/*` fallback.
- `arduino-cli compile`, `upload`, `monitor`, `core list`, `board list`, and `lib list`.
- Per-sketch build cache under Neovim cache.
- Arduino Language Server receives the active FQBN.
- `clangd` is blocked from attaching to `.ino` sketches and Arduino roots.
- Project task integration maps build/run/dev/clean/check into Arduino commands.

## One-Time CLI Setup

```bash
bash install/setup_arduino_cli.sh
```

Only AVR:

```bash
bash install/setup_arduino_cli.sh --avr-only
```

Only ESP32:

```bash
bash install/setup_arduino_cli.sh --esp32-only
```

## Neovim Commands

```vim
:ArduinoEnvUno
:ArduinoEnvESP32
:ArduinoEnvESP32Doit
:ArduinoEnvESP32S3
:ArduinoEnvESP32C3
:ArduinoBoardSelect
:ArduinoFqbn
:ArduinoPortSelect
:ArduinoPortAuto
:ArduinoCompile
:ArduinoUpload
:ArduinoUploadSafe
:ArduinoMonitor
:ArduinoDoctor
:ArduinoStatus
:ArduinoPrompt
```

## Normal Uno Flow

```vim
:ArduinoEnvUno
:ArduinoPortSelect
:ArduinoCompile
:ArduinoUpload
:ArduinoMonitor
```

## Normal ESP32 Flow

```vim
:ArduinoEnvESP32
:ArduinoPortSelect
:ArduinoCompile
:ArduinoUpload
:ArduinoMonitor
```

## Safer Fast Flow

```vim
:ArduinoEnvUno
:ArduinoUploadSafe
```

Or:

```vim
:ArduinoEnvESP32
:ArduinoUploadSafe
```

`ArduinoUploadSafe` picks the best detected port and adopts the detected FQBN when `arduino-cli` reports one.

## Diagnostics

Inside Neovim:

```vim
:ArduinoDoctor
```

Outside Neovim:

```bash
which arduino-cli
which arduino-language-server
which clangd
arduino-cli config dump
arduino-cli core list
arduino-cli board list
ls -l /dev/ttyUSB* /dev/ttyACM* /dev/serial/by-id/* 2>/dev/null
groups
```

On Arch, serial permission usually needs:

```bash
sudo usermod -aG uucp "$USER"
```

Then log out and log in again.

## Important Boundary

This is an Arduino CLI workflow. PlatformIO projects should be treated separately when they need PlatformIO-specific build flags, libraries, environments, and generated `compile_commands.json`.
