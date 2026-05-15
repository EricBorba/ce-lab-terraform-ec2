# EC2 Web Instance Module
module "ec2_web" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.4.0"

  for_each = zipmap(var.public_subnets, module.vpc.public_subnets)

  name = "${var.project_name}-registry-web-server-${index(var.public_subnets, each.key)}"

  instance_type          = var.instance_type
  ami                    = data.aws_ami.amazon_linux_2.id
  vpc_security_group_ids = [module.security_group_web.security_group_id]
  subnet_id              = each.value

  key_name                    = var.key_name
  associate_public_ip_address = true

  user_data = file("${path.module}/user-data.sh")

  monitoring = true

  root_block_device = {
    volume_size           = 20
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  tags = {
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

# EC2 App Instance Module
module "ec2_app" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.4.0"

  for_each = zipmap(var.private_subnets, module.vpc.private_subnets)

  name = "${var.project_name}-registry-app-server-${index(var.private_subnets, each.key)}"

  instance_type          = var.instance_type
  ami                    = data.aws_ami.amazon_linux_2.id
  vpc_security_group_ids = [module.security_group_app.security_group_id]
  subnet_id              = each.value

  key_name                    = var.key_name
  associate_public_ip_address = false

  #user_data = file("${path.module}/user-data.sh")

  monitoring = true

  root_block_device = {
    volume_size           = 20
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  tags = {
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}
