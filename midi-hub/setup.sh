#!/bin/bash

backups = 'backups/'

sudo chmod +x test.sh install_prerequisites.sh midi/midi_setup.sh bluetooth/bluetooth_midi_setup.sh display/display_setup.sh ro/ro_setup.sh

./test.sh

#Install prerequisites
echo "Installing prerequisites"
./install_prerequisites.sh 

#Install prerequisites
echo "Setup MIDI services"
./midi/midi_setup.sh $backups

#OPTIONAL MIDI BLUETOOTH SETUP
echo "Setup Bluetooth MIDI"
./bluetooth/bluetooth_midi_setup.sh $backups

#OPTIONAL MIDI BLUETOOTH SETUP
echo "Setup Display"
./display/display_setup.sh $backups

#Setup read only
echo "Setup read-only mode"
./ro/ro_setup.sh

echo "Completed!"
