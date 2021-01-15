module "base-network" {
  source  = "infrablocks/base-networking/aws"
  version = "2.3.0"

  vpc_cidr           = "10.0.0.0/16"
  region             = "eu-west-3"
  availability_zones = ["eu-west-3a", "eu-west-3b"]

  component             = "test"
  deployment_identifier = "tf-demo"

  include_route53_zone_association = "no"
  #  private_zone_id = "Z3CVA9QD5NHSW3"

  include_nat_gateway = "no"
}

