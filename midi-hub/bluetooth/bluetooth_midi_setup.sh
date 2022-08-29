#!/bin/bash

backups = $1
btmidi_pnp = btmidi_pnp.cfg
btmidi_boot = btmidi_boot.cfg

if [[ -f $btmidi_pnp && -f $btmidi_boot ]]; then
    echo "Both $btmidi_pnp and $btmidi_boot files exist."
fi

git clone https://github.com/oxesoft/bluez
sudo apt-get install -y autotools-dev libtool autoconf
sudo apt-get install -y libasound2-dev
sudo apt-get install -y libusb-dev libdbus-1-dev libglib2.0-dev libudev-dev libical-dev libreadline-dev
cd bluez
./bootstrap
./configure --enable-midi --prefix=/usr --mandir=/usr/share/man --sysconfdir=/etc --localstatedir=/var
make
sudo make install
echo "Test Bluetooth MIDI"
sudo btmidi-server -v -n "RPi Bluetooth"

FILE=/etc/udev/rules.d/44-bt.rules
if [[ -f "$FILE" ]]; then
	echo "$FILE exists. Backup in $backups and update"
	sudo cp $FILE $backups
	sudo cat $btmidi_pnp >> $FILE
else 
	echo "$FILE does not exist. Created configuration from $btmidi_pnp"
	sudo cp $btmidi_pnp $FILE
fi

sudo udevadm control --reload
sudo service udev restart

#Configure MIDI connection at system boot
echo "Configure Bluetooth MIDI autoconnect at boot"

FILE=/lib/systemd/system/btmidi.service
if [[ -f "$FILE" ]]; then
	echo "$FILE exists. Backup in $backups and update"
	sudo cp $FILE $backups
	sudo cat $btmidi_boot >> $FILE
else 
	echo "$FILE does not exist. Created configuration from $btmidi_boot"
	sudo cp $btmidi_boot $FILE
fi

echo "Restart Bluetooth MIDI service"
sudo systemctl daemon-reload
sudo systemctl enable btmidi.service
sudo systemctl start btmidi.service

echo "Bluetooth MIDI setup completed."
