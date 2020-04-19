#!/usr/bin/env bash
/home/sick/msda.sh
cd /home/sick/tools/autodown
pwd > /tmp/tttttt
nohup ./auto_down_bat.sh > /home/sick/Downloads/auto.log 2>&1 &
#nohup ./ep_autodown.sh > /tmp/ep.log 2>&1 &
cd /home/sick/NASWEB/src
nohup ./run.sh > /tmp/NASWEB.log 2>&1 &
nohup minio server /home/sick/Downloads/minio_data/ >/tmp/minio.log 2>&1 &
exit 0
