search_str=$1
if [[ -z "$search_str" ]]
then
    echo "need input search string!!!"
    exit 0
fi
list=/tmp/eps.list
anlsweb.sh 'http://share.dmhy.org/' 'dmhy.re' > $list
while read -r line
do
	mag=`echo $line |perl -ne 'print $3 if /(.*?)\|\|\|\|--\^\^--\|\|\|\|(.*?)\|\|\|\|--\^\^--\|\|\|\|(.*)/s'`
	name=`echo $line |perl -ne 'print $2 if /(.*?)\|\|\|\|--\^\^--\|\|\|\|(.*?)\|\|\|\|--\^\^--\|\|\|\|(.*)/s'`
	group=`echo $line |perl -ne 'print $1 if /(.*?)\|\|\|\|--\^\^--\|\|\|\|(.*?)\|\|\|\|--\^\^--\|\|\|\|(.*)/s'`

	#echo 'mag'
	#echo $mag
	echo '-0--------------------------------'
	echo 'name'
	echo $name
	echo 'group'
	echo $group
	epnum=`echo ${name}|grep -ioP '(?<=[^0-9a-zA-Z])[0-9_\.\(\)]+(?=[\]話话】 Vv章])'| tr '\n' ' '`
	if [[ -z "$epnum" ]]
	then
            echo 'try match epnum as EP'
            epnum=`echo ${name}|grep -ioP '(?<=EP)[0-9_\.\(\)]+(?=[ \[])'| tr '\n' ' '`
	fi
    echo 'epnum:'
    echo $epnum
    if [[ ! -z "$epnum" ]]
    then
        echo "$name" | grep -iq "$search_str"
        re_code=$?
        if [[ $re_code -eq 0 ]]
        then
            echo "found $name  ---   $epnum"
	    if [[ ! -d "$HOME/Downloads/$search_str" ]]
	    then
		    mkdir -p "$HOME/Downloads/$search_str"
		    chmod 777 "$HOME/Downloads/$search_str"
	    fi
            trackers=`cat trackers.txt`
            aria2c -c -d "$HOME/Downloads/$search_str" --log="/tmp/$search_str.log" --log-level=notice --enable-color=false --enable-dht=true --enable-dht6=true --enable-peer-exchange=true --follow-metalink=mem --seed-time=10 --max-overall-upload-limit=50K --bt-tracker=$trackers $mag
	    chmod -R 777 "$HOME/Downloads/$search_str/*"
            exit 0
        fi
    fi


done < $list
