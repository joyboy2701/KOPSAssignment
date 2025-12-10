module "kops_cluster" {
  source = "./modules/kops_cluster"

  cluster_name                = var.kops_cluster_config.cluster_name
  kubernetes_version          = var.kops_cluster_config.kubernetes_version
  state_store                 = var.kops_cluster_config.state_store
  vpc_name                    = var.kops_cluster_config.vpc_name
  private_subnets             = local.private_subnet_map
  public_subnets              = local.public_subnet_map
  api_access_cidrs            = var.kops_cluster_config.api_access_cidrs
  master_instance_type        = var.kops_cluster_config.master_instance_type
  node_instance_type          = var.kops_cluster_config.node_instance_type
  master_count                = var.kops_cluster_config.master_count
  node_count                  = var.kops_cluster_config.node_count
  admin_ssh_key_path          = var.kops_cluster_config.admin_ssh_key_path

  load_balancer_type          = var.kops_cluster_config.load_balancer_type
  use_for_internal_api        = var.kops_cluster_config.use_for_internal_api
  # cross_zone_load_balancing   = var.kops_cluster_config.cross_zone_load_balancing
  enable_remote_node_identity = var.kops_cluster_config.enable_remote_node_identity
  rolling_update_skip         = var.kops_cluster_config.rolling_update_skip
  fail_on_drain_error         = var.kops_cluster_config.fail_on_drain_error
  fail_on_validate            = var.kops_cluster_config.fail_on_validate
  validate_count              = var.kops_cluster_config.validate_count
  validate_skip               = var.kops_cluster_config.validate_skip
  validate_timeout            = var.kops_cluster_config.validate_timeout
  load_balancer_class         = var.kops_cluster_config.load_balancer_class
}
