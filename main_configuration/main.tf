#Run the main service module, which creates the prerequisites for the main services
module "service" {
  source        = "../aws/service"
  aws_region    = var.aws_region
  aws_keypair   = var.aws_keypair_name
  instance_role = var.instance_role
}

#imports the beanstalk configurations
module "beanstalk" {
  source          = "../aws/beanstalk"
  app_name        = var.app_name
  app_description = var.app_description
  vpc_id          = var.vpc_id
  subnet_ids      = var.subnet_ids
  instance_role   = var.instance_role
}
