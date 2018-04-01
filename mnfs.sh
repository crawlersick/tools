#sudo mount -o rw,soft,intr -t nfs  192.168.1.107:/Downloads /home/john/nfs/
para=$1
if [[ -z "$para" ]]
then
    echo "mount.."
    sudo mount -o rw -t nfs  192.168.1.111:/Downloads /home/john/nfs/
else
    echo "umount..."
    sudo umount -l 192.168.1.111:/Downloads
fi
