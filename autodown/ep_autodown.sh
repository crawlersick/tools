#!/bin/bash
IFS=$'\r\n'
namelist=($(cat ep.list))

time_s=`expr "3600" '*' "1"`

while [[ true ]]
do

i=0
	while [[ $i -lt ${#namelist[@]} ]]
	do
		
		kat_fetch.sh "${namelist[i]}" &
                sleep 30

	i=`expr $i + 1`
	done
sleep $time_s
namelist=($(cat ep.list))
done
