variable "kops_cluster_config" {
  description = "Configuration object for the kOps cluster"
  type = object({
    cluster_name         = string
    kubernetes_version   = string
    state_store          = string
    vpc_name             = string
    api_access_cidrs     = list(string)
    master_instance_type = string
    node_instance_type   = string
    master_count         = number
    node_count           = number
    bucket_prefix        = string
    admin_ssh_key_path   = string
    # vpc_id=string

    load_balancer_type   = string
    use_for_internal_api = bool
    # cross_zone_load_balancing   = bool
    enable_remote_node_identity = bool

    load_balancer_class = string
  })
}
