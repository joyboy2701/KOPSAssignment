module "kops_cluster" {
  source = "./modules/kops_cluster"
providers = {
  kops=kops
}

  cluster_name         = var.kops_cluster_config.cluster_name
  kubernetes_version   = var.kops_cluster_config.kubernetes_version
  state_store          = var.kops_cluster_config.state_store
  vpc_name             = var.kops_cluster_config.vpc_name
  vpc_id               = data.aws_vpc.selected.id
  private_subnets      = local.private_subnet_map
  public_subnets       = local.public_subnet_map
  api_access_cidrs     = var.kops_cluster_config.api_access_cidrs
  master_instance_type = var.kops_cluster_config.master_instance_type
  node_instance_type   = var.kops_cluster_config.node_instance_type
  master_count         = var.kops_cluster_config.master_count
  node_count           = var.kops_cluster_config.node_count
  admin_ssh_key_path   = var.kops_cluster_config.admin_ssh_key_path

  load_balancer_type          = var.kops_cluster_config.load_balancer_type
  use_for_internal_api        = var.kops_cluster_config.use_for_internal_api
  enable_remote_node_identity = var.kops_cluster_config.enable_remote_node_identity
  load_balancer_class         = var.kops_cluster_config.load_balancer_class
}
