#!/bin/bash

backups = $1
midi_boot = midi_boot.cfg
midi_pnp = midi_pnp.cfg

if [[ -f $midi_pnp && -f $midi_boot ]]; then
    echo "Both $midi_pnp and $midi_boot files exist."
fi

#Download conectall.rb and set as executable
echo "Install connectal.rb script"
wget -O connectall.rb https://gist.githubusercontent.com/chmanie/4f2838f4548d25b9c883f7d6d074f67c/raw/5d73927cf8f8bc1055963559aa44e7faa00926ed/connectall.rb
sudo chmod +x connectall.rb
sudo mv connectall.rb /usr/local/bin/

echo "Test atuconnect MIDI service"
connectall.rb
aconnect -l

#Configure automatic MIDI connection/disconnection on USB device connect/disconnect
echo "Setup MIDI PnP"
FILE=/etc/udev/rules.d/33-midiusb.rules
if [[ -f "$FILE" ]]; then
	echo "$FILE exists. Backup in $backups and update"
	sudo cp $FILE $backups
	sudo cat $midi_pnp >> $FILE
else 
	echo "$FILE does not exist. Created configuration from $midi_pnp"
	sudo cp $midi_pnp $FILE
fi

sudo udevadm control --reload
sudo service udev restart

#Configure MIDI connection at system boot
echo "Configure MIDI autoconnect at boot"
FILE=/lib/systemd/system/midi.service
if [[ -f "$FILE" ]]; then
	echo "$FILE exists. Backup in $backups and update"
	sudo cp $FILE $backups
	sudo cat $midi_boot >> $FILE
else 
	echo "$FILE does not exist. Created configuration from $midi_boot"
	sudo cp $midi_boot $FILE
fi

echo "Restart MIDI service"
sudo systemctl daemon-reload
sudo systemctl enable midi.service
sudo systemctl start midi.service

echo "MIDI setup completed."