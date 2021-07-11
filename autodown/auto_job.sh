sudo mount /dev/sda1 /home/sick/Downloads
cd /home/sick/NASWEB/src
./runuwsgi.sh
cd /home/sick/tools/autodown
nohup ./auto_down_bat.sh > /home/sick/Downloads/auto.log 2>&1 &
exit 0
