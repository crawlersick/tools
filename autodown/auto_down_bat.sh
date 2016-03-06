#!/bin/bash
IFS=$'\r\n'
namelist=($(cat auto_ani.list))

time_s=`expr "3600" '*' "1"`

while [[ true ]]
do

i=0
	while [[ $i -lt ${#namelist[@]} ]]
	do
            THREAD_COUNT=$(ps | grep "36dm.sh" | wc -l)
            while [ $THREAD_COUNT -ge 2 ]
            do
            ps -f
                sleep 180
                THREAD_COUNT=$(ps | grep "36dm.sh" | wc -l)
            done
		
	    36dm.sh "${namelist[i]}" &
            sleep 30

	i=`expr $i + 1`
	done
sleep $time_s
namelist=($(cat auto_ani.list))
done
