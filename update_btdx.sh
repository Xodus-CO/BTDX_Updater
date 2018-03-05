#!/bin/bash
# This script will update an existing Bitcloud (BTDX) Masternode.
# Only run this on systems that were installed with the BTDX-Masternode-Setup-Ubuntu-1404 script
# Located here:  https://github.com/LIMXTEC/BTDX-Masternode-Setup-Ubuntu-1404
#            !! THIS SCRIPT NEEDS TO RUN AS ROOT !!
######################################################################



clear
echo "*********** Welcome to the Bitcloud (BTDX) Masternode Update Script ***********"
echo 'This script will update your BTDX VPS to the latest version!'
echo 'This will only update your node if you used the BTDX-Masternode-Setup-Ubuntu-1404 script'
echo 'Located here:  https://github.com/LIMXTEC/BTDX-Masternode-Setup-Ubuntu-1404'
echo
echo
echo

echo '*** Updating and Compiling Bitcloud Wallet from source ***'
echo
echo '*** This process can take a very long time, depending on your VPS ***'
echo
echo '*** Please be Patient! ***'
cd ~/Bitcloud
git pull origin
echo
./autogen.sh
./configure
make
if [ $? -eq 0 ]; then
    echo '*** Compile complete ***'
else
	echo '*** Something went wrong. Exiting. ***'
	sleep 5
	exit
fi

cd src
strip bitcloudd
strip bitcloud-cli
strip bitcloud-tx
echo '*** Done 1/4 ***'
sleep 2


echo '*** Step 2/4 ***'
echo '*** Stopping existing bitcloudd processes ***'
bitcloud-cli stop
sleep 2

echo '*** Step 3/4 ***'
echo '*** Copying executables to /usr/local/bin ***'
sleep 2
cp bitcloudd /usr/local/bin
cp bitcloud-cli /usr/local/bin
cp bitcloud-tx /usr/local/bin
cd ..
echo '*** Done 3/4 ***'

sleep 2
echo '*** Step 4/4 ***'
echo '*** Starting bitcloudd ***'
sleep 2
bitcloudd &
sleep 10
bitcloud-cli getinfo
sleep 5
bitcloud-cli masternode status

echo '*** Done 4/4 ***'
echo


echo 'Masternode has been updated!'
