#!/bin/sh -e

read -p "This will download ethminer in $PWD/ethminer. Proceed? [y/N]" choice
case "$choice" in
  y|Y ) break;;
  * ) exit 1;;
esac

mkdir -p ethminer
wget --no-clobber -O ethminer.tar.gz \
	https://github.com/ethereum-mining/ethminer/releases/download/v0.19.0-alpha.0/ethminer-0.19.0-alpha.0-cuda-9-linux-x86_64.tar.gz
cd ethminer
tar xvf ../ethminer.tar.gz
rm ../ethminer.tar.gz

echo
echo Setup complete
