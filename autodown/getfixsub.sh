#!/bin/bash
#set -x
downloadfolder=$HOME"/Downloads"
keyw=$1
if [[ -z $keyw ]]
then
	echo 'need ep key word as first parameter!'
	exit 9
fi

THREAD_COUNT=$(ps -ef | grep "aria2c" | grep "$keyw" | wc -l)
if [[ $THREAD_COUNT -gt 0 ]]
then
	echo "$keyw"" is proccessing... skip this now."
	exit 0
fi


echo $LANG |grep -iq utf
if [[ ! $? -eq 0 ]]
then
	echo 'system lang should be set as utf supported!'
	exit 8
fi
touch "$downloadfolder/""kat_comp_list.txt"
#pyp=`echo $0|perl -p -e 's/sh$/py/'`
pyp=`basename $0|perl -p -e 's/sh$/py/'`
pathc=`pwd`
py3=`which python3`
#maglink=`"$py3 "$pathc"/"$pyp "$keyw" "$downloadfolder/""kat_comp_list.txt"`
maglink=`"$py3" $pathc"/"$pyp "$keyw" "$downloadfolder/""kat_comp_list.txt"`
link=`echo $maglink|awk -F";;;"  '{print $1}'`

if [[ ! "$link" == 'None' ]]
then
	mkdir -p "$downloadfolder/$keyw"
	aria2c -c -d "$downloadfolder/$keyw" --enable-dht=true --enable-dht6=true --enable-peer-exchange=true --follow-metalink=mem --seed-time=0 --max-overall-upload-limit=50K "${link}" | tee "/tmp/$keyw.log"
        if [[ ! $? == 0 ]]
        then
            echo "dowload aria error for $maglink"
            exit 99
        fi

	epnum=`echo $maglink|awk -F";;;"  '{print $2}'`
	echo $link"--------"$epnum
        echo "$keyw""_""$epnum">> "$downloadfolder/""kat_comp_list.txt"
else
	echo 'not found'
fi
