#!/bin/bash
#set -x
downloadfolder=$HOME"/Downloads"
keyw='big bang'
pyp=`echo $0|perl -p -e 's/sh$/py/'`
maglink=`$pyp "$keyw"`
if [ ! "$maglink" == 'None' ]
then
	link=`echo $maglink|awk -F"'"  '{print $4}'`
	mkdir -p "$downloadfolder/$keyw"
	aria2c -c -d "$downloadfolder/$keyw" --enable-dht=true --enable-dht6=true --enable-peer-exchange=true --follow-metalink=mem --seed-time=0 --max-overall-upload-limit=50K "${link}" | tee "/tmp/$keyw.log"
else
	echo 'not found'
fi
