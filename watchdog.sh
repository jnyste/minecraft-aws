#!/bin/bash

while true; do
	sleep 5;
	if [ -z "$(curl -s http://169.254.169.254/latest/meta-data/spot/termination-time | grep 404)" ]; 
	then
		sudo systemctl stop minecraft@aws
		zip -r /home/ubuntu/emergency-backup.zip /home/ubuntu/minecraft
		aws s3 cp /home/ubuntu/emergency-backup.zip s3://jsb-minecraft/backups/
	break
	fi
done
