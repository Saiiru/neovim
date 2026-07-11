#!/Users/nick/.config/nvim/env/bin/python3
from os import environ
from pynvim import attach

nvim = attach('socket', path=environ.get("NVIM_LISTEN_ADDRESS", '/tmp/nvimsocket'))
nvim.command('UpdateTheme()')
