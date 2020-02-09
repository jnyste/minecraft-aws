## minecraft-aws

This script uses Terraform to spin up Minecraft servers on Amazon EC2 Spot Instances. 

It automatically backs up the world every two hours by default (*TODO: Add more configuration) and does an emergency backup when the Spot Instance receives a shutdown notification.

By default, it uses a m5n.large instance with 8GB of RAM at $0.02 per hour ( ~ around $15/month ).

## Requirements
**Terraform >12.0**

AWS credentials in ~/.aws/credentials

AWS access key ID in ~/.aws/id

AWS secret key in ~/.aws/key

Server SSH key in ~/.ssh/minecraft-ssh.pem # TODO: Add more configuration

## Instructions

Upload your minecraft server files, watchdog.sh and backup.sh to an S3 bucket and point the scripts to your bucket

terraform apply

Get a cup of coffee

Play Minecraft

### TODO:

More secure configuration

Make server restart automatically

Use Amazon Route53 to automatically point domain name to new server

Clean up old backups
