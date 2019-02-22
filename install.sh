#!/bin/sh
echo "creating directory in /etc/, moving midiconnect scripts there, setting permissions..."
if [ ! -d /etc/rpi-midi-hub ]
then
	mkdir /etc/rpi-midi-hub
fi
cp ./midiconnect.sh /etc/rpi-midi-hub/
cp ./midiconnect.py /etc/rpi-midi-hub/
chown -R root:root /etc/rpi-midi-hub
chmod -R a+rx /etc/rpi-midi-hub

echo "create udev rule to run script on USB add/remove"
cp ./89-rpi-midi-hub.rules /etc/udev/rules.d

echo "running multimidicast"
systemctl stop multimidicast
cp ./multimidicast /usr/local/bin
chmod a+rx /usr/local/bin/multimidicast
cp ./multimidicast.service /etc/systemd/system
systemctl enable multimidicast
systemctl start multimidicast
cp ./midiconnect.service /etc/systemd/system
systemctl enable midiconnect

echo "running midiconnect!"
/etc/rpi-midi-hub/midiconnect.sh

echo "setup complete."
