data "aws_ami" "joindevops" {

    most_recent = true
    owners = [973714476881]

    filter {
      name = "name"
      values = ["RHEL-9-Devops-Practice"]
    }

    filter {
      name = "virtualization-type"
      values = ["hvm"]
    }

    filter {
      name = "root-device-type"
      values = ["ebs"]
    }
}