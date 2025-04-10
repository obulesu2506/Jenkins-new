module "jenkins" {
    source = "terraform-aws-modules/ec2-instance/aws"

    name = "jenkins"
    ami = data.aws_ami.ami_info.id
    vpc_security_group_ids = ["sg-04b43b659458be54a"]
    subnet_id = "subnet-0db6b50985ae47a90"
    instance_type = "t3.small"

    user_data = file("jenkins.sh")

    tags = {
        Name = "jenkins"
    }

    #Define the root volume size and type
    root_block_device = [
        {
            volume_size = 50 #extending root volume size from 20 to 50 GB
            volume_type = "gp3" #general purpose ssd
            delete_on_termination = true #Automatically delete the volume when instance is terminated
    }
    ]
}

module "jenkins-agent" {

    source = "terraform-aws-modules/ec2-instance/aws"

    name = "jenkins-agent"

    ami = data.aws_ami.ami_info.id
    vpc_security_group_ids = ["sg-04b43b659458be54a"]
    subnet_id = "subnet-0db6b50985ae47a90"
    instance_type = "t3.small"

    user_data = file("jenkins-agent.sh")
    tags = {
        Name = "jenkins-agent"
    }

    root_block_device = [
        {
            volume_size = 50 #extending root volume size from 20 to 50 GB
            volume_type = "gp3" #General Purpose SSD 
            delete_on_termination = true # Automatically delete the root volume when the instance is terminated
        }
    ]

}

module "records" {
    source = "terraform-aws-modules/route53/aws//modules/records"
    version = "~>2.0"

    zone_name = var.zone_name

    records = [
        {
            name = "jenkins"
            type = "A"
            ttl = 1
            records = [
                module.jenkins.public_ip
            ]
            allow_overwrite = true
        },
        {
            name = "jenkins-agent"
            type = "A"
            ttl = 1
            records = [
                module.jenkins-agent.private_ip
            ]
            allow_overwrite = true
        }
    ]
}