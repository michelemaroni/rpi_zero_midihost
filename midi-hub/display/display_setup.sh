#!/bin/bash

backups = $1
connectall_display = connectall_display.rb

if test -f "$connectall_display"; then
    echo "$connectall_display exists."
fi
sudo apt install fonts-lato
sudo python -m pip install --upgrade pip setuptools wheel
sudo pip install Adafruit-SSD1306

#OPTIONAL DISPLAY SETUP
echo "Configure Display"
sudo chmod a+x lcd-show.py
sudo mv /usr/local/bin/

echo "Sent test line to display"
lcd-show.py "first line" "second line" "here's a quite long line" "4th line of text"

FILE=/usr/local/bin/
if [[ -f "$FILE" ]]; then
	echo "$FILE exists. Backup in $backups and update"
	sudo cp $FILE $backups
	sudo cat $connectall_display >> $FILE
else 
	echo "$FILE does not exist. Created configuration from $connectall_display"
	sudo cp $connectall_display $FILE
fi

echo "Display setup completed."
