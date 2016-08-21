#!/bin/bash
downloadfolder=$HOME'/Downloads'
touch "$downloadfolder/autodownload.list"
keyw=$1
seedw=$2
if [[ -z "$keyw" ]]
then
	echo "input keyw needed"
	exit 9
fi
if [[ -z "$seedw" ]]
then 
	seedw=15
fi

echo "$seedw" | grep -qP '[0-9]+'
re_code=$?

if [[ $re_code -eq 1 ]]
	then
	echo "seedw should be number!"
	exit 11
fi



THREAD_COUNT=$(ps -ef | grep "aria2c" | grep "$keyw" | wc -l)
if [[ $THREAD_COUNT -gt 0 ]]
then
 	ariapid=`ps -ef |grep aria2 | grep "$keyw"|tail -1| awk '{print $2}'`
	runtime=`ps -p $ariapid -o etimes=`
	if [[ $runtime -gt 8000 ]]
	then
		echo "$keyw runtime $runtime , kill it now."
		kill -SIGINT  $ariapid
		sleep 30
	else
		echo "$keyw"" is proccessing... skip this now."
		exit 0
	fi
fi


#set -x
textall=`curl -s --compressed -G --data-urlencode "keyword=$keyw" http://www.36dm.com/search.php|perl -p -e 's/\r//g'`

	re_code=$?
	if [[ ! $re_code -eq 0 ]]
		then
		echo "$keyw""_""Network to 36dm error, pls check the connection!"
		date
		exit 2
	fi
