#!/bin/bash
set -x
if [ -z "$1" ] 
then
echo error para
exit 1
fi

targetmanga="$1"
ipb_pass_hash=X
ipb_member_id=X
source ~/exidmsg
echo "ipb_pass_hash="$ipb_pass_hash
echo "ipb_member_id="$ipb_member_id

#get lv1 page content
stringforpage1=`curl $targetmanga -H 'Host: exhentai.org' -H 'User-Agent: Mozilla' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' -H 'Accept-Language: en-US,en;q=0.5' -H 'Accept-Encoding: gzip, deflate' -H 'Referer: http://exhentai.org/' -H "Cookie: nw=1;domain=.exhentai.org; ipb_pass_hash=$ipb_pass_hash;  ipb_member_id=$ipb_member_id" -H 'Connection: keep-alive'|gunzip`


#get manga title like <title>XXX</title>
mangatitle=`echo $stringforpage1 | grep -oP '(?<=<title>).*?(?=</title>)'`
mkdir "temp/""$mangatitle"

#get pages info
for tempval in `echo "$stringforpage1" |  grep -oP 'onclick="return (false)">([0-9]+)</a></td><td'`
do
:
done
pagemax=`echo $tempval | grep -oP '(?<=false"\>)[0-9]+'`
flist="temp/""$mangatitle""/failedlist"

function imagehandle {
entryurl=$1
imgurl=`curl $entryurl -H 'Host: exhentai.org' -H 'User-Agent: Mozilla' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' -H 'Accept-Language: en-US,en;q=0.5' -H 'Accept-Encoding: gzip, deflate' -H 'Referer: $entryurl' -H "Cookie: nw=1;domain=.exhentai.org; ipb_pass_hash=$ipb_pass_hash;  ipb_member_id=$ipb_member_id" -H 'Connection: keep-alive'|gunzip|grep -oP '(?<=<img id="img" src=")[^"]+(?=" (style)=)'`

echo $imgurl | grep -q 'amp;'
status0=$?
if [[ $status0 == "0" ]]
then
imgurl=`echo $imgurl | sed s/'amp;'/''/g`
filename=`echo $imgurl |awk -F'=' '{print $NF}'`
else
filename=`echo $imgurl |awk -F'/' '{print $NF}'`
fi

fullfilepath="temp/""$mangatitle""/""$filename"
if [[ -f "$fullfilepath" ]]
then
:
else
    getfilesize="0"
    i="0"
    while [[ $getfilesize == "0" ]]
    do

        if [[ $i == "3" ]]
        then
        status="999"
        break
        fi

        curl --retry 3 -m 120 -o "$fullfilepath" $imgurl
        status=$?
        getfilesize=`ls -tral "$fullfilepath" |awk '{print $5}'`
        i=`expr $i + 1`

    done
    
fi

if [[ ! $status -eq 0 ]]
then
rm "$fullfilepath"
echo $entryurl >> "$flist"
else 

    if [[ -f "$flist" ]]
    then
        sed -i /'$entryurl'/d "$flist"
    fi
fi
}

for (( c=0; c<$pagemax; c++ ))
do
   pagelink="$targetmanga""?p=$c"
    if [[ c = '0' ]] 
    then
        content=$stringforpage1
    else
        content=`curl $pagelink -H 'Host: exhentai.org' -H 'User-Agent: Mozilla' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' -H 'Accept-Language: en-US,en;q=0.5' -H 'Accept-Encoding: gzip, deflate' -H 'Referer: http://exhentai.org/' -H "Cookie: nw=1;domain=.exhentai.org; ipb_pass_hash=$ipb_pass_hash;  ipb_member_id=$ipb_member_id" -H 'Connection: keep-alive'|gunzip`
    fi
   lv3url=`echo "$content" |  grep -oP '(?<=<a href=")([^"]+)(?="><img alt="[^"]+" title="[^"]+")'`
   
   
   

    for a in $lv3url
    do
    
    if [[ -f "temp/""$mangatitle""/stop" ]]
    then
        kdialog --sorry  "force stop!"
        exit 9
    fi
        
        #echo $a
        #echo $filename
         imagehandle $a &
        THREAD_COUNT=$(ps | grep "curl" | wc -l)
            while [ $THREAD_COUNT -ge 4 ]
            do
            ps -f
                sleep 1
                THREAD_COUNT=$(ps | grep "curl" | wc -l)
            done

    done
done

if [[ -f "$flist" ]]
then
for a in `cat "$flist"`
do
imagehandle $a
done
fi

exit 0
