#!/bin/sh 
key=~/.ssh/RemoteSSHKey.pem
ip=54.252.173.65
user=ubuntu
ec2_machine_file=/tmp/machine_list
date=$(date +"%D")
time=$(date +"%T")

for i in `seq 20000 30000 `;
do
   port=$i
   mac=`/sbin/ifconfig | /bin/grep HWaddr | /bin/grep ^w | /usr/bin/awk '{print $5}'`
   #mac=`ifconfig | grep HWaddr | grep ^w | awk '{print $5}'`
   flag=`ssh -i $key $user@$ip "grep $mac $ec2_machine_file"`

   if [ "$flag" ] ; then
      ssh -i $key $user@$ip "sed -i 's|^.*] $mac .*$|[$date $time] $mac ssh smgadmin@localhost -p $port|g' $ec2_machine_file"
   else
      ssh -i $key $user@$ip "echo '[$date $time] $mac ssh smgadmin@localhost -p $port' >> $ec2_machine_file"
   fi

   echo $port $mac 
   ssh -tt -o "ServerAliveInterval 60" -o "ExitOnForwardFailure yes" -R $i:localhost:22 -i $key $user@$ip
   #check any port available on ec2
   if [ $? -ne 255 ]; then
      exit
   fi
done

