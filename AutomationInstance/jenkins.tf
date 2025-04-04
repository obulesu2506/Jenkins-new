resource "aws_instance" "jenkins" {
    count = length(var.instances)
    ami = "ami-09c813fb71547fc4f" # This is our devops-practice AMI ID
    vpc_security_group_ids = [aws_security_group.allow_all_jenkins.id]
    instance_type = "t3.micro"

    #extending root volume since 20 GB is not sufficient
    root_block_device {
      volume_size = 50 #set root volume to 50 GB
      volume_type = "gp3" #use gp3 for better performance (OPTIONAL)
    }
    user_data = file("jenkins.sh") #Execute during launching instance stage

    tags = {
      Name = var.instances[count.index]
    }
  
}
resource "aws_security_group" "allow_all_jenkins" {
    name = "allow_all_jenkins"
    description = "This security group allows all Input/Output SSH traffic"

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