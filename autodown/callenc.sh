pass=`head -1 $HOME/.config/fakeweb`
echo -n $pass |zip -q -e --stdin |echo -n "$1" | base64
