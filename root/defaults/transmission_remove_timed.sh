#!/bin/bash

# read variables
. /defaults/variables.txt

SERVER="localhost:9091"

if [[ $AUTHENABLE = "yes" ]] || ([[ -n $USER ]] && [[ -n $PASS ]]); then
  SERVER="$SERVER --auth $USER:$PASS"
fi

# calculate the seed time in seconds from days
SEED_TIME=$(expr 86400 \* ${SEEDTIME:=1})

# use transmission-remote to get torrent list from transmission-remote list
TORRENTLIST=`transmission-remote $SERVER --list | sed -e '1d' -e '$d' | awk '{print $1}' | sed -e 's/[^0-9]*//g'`

NOW=$(date)
echo "$NOW Running torrent cleanup script with cutoff: $SEED_TIME"

# for each torrent in the list
for TORRENTID in $TORRENTLIST
do
    INFO=$(transmission-remote $SERVER --torrent $TORRENTID --info)
    echo -e "Processing #$TORRENTID - $(echo $INFO | sed -e 's/.*Name: \(.*\) Hash.*/\1/')"
    
    # check if torrent download is completed
    DL_COMPLETED=`echo $INFO | grep -c "Percent Done: 100%"`
    # check torrents current state is
    STATE_STOPPED=`echo $INFO | grep -c "State: Seeding\|State: Stopped\|State: Finished\|State: Idle"`
    # check torrents current seeded time is
    SEEDED_TIME=`echo $INFO | grep -Eo "Seeding Time: .+\((\d+) seconds\)" | cut -d"(" -f2 | cut -d" " -f1`
    # set seeded time to zero if incomplete
    if [[ "${SEEDED_TIME}" == "" ]]; then SEEDED_TIME=0; fi

    # if the torrent is "Stopped", "Finished", or "Idle after downloading 100%" and has met the required seed time in days
    if [[ $DL_COMPLETED -eq 1 ]] && [[ $STATE_STOPPED -eq 1 ]] && [[ $SEEDED_TIME -gt $SEED_TIME ]]; then
        if [[ $AUTODELETE = "yes" ]]; then
          echo "Torrent #$TORRENTID is completed. Removing torrent from list and deleting files."
          transmission-remote $SERVER --torrent $TORRENTID --remove-and-delete
        else
          echo "Torrent #$TORRENTID is completed. Removing torrent from list."
          transmission-remote $SERVER --torrent $TORRENTID --remove
        fi
    else
        echo "Torrent #$TORRENTID has not met removal requirements. Ignoring."
    fi
done
