#!/bin/bash

downloadfolder=$HOME'/Downloads'
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
	echo "$keyw"" is proccessing... skip this now."
	exit 0
fi


#set -x
textall=`curl -s --compressed -G --data-urlencode "title=$keyw" http://share.popgo.org/search.php`

	re_code=$?
	if [[ ! $re_code -eq 0 ]]
		then
		echo "$keyw""_""Network to pogo error, pls check the connection!"
		date
		exit 2
	fi

#set +x
IFS=$'\r\n'
namelist=($(echo $textall | grep -oP "`sed -n 2p explist`"))
sizelist=($(echo $textall | grep -oP "`sed -n 3p explist`"))
dpagelist=($(echo $textall | grep -oP "`sed -n 4p explist`"))
torlinklist=($(echo $textall | grep -oP "`sed -n 5p explist`"))
#set -x
if [[ ! ${#torlinklist[@]} == ${#dpagelist[@]} && ${#namelist[@]} == ${#sizelist[@]} && ${#sizelist[@]} == ${#dpagelist[@]} ]]
then
echo 'namelist len:'${#namelist[@]}
echo 'sizelist len:'${#sizelist[@]}
echo 'dpagelist len:'${#dpagelist[@]}
echo 'torlinklist len:'${#torlinklist[@]}
echo 4 lists not equal,please check!
fi
i='0'
while [[ $i -lt ${#torlinklist[@]} ]]
do
#echo ${namelist[i]}'***'${sizelist[i]}'***'${torlinklist[i]}'***'${dpagelist[i]}
aaaa=`echo -e '\u5B57'`
bbbb=`echo -e '\u961F'`
cccc=`echo -e '\u7EC4'`
dddd=`echo -e '\u7B80'`
eeee=`echo -e '\u7E41'`
echo ${namelist[i]} | grep -qP "[$aaaa$bbbb$cccc$dddd$eeee]"
greprec=$?
seedcnt=`echo ${sizelist[i]}|awk -F "</td><td>" '{print $2}'|awk -F "</td>" '{print $1}'`

if [[ $seedcnt -gt $seedw && $greprec -eq 0 ]]
then

	sizemb=`echo ${sizelist[i]}|awk -F "</td><td>" '{print $1}'|awk '{print $1}'|awk -F '.' '{print $1}'`
	sizeunit=`echo ${sizelist[i]}|awk -F "</td><td>" '{print $1}'|awk '{print $2}'`
echo "size is " $sizemb
echo "unit is " $sizeunit
	if [[ $sizeunit -eq 'MB' && $sizemb -lt 55 ]]
	then
		echo "too small size, will continue"
		i=`expr $i + 1`
		continue
	fi

		echo ${namelist[i]}'***'${sizelist[i]}'***'${torlinklist[i]}'***'${dpagelist[i]}

#【極影字幕社】 ★ 六花的勇者 Rokka_no_Yuusha 第03話 BIG5 MP4 720P
#【極影字幕社】 ★7月新番 【亂步奇譚 Game of Laplace】【Ranpo Kitan Game of Laplace】【03】BIG5 MP4_720P
       #epnum=`echo ${namelist[i]}|grep -ioP '(?<=[\[第【\s])[0-9_\.-]+(?=[\]話话】\s])'`
	epnum=`echo ${namelist[i]}|grep -ioP '(?<=[\[第【\s])[0-9_\.]+(?=[\]\[話话】\s])'`
	echo 'epnum---------'$epnum

	if [[ ! -z "$epnum" && "$epnum" != '-' ]]
	then

		echo 'epnumber is '$epnum
		break
	else 
	torlinklist[i]=""
	fi
	
fi

i=`expr $i + 1`
done

echo 'begin download!'${torlinklist[i]}
#read asdlkfjasflkasjdf
if [[ ! -z "${torlinklist[i]}" ]]
then
	touch "$downloadfolder/autodownload.list"
	grep -q "$keyw""_""$epnum" "$downloadfolder/autodownload.list"
	re_code=$?
	if [[ $re_code -eq 0 ]]
		then
		echo "$keyw""_""$epnum"" is already done!"
		
		date
		exit 0
	fi

	mkdir -p "$downloadfolder/$keyw"
	aria2c -c -d "$downloadfolder/$keyw" --enable-dht=true --enable-dht6=true --enable-peer-exchange=true --follow-metalink=mem --seed-time=0 --disk-cache=1024M --enable-color=true --max-overall-upload-limit=50K --bt-tracker="udp://coppersurfer.tk:6969/announce,http://t2.popgo.org:7456/annonce" "${torlinklist[i]}" | tee "/tmp/$keyw.log"
	recode=$?
	if [[ $recode -eq 0 ]]
	then
		echo "$keyw""_""$epnum" >> "$downloadfolder/autodownload.list"
		tail "/tmp/$keyw.log" | perl -p -e 's/\/home\/.*?\//^_^.../' |  mail -v -s "$keyw""_""$epnum"" Done!" `git config --get user.email` 
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
