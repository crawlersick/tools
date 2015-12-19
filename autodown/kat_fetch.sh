#!/bin/bash
#set -x
downloadfolder=$HOME"/Downloads"
keyw=$1
if [[ -z $keyw ]]
then
	echo 'need ep key word as first parameter!'
	exit 9
fi
echo $LANG |grep -iq utf
if [[ $? -eq 0 ]]
then
	echo 'system lang should be set as utf supported!'
	exit 8
fi
pyp=`echo $0|perl -p -e 's/sh$/py/'`
maglink=`$pyp "$keyw"`
if [[ ! "$maglink" == 'None' ]]
then
	link=`echo $maglink|awk -F";;;"  '{print $1}'`
	mkdir -p "$downloadfolder/$keyw"
	aria2c -c -d "$downloadfolder/$keyw" --enable-dht=true --enable-dht6=true --enable-peer-exchange=true --follow-metalink=mem --seed-time=0 --max-overall-upload-limit=50K "${link}" | tee "/tmp/$keyw.log"

	epnum=`echo $maglink|awk -F";;;"  '{print $2}'`
	echo $link"--------"$epnum
	getsub.py "$keyw" "$epnum" "$downloadfolder/$keyw/"
else
	echo 'not found'
fi
