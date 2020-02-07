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
                        type = "ssh"
                        user = "ubuntu"
                        private_key = ""
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
                        "echo 'AWS_ACCESS_KEY_ID=AKIAJURIKGJATE7UO55Q' >> ~/.aws/credentials",
                        "echo 'AWS_SECRET_ACCESS_KEY=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' >> ~/.aws/credentials",
                        "mkdir minecraft",
                        "aws s3 sync s3://minecraft/minecraft minecraft/",
                        "sleep 10",
                        "cd minecraft",
                        "screen java -jar spigot-1.15.2.jar &"
                ]
	}
}
