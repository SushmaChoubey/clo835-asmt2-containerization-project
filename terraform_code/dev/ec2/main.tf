data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}


resource "aws_instance" "k8s" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t3.medium"

  root_block_device {
    volume_size = 16
  }

  user_data = file("${path.module}/install_httpd.sh")
   

  vpc_security_group_ids = [
    module.ec2_sg.security_group_id,
    module.dev_ssh_sg.security_group_id
  ]
  iam_instance_profile = "LabInstanceProfile"

  tags = {
    project = "clo835"
  }

  key_name                = "schoubeykey"
  monitoring              = true
  disable_api_termination = false
  ebs_optimized           = true
}

resource "aws_key_pair" "k8s" {
  key_name   = "schoubeykey"
  public_key = file("~/.ssh/schoubeykey.pub")
}