!/bin/sh 

#/home/smgadmin/aws/tunnel.sh &
process=`ps ax | grep ExitOnForwardFailure | grep localhost | grep -v " T "`
date=$(date +"%D")
time=$(date +"%T")
if [ ! "$process" ]; then
   echo "[$date $time] No tunnel ssh found, Building tunnel"
   /home/smgadmin/aws/tunnel.sh &
else
   echo "[$date $time] Tunnel is health."
fi
