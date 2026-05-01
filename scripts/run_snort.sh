#!/bin/bash

LOGDIR="/var/log/snort"
LOGFILE="$LOGDIR/alert"

echo "Starting Snort...... happy happy happyyyy...."
echo "Alert will be saved in $LOGFILE"

sudo mkdir -p "$LOGDIR"
sudo touch $LOGFILE
sudo chmod 666 $LOGFILE

#start Snort in bg
sudo snort -i ens33 -c /etc/snort/snort.conf -A fast -l /var/log/snort &
SNORT_PID=$!

#live output
sleep 2

echo "Showing live alerts>> Happyyy Happyyy Happyyyy....!!!"
tail -f "$LOGFILE"
