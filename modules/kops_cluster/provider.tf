terraform {
  required_providers {
    kops = {
      source  = "terraform-kops/kops"
      version = "1.27.1"
    }
  }
}

provider "kops" {
  state_store = var.state_store
}
