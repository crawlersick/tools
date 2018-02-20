#!/bin/bash
#umask 011
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

echo "$keyw start try.."

set -x
textall=`curl  -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: en-US,en;q=0.8,zh-CN;q=0.6,zh;q=0.4,zh-TW;q=0.2,ja;q=0.2' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.109 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8' -H 'Cache-Control: max-age=0' -H 'Cookie: a9736_times=1; __cfduid=db83c82b946a05cf3b280ab2522b166391515574699; cf_clearance=a10f0ec1a4e016678737296c7bd828aac4c1ef41-1515683740-1800; 8176=1; AJSTAT_ok_pages=2; AJSTAT_ok_times=2; __tins__6000273=%7B%22sid%22%3A%201515683900601%2C%20%22vd%22%3A%202%2C%20%22expires%22%3A%201515685740503%7D; __51cke__=; __51laig__=2; Hm_lvt_dfa59ae97c988b755b7dfc45bbf122ae=1515379378,1515485084,1515574704,1515646521; Hm_lpvt_dfa59ae97c988b755b7dfc45bbf122ae=1515683941' -s --compressed -G --data-urlencode "keyword=$keyw" https://www.36dm.com/search.php|perl -p -e 's/\r//g'`
set +x
while [[ $textall == *"WebShieldSessionVerify"* ]] || [[ $textall == *"sitedog_stat"* ]]
do
textall=`curl -s --compressed -G --data-urlencode "keyword=$keyw" http://www.36dm.com/search.php|perl -p -e 's/\r//g'`
echo 'web verify hit, rep...., got length: '${#textall}
sleep 1000
done

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
ffff=`echo -e '\u3010\u9884\u544A\u3011'`
gggg=`echo -e '\u3010\u9810\u544A\u3011'`
#hhhh=`echo -e '\u82F1\u8BED\u5B57\u5E55'`
hhhh=`echo -e '英语字幕'`

echo ${namelist[i]} | grep -q "$ffff"
greprec=$?
if [[ $greprec -eq 0 ]]
then
	echo 'prev1 found exit:'$ffff
	i=`expr $i + 1`
        gettarget='false'
	continue
fi
echo ${namelist[i]} | grep -q "$gggg"
greprec=$?
if [[ $greprec -eq 0 ]]
then
	echo 'prev2 found exit:'$gggg
	i=`expr $i + 1`
        gettarget='false'
	continue
fi
echo ${namelist[i]} | grep -q "$hhhh"
greprec=$?
if [[ $greprec -eq 0 ]]
then
	echo 'prev3 found exit:'$hhhh
	i=`expr $i + 1`
        gettarget='false'
	continue
fi


echo ${namelist[i]} | grep -qP "[$aaaa$bbbb$cccc$dddd$eeee]"
greprec=$?
echo "greprec"$greprec
#echo ${namelist[i]} | grep -iq 'raws'
echo ${namelist[i]} | grep -iq 'raw'
checkraw=$?
echo ${namelist[i]} | grep -iq 'prev'
checkprev=$?
echo "checkprev"$checkprev
echo "checkraw"$checkraw
#seedcnt=`echo ${sizelist[i]}|awk -F "</td><td>" '{print $2}'|awk -F "</td>" '{print $1}'`
#if [[ $seedcnt -gt $seedw && $greprec -eq 0 ]]
#if [[ $greprec -eq 0 && ! $checkraw -eq 0 ]]
if [[ ! $checkraw -eq 0 && ! $checkprev -eq 0 ]]
then

	#sizemb=`echo ${sizelist[i]}|awk '{print $1}'|awk -F '.' '{print $1}'|grep -oP '[0-9]+'`
	
	sizemb=`echo ${sizelist[i]}|grep -oP '[0-9]+'`
	sizemb=`echo $sizemb | awk '{print $1}'`
	sizeunit=`echo ${sizelist[i]}|grep -oP '[A-Z]+'`
	echo ${namelist[i]}'******'${p2list[i]}
	epnum=`echo ${namelist[i]}|grep -ioP '(?<=[\[集第【 ])[0-9_\.\(\)]+(?=[\]話话】 ])'| tr '\n' ' '`
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

echo ${namelist[i]}'***'${sizelist[i]}'***'${p2list[i]}

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
	    	echo "$keyw""_""$epnum"" is going to be download!"
	    	echo "" > /tmp/process_"$keyw""_""$epnum"
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

textall=`curl  -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: en-US,en;q=0.8,zh-CN;q=0.6,zh;q=0.4,zh-TW;q=0.2,ja;q=0.2' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.109 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8' -H 'Cache-Control: max-age=0' -H 'Cookie: a9736_times=1; __cfduid=db83c82b946a05cf3b280ab2522b166391515574699; cf_clearance=a10f0ec1a4e016678737296c7bd828aac4c1ef41-1515683740-1800; 8176=1; AJSTAT_ok_pages=2; AJSTAT_ok_times=2; __tins__6000273=%7B%22sid%22%3A%201515683900601%2C%20%22vd%22%3A%202%2C%20%22expires%22%3A%201515685740503%7D; __51cke__=; __51laig__=2; Hm_lvt_dfa59ae97c988b755b7dfc45bbf122ae=1515379378,1515485084,1515574704,1515646521; Hm_lpvt_dfa59ae97c988b755b7dfc45bbf122ae=1515683941' -s --compressed 'https://www.36dm.com/'"${p2list[i]}"|perl -p -e 's/\r//g'`
echo "**********************************************"'http://www.36dm.com/'"${p2list[i]}"
while [[ $textall == *"WebShieldSessionVerify"* ]] || [[ $textall == *"sitedog_stat"* ]]
do
textall=`curl -s --compressed 'http://www.36dm.com/'"${p2list[i]}"|perl -p -e 's/\r//g'`
echo 'web verify hit, rep...., got length: '${#textall}
sleep 1000
done
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
	chmod -R 777 "$downloadfolder/$keyw"
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
	        chmod -R 777 "$downloadfolder/$keyw"
		exit 0
	else
		echo "$keyw""_""$epnum not finished , interrupt when aria2c!!$recode!" | tee -a "/tmp/$keyw.log"
		date | tee -a "/tmp/$keyw.log"
	        chmod -R 777 "$downloadfolder/$keyw"
		exit 1
	fi
else
	echo "$keyw not found in web page!"
	chmod -R 777 "$downloadfolder/$keyw"
fi

date
exit 0
