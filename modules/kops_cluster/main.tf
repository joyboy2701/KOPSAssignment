resource "aws_route53_zone" "private" {
  name = "cluster.internal"  # any name you choose
  vpc {
    vpc_id = data.aws_vpc.selected.id
  }
}
resource "kops_cluster" "cluster" {
  name               = var.cluster_name
  kubernetes_version = var.kubernetes_version
  dns_zone=aws_route53_zone.private.id

  admin_ssh_key = file(var.admin_ssh_key_path)

  api {
    access = var.api_access_cidrs

    load_balancer {
      class                     = var.load_balancer_class#"Network"
      type                      = var.load_balancer_type #Public ,Private,Internal
      # cross_zone_load_balancing = var.cross_zone_load_balancing #true
      use_for_internal_api      = var.use_for_internal_api #false
      idle_timeout_seconds      = 0
    }
  }

  cloud_provider {
    aws {}
  }

  config_store {
    base = "${var.state_store}/${var.cluster_name}"
  }


  networking {
    network_id = data.aws_vpc.selected.id

    dynamic "subnet" {
      for_each = var.private_subnets
      content {
        type = "Private"
        id   = subnet.value.id
        name = subnet.value.id
        zone = subnet.value.availability_zone
      }
    }

    dynamic "subnet" {
      for_each = var.public_subnets
      content {
        type = "Public"
        id   = subnet.value.id
        name = subnet.value.id
        zone = subnet.value.availability_zone
      }
    }

    cilium {
      enable_remote_node_identity = var.enable_remote_node_identity
      preallocate_bpf_maps        = false
    }

    topology {
      dns = "Private"
    }
  }

  etcd_cluster {
    name = "main"
    dynamic "member" {
      for_each = toset([for k in keys(var.private_subnets) : k])
      content {
        name           = "control-plane-${member.key}"
        instance_group = "control-plane-${member.key}"
      }
    }
  }

  etcd_cluster {
    name = "events"
    dynamic "member" {
      for_each = toset([for k in keys(var.private_subnets) : k])
      content {
        name           = "control-plane-${member.key}"
        instance_group = "control-plane-${member.key}"
      }
    }
  }

}

resource "kops_instance_group" "control_plane" {
  for_each = var.private_subnets

  cluster_name = kops_cluster.cluster.id
  name         = "control-plane-${each.key}"
  role         = "ControlPlane"
  min_size     = 1
  max_size     = var.master_count
  machine_type = var.master_instance_type
  subnets      = [each.value.id]

}

resource "kops_instance_group" "node" {
  for_each = var.private_subnets

  cluster_name = kops_cluster.cluster.id
  name         = "node-${each.key}"
  role         = "Node"
  min_size     = var.node_count
  max_size     = var.node_count
  machine_type = var.node_instance_type
  subnets      = [each.value.id]
}

resource "null_resource" "wait_for_nlb" {
  provisioner "local-exec" {
    command = "echo 'Waiting 5 minutes for NLB and DNS to stabilize...' && sleep 180"
  }
  depends_on = [ kops_cluster_updater.updater]
}


resource "kops_cluster_updater" "updater" {
  cluster_name = kops_cluster.cluster.id

  keepers = {
    cluster       = kops_cluster.cluster.revision
    control_plane = format("%#v", { for k, v in kops_instance_group.control_plane : k => v.revision })
    node = format("%#v", { for k, v in kops_instance_group.node : k => v.revision })
  }

  rolling_update {
    skip                = var.rolling_update_skip  #false
    fail_on_drain_error = var.fail_on_validate     #true
    fail_on_validate    = var.fail_on_validate     #true
    validate_count      = var.validate_count
  }

  validate {
    skip    = var.validate_skip    #false
    timeout = var.validate_timeout #"30m"

  }
  depends_on = [kops_cluster.cluster,kops_instance_group.node,kops_instance_group.control_plane]
}

resource "null_resource" "export_kubeconfig" {
  triggers = {
    cluster_id = kops_cluster.cluster.id
  }

  provisioner "local-exec" {
    command = <<-EOT
      export KOPS_STATE_STORE="${var.state_store}"
      export KOPS_CLUSTER_NAME="${var.cluster_name}"
      kops export kubecfg --admin
      echo "Kubeconfig exported to ~/.kube/config"
    EOT
  }

  depends_on = [ null_resource.wait_for_nlb ]
}
resource "null_resource" "validate_cluster" {
  depends_on = [null_resource.export_kubeconfig]

  provisioner "local-exec" {
    command = "kops validate cluster --state s3://kops-state-store-bukcet --wait 13m"
  }
}

