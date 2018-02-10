dev0name=`iw dev|grep -1 phy#0|grep Interface | awk '{print $2}'`
ipbase=`ifconfig|grep -1 $dev0name|grep inet|awk '{print $2}' |awk -F '.' '{print $1"."$2"."$3".1"}'`
#sudo nmap -sP -n 192.168.1.1/24
sudo nmap -sP -n "$ipbase"/24
