provider "aws" {
        region = "us-east-2"
        shared_credentials_file = "/home/agm/.aws/credentials"
}

resource "aws_key_pair" "minecraft-ssh" {
        key_name = "minecraft-ssh"
        public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCksAobgNAAsDHhjqOJ2tubFSCKTjvuXCBnPWdBLy/2jMV/l/mcQnlo5c2VEdxJughSs3xcKedroNavBVM6C4f77SbVmH/maFYRfOTvC9H/XC1KFnjLtv8yxTof3evT0f7IwNGuq1wy7NrAU6YqJPLRYVlBUlQH0tj+ntku0uZsGkVnh/1zecKX7+Yo4HlVBxiLeOSrpiLN3p9JHkufWeyWyRrY/SsKcERYuA8lKWslAPCUnC4rIbX55crY54uDaBH5/Z9iz2y+nukYM29H4vtnhf5gKYsR5fbeg84n/oqOXH/Yl4R4t9Hlvq1xEfL0oDQckJUM6jqgWh4GNOUMs93n minecraft-ssh"
}

resource "aws_spot_instance_request" "minecraft-server" {
        ami = "ami-0fc20dd1da406780b"
        spot_price = "0.02"
        instance_type = "m5n.large"
        key_name = "minecraft-ssh"
        wait_for_fulfillment = "true"


        provisioner "remote-exec" {

                connection {
			host = self.public_ip
                        type = "ssh"
                        user = "ubuntu"
                        private_key = file("~/.ssh/minecraft-ssh.pem") 
                        agent = "false"
                }

                inline = [
                        "sudo apt-get -y update",
                        "sleep 10",
                        "sudo apt-get install -y awscli",
                        "sleep 10",
                        "sudo apt-get install -y openjdk-11-jre-headless",
                        "sleep 10",
                        "mkdir ~/.aws/",
                        "echo '[default]' >> ~/.aws/credentials",
                        "echo 'AWS_ACCESS_KEY_ID=${file("~/.aws/id")}' >> ~/.aws/credentials",
                        "echo 'AWS_SECRET_ACCESS_KEY=${file("~/.aws/key")}' >> ~/.aws/credentials",
                        "mkdir minecraft",
                        "aws s3 sync s3://jsb-minecraft/server minecraft/",
			"crontab -l | { cat; echo '* */2 * * * /home/ubuntu/minecraft/backup.sh >/dev/null 2>&1'; } | crontab -",
			"/home/ubuntu/minecraft/watchdog.sh &",
			"sudo cp minecraft/minecraft@.service /etc/systemd/system/minecraft@.service",
			"sudo systemctl start minecraft@aws",
                        "sleep 10",
                        "cd minecraft"
                ]
	}
}
