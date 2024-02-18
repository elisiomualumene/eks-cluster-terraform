module "vpc" {
  source = "./modules/vpc"
  prefix = var.prefix
}

module "eks" {
  source = "./modules/eks"
  vpc_id = module.vpc.vpc_id
  prefix = var.prefix
  cluster_name = var.cluster_name
  desired_size = var.desired_size
  max_size = var.max_size
  min_size = var.min_size
  retention_days = var.retention_days
  subnet_ids = module.vpc.subent_ids
}