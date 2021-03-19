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

# FAQ

## How to turn monitors off from the command line

```sh
xset dpms force off
```

## What's up with the monitors? Why should you turn them off?

- Monitors can use a lot of power (especially older/gaming ones) ;
- You won't be able to use any hardware-accelerated applications while mining anyway ;
- If you still don't care: turning monitors off (DPMS off, actually...) allows the driver 
  to unload most graphics programs and buffers (nvidia 460.39, debian); you'll 
  therefore gain extra H/s (approx. 15% in my case).

## My cat keeps poking my mouse/keyboard, which wakes up the monitors.

I don't own a cat, but you can use a script like this to
disable the Xserver inputs, then turn the screens off.

I personally only disable my mice/gamepads but keep the keyboard enabled to
wake the monitors up.

Keep in mind that if you disable your keyboard AND mouse, you'll need
to get creative in order to wake up the monitors (`ssh stupid@desktop.home xset dpms force on`).

```fish
#!/usr/bin/env fish
#
# Use `xinput list` to find pointer (mice) IDs
set pointers 9 11 12 14 15

echo "Disabling pointers..."
for id in $pointers;
	echo " - $id"
	xinput --disable $id
end

while not xset q | grep 'Monitor is Off';
	echo "Waiting for DPMS off..."
	xset dpms force off
	sleep 1
end

while not xset q | grep 'Monitor is On';
	sleep 1
end

echo "Turning pointers on..."
for id in $pointers;
	xinput --enable $id
end
```

## Useful related links and resources

- https://ethereum.org
- https://github.com/ethereum-mining/ethminer
- https://geth.ethereum.org
- https://geth.ethereum.org/docs/interface/mining
- https://etherscan.io
