#!/usr/bin/env python3
import asyncio
import os
import iterm2
import subprocess

async def main(connection):
    async with iterm2.VariableMonitor(connection, iterm2.VariableScopes.APP, "effectiveTheme", None) as mon:
        # async with attach('socket', path='/tmp/nvim/nvim57620.sock') as nvim:
        while True:
            # Block until theme changes
            theme = await mon.async_get()
            app = await iterm2.async_get_app(connection)

            # Themes have space-delimited attributes, one of which will be light or dark.
            parts = theme.split(" ")
            profile_name = 'Dark' if 'dark' in parts else 'Light'
            partial_profiles = await iterm2.PartialProfile.async_query(connection)
            profile = None

            confdir  = os.path.dirname(os.path.realpath(__file__))
            venvdir = os.path.join(confdir, ".venv")

            try:
                subprocess.run([f"{venvdir}/bin/python3", f"{confdir}/scripts/nvim-notify-theme.py"])
            except subprocess.CalledProcessError as err:
                print('Unable to notify vim: {0}'.format(err))

            for partial in partial_profiles:
                if partial.name == profile_name:
                    profile = await partial.async_get_full_profile()

            for window in app.windows:
                for tab in window.tabs:
                    for session in tab.sessions:
                        await session.async_set_profile(profile)

            await profile.async_make_default()

iterm2.run_forever(main)
