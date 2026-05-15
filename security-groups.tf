module "security_group_web" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.1"

  name        = "${var.project_name}-web-server-sg"
  description = "Security group for web server"
  vpc_id      = module.vpc.vpc_id

  # Ingress rules
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "https-443-tcp"]

  # Custom SSH rule
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH from anywhere"
      cidr_blocks = "${var.ssh_cidr}"
    }
  ]

  # Egress
  egress_rules = ["all-all"]

  tags = {
    Environment = "dev"
  }

}

module "security_group_app" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.1"

  name        = "${var.project_name}-app-server-sg"
  description = "Security group for app server"
  vpc_id      = module.vpc.vpc_id

  # Ingress rules — only allow traffic from the web security group
  ingress_with_source_security_group_id = [
    {
      from_port                = 80
      to_port                  = 80
      protocol                 = "tcp"
      description              = "HTTP from web servers"
      source_security_group_id = module.security_group_web.security_group_id
    },
    {
      from_port                = 22
      to_port                  = 22
      protocol                 = "tcp"
      description              = "SSH from web server acting as bastion host"
      source_security_group_id = module.security_group_web.security_group_id
    }
  ]

  # Egress
  egress_rules = ["all-all"]

  tags = {
    Environment = "dev"
  }

}
