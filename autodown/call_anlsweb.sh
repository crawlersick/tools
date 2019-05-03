list=/tmp/eps.list
anlsweb.sh 'http://share.dmhy.org/' 'dmhy.re' > $list
while read -r line
do
	mag=`echo $line |perl -ne 'print $3 if /(.*?)\|\|\|\|--\^\^--\|\|\|\|(.*?)\|\|\|\|--\^\^--\|\|\|\|(.*)/s'`
	name=`echo $line |perl -ne 'print $2 if /(.*?)\|\|\|\|--\^\^--\|\|\|\|(.*?)\|\|\|\|--\^\^--\|\|\|\|(.*)/s'`
	group=`echo $line |perl -ne 'print $1 if /(.*?)\|\|\|\|--\^\^--\|\|\|\|(.*?)\|\|\|\|--\^\^--\|\|\|\|(.*)/s'`

	echo 'mag'
	echo $mag
	echo 'name'
	echo $name
	echo 'group'
	echo $group

	exit

done < $list
