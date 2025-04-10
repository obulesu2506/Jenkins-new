resource "aws_instance" "jenkins" {

    ami = "ami-09c813fb71547fc4f" # This is our devops-practice AMI ID
    vpc_security_group_ids = [aws_security_group.allow_tls.id]
    instance_type = "t3.micro"

    root_block_device {
      volume_size = 50
      volume_type = "gp3"
    }

    user_data = file("jenkins.sh")

    tags = {
      Name = "Jenkins" 
    }
  
}

resource "aws_security_group" "allow_tls" {

    name = "allow_all"
    description = "This security group allows all inbound and outbound traffic request"

    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "allow_tls_1"
    }
  
}