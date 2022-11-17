# Puntherline's Resource Starter
Starting FiveM resources with a delay to lessen server hardware load.

## What it does
- Reading commands from its own config file (same format as the server.cfg with ensure, start, etc.)
- Starting specified resource and waiting for it to be reported as running, only then executing the next command
- Adding support for `wait [ms]` options to wait between command executions
- While the resource is processing the config.cfg, it prevents all users from joining

## Installation
- Download the resource and install it like any other.
- Add `ensure pun_resourcestarter` to your server.cfg.
- Cut all `ensure [...]` and `start [...]` commands from your server.cfg.
- Paste them into the pun_resourcestarter/config.cfg file. Make sure not to mess up the loading order if it's important on your server.
- Depending on where you need to wait between resource starts, add `wait [ms]` where it should wait.

The config.cfg has some examples. It's easy to figure out how it works.
