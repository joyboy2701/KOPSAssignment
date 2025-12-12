aws_region = "us-east-1"
profile    = "default"
# ------------------------------
# VPC Configuration
# ------------------------------
vpc = {
  vpc_cidr_block             = "10.0.0.0/16"
  vpc_name                   = "my-vpc"
  internet_gateway           = "my-igw"
  public_subnet_cidr         = ["10.0.8.0/24"]
  private_subnet_cidr        = ["10.0.4.0/24"]
  public_availability_zones  = ["us-east-1a"]
  private_availability_zones = ["us-east-1a"]

  public_subnet_name         = ["public-subnet-1"]
  private_subnet_name        = ["k8s-private-subnet-1"]
  route_destination          = "0.0.0.0/0"
  nat_gateway                = "k8s-nat"
  route_table_public         = "k8s-public-rt"
  route_table_private        = "k8s-private-rt"
  cidr_block                 = "0.0.0.0/0"
  eip_name                   = "nat-eip"
}

# ------------------------------
# Bastion Configuration
# ------------------------------
bastion = {
  ami_id                 = "ami-0c02fb55956c7d316"
  instance_type          = "t2.micro"
  user_data_file         = "./user_data.sh"
  bastion_sg_name        = "bastion-sg"
  bastion_sg_egress_cidr = ["0.0.0.0/0"]
  bastion_name           = "bastion-host"
  bastion_role           = "bastion"
  bastion_cluster        = "k8s-cluster"
  key_name               = "test-ec2"
}
