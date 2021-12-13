#!/usr/bin/env python3.7

import asyncio
import iterm2
import pathlib
from subprocess import run


async def main(connection):
    # Define the configuration knobs:
    component = iterm2.StatusBarComponent(
        short_description="Spotify",
        detailed_description="Show the current track.",
        knobs=[],
        exemplar="Artist. Name.",
        update_cadence=15,
        identifier="com.iterm2.example.spotify")

    @iterm2.StatusBarRPC
    async def coro(
            knobs,
            rows=iterm2.Reference("rows"),
            cols=iterm2.Reference("columns")):
        output = run(['ps', 'aux'], capture_output=True, encoding='utf8')
        is_running = '/MacOS/Spotify' in output.stdout
        if is_running:
            res = run([pathlib.Path.home().joinpath('spotify')], check=True, capture_output=True, encoding='utf8')
            lines = res.stdout.splitlines()
            if lines:
                return lines[0]
            else:
                return ''
        else:
            return ''

    # Register the component.
    await component.async_register(connection, coro)


iterm2.run_forever(main)
