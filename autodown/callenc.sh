if [[ ! -f "$HOME/.config/fakeweb" ]]
then
        echo 'need to set password same as remote server in $HOME/.config/fakeweb..exit now'
	exit 401
fi

pass=`head -1 $HOME/.config/fakeweb`
echo -n $pass |zip -q -e --stdin |echo -n "$1" | base64
