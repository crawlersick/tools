url=$1
ref=$2
#target=`callenc.sh $url`
#if [[ $? == '145' ]]
#then
#echo $target
#exit 401
#fi
#contents=`curl -X POST -d "{\"keyl\":\"$target\"}" 'http://176.56.237.58:8000'`

#myeurl='aHR0cHM6Ly9hcGl2MS5uMnIub25saW5lL2RvCg=='
myeurl='aHR0cHM6Ly9hcGl2MS5uNHIubmwvZG8K'
deurl=`echo $myeurl |base64 -d`
deurl="https://vm.n4r.nl/do"
contents=`curl -X POST -d "{\"keyl\":\"$url\"}" "$deurl"`

recode=$?

#realcon=`echo $contents | base64 -d`
realcon=$contents
restr=`sed -n 1p $ref`
echo $realcon | perl -0777 -ne 'print $1."||||--^^--||||".$2."||||--^^--||||".$3."\n" while /'"$restr"'/sg'
exit $recode
