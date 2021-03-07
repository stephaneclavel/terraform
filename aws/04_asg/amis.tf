resource "aws_ami_copy" "amazon-linux-2-encrypted-ami" {
  name              = "amazon-linux-2-encrypted-ami"
  description       = "An encrypted root ami based off ${data.aws_ami.amazon-linux-2.id}"
  source_ami_id     = data.aws_ami.amazon-linux-2.id
  source_ami_region = "eu-west-3"
  encrypted         = "true"

  tags = {
    Name = "amazon-linux-2-encrypted-ami"
  }
}

data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_ami_from_instance" "encrypted-web-server" {
  name               = "encrypted-web-server"
  source_instance_id = module.ec2_public.id[0]
}
