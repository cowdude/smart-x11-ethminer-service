#!/bin/sh

# args passed to ethminer
if [ -z "$MINER_ARGS" ]; then
	echo "**********************************************************"
	echo "* WARNING: MINER_ARGS IS NOT SET. READ THE DOCUMENTATION "
	echo "*********************************************************"
	MINER_ARGS="
	--HWMON 2 \
	--display-interval 30 \
	-P stratum+ssl://0xDe8Af736Bb84f88166B22a23a60f21b22f9d7698.w0@eu1.ethermine.org:5555 \
	-P stratum+ssl://0xDe8Af736Bb84f88166B22a23a60f21b22f9d7698.w0@us1.ethermine.org:5555 \
	-P stratum+ssl://0xDe8Af736Bb84f88166B22a23a60f21b22f9d7698.w0@us2.ethermine.org:5555"
fi

echo "ethminer args: $MINER_ARGS"

###############################################################################

cleanup()
{
	if [ -n "$container" ]; then
		echo "halting mining container: $container"
		docker stop "$container" || docker rm -f "$container"
	fi
	exit 0
}

wait()
{
	echo waiting for monitor to turn $1
	while [ -z "$(xset q | grep Monitor\ is\ $1)" ]; do
		sleep 1
	done
}

trap cleanup 1 2 3 6 15
wait Off
container=$(docker run -d -v $PWD/ethminer:/mnt:ro --runtime=nvidia nvidia/cuda:9.0-runtime /mnt/bin/ethminer $MINER_ARGS)
echo "mining in container: $container"
wait On
cleanup
