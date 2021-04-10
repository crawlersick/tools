sqlite3 $HOME/Downloads/epdb.db < init.sql
sqlite3 $HOME/Downloads/raw_epdb.db < init.sql
initoutput=".separator '||-||' '##-##'"
search_str=$1
if [[ -z "$search_str" ]]
then
    echo "need input search string!!!"
    exit 0
fi

list=/tmp/eps.list
if [[ ! -f $list ]]
then
    ./anlsweb.sh 'http://share.dmhy.org/' 'dmhy.re' > $list
fi
echo '>>>>>>>>>>>>>>>>>>>>>search for :'$search_str
while read -r line
do
	db_file=epdb.db
	
        echo $line | egrep -q 'NC-Raws|Lilith-Raws'
        check1=$?
        if [[ $check1 -eq 0 ]]
	then
		echo "found NC-Raws, mark it to other db"
	        db_file=raw_epdb.db
	
	fi




	mag=`echo $line |perl -ne 'print $3 if /(.*?)\|\|\|\|--\^\^--\|\|\|\|(.*?)\|\|\|\|--\^\^--\|\|\|\|(.*)/s'`
	name=`echo $line |perl -ne 'print $2 if /(.*?)\|\|\|\|--\^\^--\|\|\|\|(.*?)\|\|\|\|--\^\^--\|\|\|\|(.*)/s'`
	group=`echo $line |perl -ne 'print $1 if /(.*?)\|\|\|\|--\^\^--\|\|\|\|(.*?)\|\|\|\|--\^\^--\|\|\|\|(.*)/s'`

	#echo 'mag'
	#echo $mag
	#echo '-0--------------------------------'
	#echo 'name'
	#echo $name
	#echo 'group'
	#echo $group
	epnum=`echo ${name}|grep -ioP '(?<=[^0-9a-zA-Z])[0-9_\.\(\)]+(?=[\]話话】 Vv章])'| tr '\n' ' '`
	epnum=`echo $epnum | xargs`
	if [[ -z "$epnum" ]]
	then
            #echo 'try match epnum as EP'
            epnum=`echo ${name}|grep -ioP '(?<=EP)[0-9_\.\(\)]+(?=[ \[])'| tr '\n' ' '`
	fi
	if [[ -z "$epnum" ]]
	then
            #echo 'try match epnum as AB subfix'
	    epnum=`echo ${name}|grep -ioP '(?<=[^0-9a-zA-Z])[0-9_\.\(\)]+[AB](?=[\]話话】 Vv章])'| tr '\n' ' '`
	fi
    if [[ ! -z "$epnum" ]]
    then
        re_code=1
	IFSBK=$IFS
        IFS=";"
	read -ra ADDR <<< "$search_str"
	for tempkeyw in "${ADDR[@]}"
	do
		echo "$name" | grep -iq "$tempkeyw"
		re_code=$?
                if [[ $re_code -eq 0 ]]
		then
			break
		fi
	done
	IFS=$IFSBK

        #echo "$name" | grep -iq "$search_str"
        #re_code=$?

        if [[ $re_code -eq 0 ]]
        then
            echo 'epnum:'
            echo $epnum
            ifdone=`sqlite3 ~/Downloads/$db_file << EOF
$initoutput
select * from loglist where epname="$search_str" and epnum="$epnum";
EOF`
            if [[ ! -z $ifdone ]]
	    then
                echo "found $search_str  ---   $epnum done in db"
                continue 
	    fi
            echo "found $name  ---   $epnum"
	    if [[ ! -d "$HOME/Downloads/$search_str" ]]
	    then
		    mkdir -p "$HOME/Downloads/$search_str"
		    chmod 777 "$HOME/Downloads/$search_str"
	    fi
            trackers=`cat trackers.txt`
            aria2c -c -d "$HOME/Downloads/$search_str" --log="/tmp/$search_str.log" --log-level=notice --enable-color=false --enable-dht=true --enable-dht6=true --enable-peer-exchange=true --follow-metalink=mem --seed-time=10 --max-overall-upload-limit=50K --bt-tracker=$trackers $mag
            aria_task_status=$?
            echo "$aria_task_status"
	    chmod -R 777 "$HOME/Downloads/$search_str"
            if [[ $aria_task_status -eq 0 ]]
            then

            echo "aria success end with $search_str"
            sqlite3 $HOME/Downloads/$db_file << EOF
insert into loglist values ("$search_str","$epnum");
EOF
            
            else
            
            echo "aria failed end with $search_str"
            fi
            exit 0
        fi
    fi


done < $list
