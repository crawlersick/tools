url=$1
ref=$2
target=`callenc.sh $url`
if [[ $? == '145' ]]
then
echo $target
exit 401
fi
contents=`curl -X POST -d "{\"keyl\":\"$target\"}" 'http://176.56.237.58:8000'`
realcon=`echo $contents | base64 -d`
restr=`sed -n 1p $ref`
echo $realcon | perl -0777 -ne 'print $1."||||--^^--||||".$2."||||--^^--||||".$3."\n" while /'"$restr"'/sg'