exp9p=`sed -n 9p explist`
list9p=`echo $textall | grep -aoP "$exp9p"`       
exp10p=`sed -n 10p explist`
list10p=`echo $textall | grep -aoP "$exp10p"`       
exp8p=`sed -n 8p explist`
list8p=`echo $textall | grep -aoP "$exp8p"`       
exp13p=`sed -n 13p explist`
list13p=`echo $textall | grep -aoP "$exp13p"`       
ifsbk=$IFS
IFS=$'\r\n'
namelist=($(echo "$list9p"))
sizelist=($(echo "$list10p"))
p2list=($(echo "$list8p"))
timelist=($(echo "$list13p"))
IFS=$ifsbk
echo ${#namelist[@]}
echo ${#sizelist[@]}
echo ${#p2list[@]}
echo ${#timelist[@]}
#if [[ ! ${#namelist[@]} == ${#sizelist[@]} || ! ${#sizelist[@]} == ${#p2list[@]} ]]
if [[ ! ${#namelist[@]} == ${#p2list[@]} ]]
then
echo 'namelist len:'${#namelist[@]}
echo 'sizelist len:'${#sizelist[@]}
echo 'p2list len:'${#p2list[@]}
echo 2 lists not equal,please check!
echo $1
exit
fi
i='0'
#while [[ $i -lt ${#torlinklist[@]} ]]
#while [[ $i -lt ${#namelist[@]} ]]
gettarget='false'
#set -x
while [[ $i -lt ${#timelist[@]} ]]
do
echo ${namelist[i]}'***'${sizelist[i]}'***'${torlinklist[i]}'***'${dpagelist[i]}
aaaa=`echo -e '\u5B57'`
bbbb=`echo -e '\u961F'`
cccc=`echo -e '\u7EC4'`
dddd=`echo -e '\u7B80'`
eeee=`echo -e '\u7E41'`
echo ${namelist[i]} | grep -qP "[$aaaa$bbbb$cccc$dddd$eeee]"
greprec=$?
echo "greprec"$greprec
#echo ${namelist[i]} | grep -iq 'raws'
echo ${namelist[i]} | grep -iq 'raw'
checkraw=$?
echo "checkraw"$checkraw
#seedcnt=`echo ${sizelist[i]}|awk -F "</td><td>" '{print $2}'|awk -F "</td>" '{print $1}'`
#if [[ $seedcnt -gt $seedw && $greprec -eq 0 ]]
#if [[ $greprec -eq 0 && ! $checkraw -eq 0 ]]
if [[ ! $checkraw -eq 0 ]]
then

	#sizemb=`echo ${sizelist[i]}|awk '{print $1}'|awk -F '.' '{print $1}'|grep -oP '[0-9]+'`
	
	sizemb=`echo ${sizelist[i]}|grep -oP '[0-9]+'`
	sizemb=`echo $sizemb | awk '{print $1}'`
	sizeunit=`echo ${sizelist[i]}|grep -oP '[A-Z]+'`
	echo ${namelist[i]}'******'${p2list[i]}
	epnum=`echo ${namelist[i]}|grep -ioP '(?<=[\[第【\s])[0-9_\.]+(?=[\]\[話话】\s])'| tr '\n' ' '`
	echo 'epnum---------'$epnum
echo "size is " $sizemb
echo "unit is " $sizeunit
echo "ep is" $epnum
	if [[ $sizeunit == 'GB' && $sizemb -gt 2 ]]
	then
		echo "too large size, will continue"
		i=`expr $i + 1`
        	gettarget='false'
		continue
	fi
#	if [[ $sizeunit -eq 'MB' && $sizemb -lt 55 ]]
#	then
#		echo "too small size, will continue"
#		i=`expr $i + 1`
#		continue
#	fi

		#echo ${namelist[i]}'***'${sizelist[i]}'***'${p2list[i]}

	if [[ ! -z "$epnum" && "$epnum" != '-' && "$epnum" != '' ]]
	then
	    #grep -q "$keyw""_""$epnum" "$downloadfolder/autodownload.list"
            keystr="$keyw""_""$epnum" 
	    grep -q "$keystr" "$downloadfolder/autodownload.list"
	    re_code=$?
	    if [[ $re_code -eq 0 ]]
	    	then
	    	echo "$keyw""_""$epnum"" is already done!"
                i=`expr $i + 1`
                gettarget='false'
                continue
            else
                gettarget='true'
            fi

	    echo 'epnumber is '$epnum
	    break
	else 
        gettarget='false'
	fi
else
gettarget='false'
fi

i=`expr $i + 1`
done
if [[ "$gettarget" == "false" ]]
then
    echo 'no new ones found!!!'
    exit 0
fi
#read asdlkfjasflkasjdf

textall=`curl -s --compressed 'http://www.36dm.com/'"${p2list[i]}"|perl -p -e 's/\r//g'`
exp11p=`sed -n 11p explist`
list11p=`echo $textall | grep -oP "$exp11p"`       
echo $list11p
echo $i
echo 'begin download!'echo $list11p
if [[ ! -z "$list11p" && ! ${#timelist[@]} -eq 0 ]]
then
#       touch "$downloadfolder/autodownload.list"
#	grep -q "$keyw""_""$epnum" "$downloadfolder/autodownload.list"
#	re_code=$?
#	if [[ $re_code -eq 0 ]]
#		then
#		echo "$keyw""_""$epnum"" is already done!"
#		
#		date
#		exit 0
#	fi

	mkdir -p "$downloadfolder/$keyw"
	if [[ ! -f trackers.txt ]]
	then
		echo 'trackers.txt not found in current folder!'
		exit 404
	fi
	trackers=`cat trackers.txt`
        aria2c -c -d "$downloadfolder/$keyw" --log="/tmp/$keyw.log" --log-level=notice --enable-color=false --enable-dht=true --enable-dht6=true --enable-peer-exchange=true --follow-metalink=mem --seed-time=10 --max-overall-upload-limit=50K --bt-tracker=$trackers "$list11p" 
	#| tee "/tmp/$keyw.log"
	recode=$?
	if [[ $recode -eq 0 ]]
	then
		echo "$keyw""_""$epnum" >> "$downloadfolder/autodownload.list"
		date | tee -a "/tmp/$keyw.log"
		exit 0
	else
		echo "$keyw""_""$epnum not finished , interrupt when aria2c!!!" | tee -a "/tmp/$keyw.log"
		date | tee -a "/tmp/$keyw.log"
		exit 1
	fi
else
	echo "$keyw not found in web page!"
fi

date
exit 0
