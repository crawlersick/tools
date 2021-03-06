#!/bin/bash
if [[ -f /tmp/autodown.log ]]
then
echo "found /tmp/autodown.log, maybe duplicated process? exit now....." |tee /tmp/autodown.log
exit
fi

function finish {
	rm -rf /tmp/autodown.log
}

trap finish EXIT
trap finish ERR

arc=`uname -m|cut -c 1-3`
if [[ $arc == 'arm' ]]
then
	thrcnt=4
else
	thrcnt=4
fi
IFS=$'\r\n'

time_s=`expr "800" '*' "1"`

templist='/tmp/eps.list'
#templist='/tmp/acgripinfo.txt'

while [[ true ]]
do

rm -rf $templist
if [[ -f $templist ]]
then
echo "unable rm $templist....."`date` | tee /tmp/autodown.log
exit
fi
echo "start loop....."`date` | tee /tmp/autodown.log

#curl -X POST -d "{\"keyl\":\"https://acg.rip/\"}" "https://vm.n4r.nl/do" > /tmp/acgripinfo.txt
./anlsweb.sh 'http://share.dmhy.org/' 'dmhy.re' > /tmp/eps.list
re_code=$?
if [[ ! $re_code -eq 0 ]]
then
    rm $templist 
    echo "Network error, pls check the connection!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    date
fi



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
		#THREAD_COUNT=$(ps | grep "aria2c" | wc -l)
		THREAD_COUNT=$(ps | grep "auto_down_bat" | wc -l)
		if [[ $THREAD_COUNT -ge $thrcnt ]]
		then
			#echo 'aria2c thr greater then '$thrcnt' , continue'
			echo 'auto_down_bat thr greater then '$thrcnt' , continue: ------>  '$keyw
			sleep 10
		#	i=`expr $i + 1`
			continue
		fi
		#./acgrip2.sh "${namelist[i]}" &
		./call_anlsweb.sh "${namelist[i]}" &
		sleep 3
		i=`expr $i + 1`
	done
echo "will sleep $time_s for next run"
sleep $time_s
done
