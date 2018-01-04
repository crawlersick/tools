#!/bin/bash
arc=`uname -m|cut -c 1-3`
if [[ $arc == 'arm' ]]
then
	thrcnt=5
else
	thrcnt=10
fi
IFS=$'\r\n'

time_s=`expr "3600" '*' "1"`

while [[ true ]]
do
echo `date` >> /tmp/autodown.log
namelist=($(cat auto_ani.list))
i=0
	while [[ $i -lt ${#namelist[@]} ]]
	do
#            THREAD_COUNT=$(ps | grep "36dm.sh" | wc -l)
#            while [ $THREAD_COUNT -ge $thrcnt ]
#            do
#            ps -f
#                sleep 180
#                THREAD_COUNT=$(ps | grep "36dm.sh" | wc -l)
#            done
#		
#	    36dm.sh "${namelist[i]}" &
#            sleep 30
		keyw="${namelist[i]}"
		THREAD_COUNT=$(ps -ef | grep "aria2c" | grep "$keyw" | wc -l)
		if [[ $THREAD_COUNT -gt 0 ]]
		then
			ariapid=`ps -ef |grep aria2 | grep "$keyw"|tail -1| awk '{print $2}'`
			runtime=`ps -p $ariapid -o etimes=`
			if [[ $runtime -gt 16000 ]]
			then
				echo "$keyw runtime $runtime , kill it now."
				kill -SIGINT  $ariapid
				sleep 30
			else
				echo "$keyw"" is proccessing... skip this now."
				i=`expr $i + 1`
				continue
			fi
		fi
		THREAD_COUNT=$(ps | grep "aria2c" | wc -l)
		if [[ $THREAD_COUNT -ge $thrcnt ]]
		then
			echo 'aria2c thr greater then '$thrcnt' , continue'
			sleep 900
			i=`expr $i + 1`
			continue
		fi
		./36dm.sh "${namelist[i]}" &
		sleep 50
		i=`expr $i + 1`
	done
sleep $time_s
done
