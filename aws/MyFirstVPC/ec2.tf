module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"

  key_name   = "id_rsa"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC2SobtaenAnb2rf1Q0yfIIJHIhO3nJDyhEfFz4gBirgEVoEdFMqyucvY9Uo9cIzbKLVP2UQfS+NTPgd6M1sMJ3aTKVPdHqMnZl0tFO5I2Okgbi7Ju+0N6f0zMv94Rmz1NlOJN+xYVvh9+KmdTtKBbBzxnf3BKsM+ARV+pmmI2/0Xz7BHVL+K7ecxh9rafDNdxRWb9QJkTK8A6a1/t54niaptu+1sKr8SvZ2mp3nH93551aAuDs1aNO68FgWG0Lr5S0C4f2bmfCELJG7Ugdl6c78v8Xe5t+KSuw+hlsYD/Is9V3U/znBPLn2sjG7QPskZvXRZ9n6nDut7ZPM5iLHqAR0ju35hFkV3ZIAq5Htfj4iGqh9bs6qfzuee5Yn20kJ04rnSRluaLrXWmMELzDjwI9TPDilYDvbXIuIud7zLAn+dYjkHqpp0DaSbZsiawXwu1hm96/KAy3iJzQISkOpTlgKGEO9d+ocYjaR/Utxj8FMMp/emwYiHsk6hO7GcIV2mALjxRgq1juaI/iEnQOmfIVwdCjU4laZ3Rw6ZVxCW0/8i7yXiJr33th/Cq1lEMCmeCgVSi5Wd3H8TmkdwvZBShKdJWfSIL8/lH6wQLOrUatJA1kVfKu1Jw+NetJ7gj14OYCeQpwVtHduwAZyvZd7B1/725hBv2ZY5Q9EUieqrE7xQ== github@decidela.net"

}

module "ec2_public" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 2.0"

  name           = "ec2_public"
  instance_count = 1

  ami                         = "ami-00798d7180f25aac2"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = "mynewkeypair"
  monitoring                  = true
  #  vpc_security_group_ids = ["sg-12345678"]
  #  subnet_id              = "subnet-eddcdzz4"
  subnet_id = module.base-network.public_subnet_ids[0]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }

  #  depends_on = [module.base-network]
}

