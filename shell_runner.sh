#!/bin/sh

# this is a simple and stupid runner for the main script
# the loop is not part of run.sh, as it may be more
# preferable to use another runner to execute it on
# your machine, for example systemd/cron daemons.

while true; do
	./run_once.sh
	sleep 1
done
