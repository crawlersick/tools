rd=$RANDOM
logfile1='/tmp/once_'$rd'_'`date +"%Y%m%d%H%M%S"`'.log'
logfile2='/tmp/once2_'$rd'_'`date +"%Y%m%d%H%M%S"`'.log'
mkdir -p "$HOME/Downloads/specify_bg_down" 
nohup aria2c -c -d "$HOME/Downloads/specify_bg_down" --log=$logfile1 --log-level=notice --enable-color=false --enable-dht=true --enable-dht6=true --enable-peer-exchange=true --follow-metalink=mem --seed-time=10 --max-overall-upload-limit=50K "$1" > $logfile2 2>&1 &
echo "will sleep 60 secs for chmod func"
sleep 60
a=`ls -tr /home/sick/Downloads/specify_bg_down/ | tail -1`
chmod -R 777 "$HOME/Downloads/specify_bg_down/""$a"
exit 0
