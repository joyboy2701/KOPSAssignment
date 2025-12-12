terraform {
  required_providers {
    kops = {
      source  = "terraform-kops/kops"
      version = "1.28.7"
    }
  }
}

provider "kops" {
  state_store = var.kops_cluster_config.state_store
}
