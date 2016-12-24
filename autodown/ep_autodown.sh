#!/bin/bash
bkifs=$IFS
IFS=$'\r\n'
namelist=($(cat ep.list))
IFS=$bkifs
time_s=`expr "3600" '*' "1"`
while [[ true ]]
do
i=0
	while [[ $i -lt ${#namelist[@]} ]]
	do
		#kat_fetch.sh "${namelist[i]}" &
		./getfixsub.sh "${namelist[i]}" &
                sleep 13
	i=`expr $i + 1`
	done
sleep $time_s
IFS=$'\r\n'
namelist=($(cat ep.list))
IFS=$bkifs
done
