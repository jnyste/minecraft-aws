#!/bin/bash
date=`date +%m-%d-%Y-%H-%M-%S`
echo $date
zip -r $date.zip /home/ubuntu/minecraft
aws s3 cp $date.zip s3://jsb-minecraft/backups/
