variable "cluster_name" {}

variable "kubernetes_version" {}

variable "state_store" {}

variable "vpc_name" {
  description = "The Name tag of the VPC to look up"
  type        = string
  default     = "my-application-vpc" # Replace with your actual VPC Name
}

variable "private_subnets" {
  type = map(object({
    id                = string
    availability_zone = string
  }))
}

variable "public_subnets" {
  type = map(object({
    id                = string
    availability_zone = string
  }))
}


variable "api_access_cidrs" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "master_instance_type" {}
variable "node_instance_type" {}

variable "master_count" {
  type    = number
  default = 3
}

variable "node_count" {
  type    = number
  default = 2
}
variable "admin_ssh_key_path" {
  description = "Path to the admin public SSH key to use for the cluster"
  type        = string
}
variable "vpc_id" {
  type = string
}


variable "load_balancer_type" {
  type = string
}
variable "use_for_internal_api" {
  type = bool
}
# variable "cross_zone_load_balancing"{
#   type = bool
# }
variable "enable_remote_node_identity" {
  type = bool
}

variable "load_balancer_class" {
  type = string
}