#!/bin/bash
IFS=$'\r\n'
namelist=($(cat auto_ani.list))

time_s=`expr "3600" '*' "1"`

while [[ true ]]
do

i=0
	while [[ $i -lt ${#namelist[@]} ]]
	do
		
		36dm.sh "${namelist[i]}" &
		#pogo.sh "${namelist[i]}" &
                sleep 30

	i=`expr $i + 1`
	done
sleep $time_s
namelist=($(cat auto_ani.list))
done
