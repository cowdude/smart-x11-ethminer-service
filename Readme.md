# Description

This repo hosts a shell script (`run_once.sh`) that automagically starts mining
ethereum on your linux machine when your monitors turn off, and stops mining
once the monitors turn back on.

It relies on docker for running `ethminer` with the nvidia runtime. Killing my
GTX 1070 Ti at 36 MH/s with it. I was unable to notice any performance impact
due to the docker layer.

I assume you can probably attempt to port this for AMD/OpenCL. Interested to
hear about it if you do.

> Mining currencies using a GPU uses a LOT of electricity, and may cause
> **LARGE** increase(s) of your electricity bill(s). The content of this
> git repository is publicly distributed as-is, without any warranty.
> The author of this repository denies any responsability related to its usage.

# Requirements
- Docker
- nvidia runtime for docker
- linux x86_64 host with nvidia GPU supporting CUDA >= 9.0
- x11-xserver-utils (for xset)

# Quickstart

```
$ git clone https://github.com/cowdude/smart-x11-ethminer-service.git
$ cd smart-x11-ethminer-service
$ ./setup.sh
This will download ethminer in /home/cowdude/work/smart-x11-ethminer-service/ethminer. Proceed? [y/N]y
[...]
Setup complete

# Sanity check - ensure xset exists
$ xset q | grep 'Monitor is'
  Monitor is On
# If you monitors are off right now (ssh, I guess), two options:
# - turn them on; or
# - fix the bug in `run_once.sh`. (:

$ ./shell_runner.sh
**********************************************************
* WARNING: MINER_ARGS IS NOT SET. READ THE DOCUMENTATION 
*********************************************************
[...]
waiting for monitor to turn Off
[...later on - user turns monitors off]
mining in container: 3ebd10f4c9b4c1ffd0d26f96b2f8ba540ae1f7d1e1ae440988b415f2a1bc51d2
waiting for monitor to turn On
[...later on - user turns monitors on]
halting mining container: 3ebd10f4c9b4c1ffd0d26f96b2f8ba540ae1f7d1e1ae440988b415f2a1bc51d2
```

You may interrupt the runner at any time by pressing ^C (CTRL+C).

Stdout is self-explanatory :-)

# Files

`run_once.sh` waits for monitors off, then mines until they turn back on, and exit.

`shell_runner.sh` does the same in a loop-forever fashion.

`setup.sh` downloads ethminer in the working directory.

# Configuration

In order to get any income, you will need to tell `ethminer` which stratum pool you
wish you connect to. You may also pass other command-line arguments than `-P/--pool`
recognized by `ethminer`. Read `ethminer -h` and `ethminer -H con`.

```sh
export MINER_ARGS="-P ... [[-P ...] ...]"
./run_once.sh
```

