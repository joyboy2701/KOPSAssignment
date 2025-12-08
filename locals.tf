locals {
  private_subnet_map = {
    for id, s in data.aws_subnet.private_details :
    id => {
      id                = s.id
      availability_zone = s.availability_zone
    }
  }

  public_subnet_map = {
    for id, s in data.aws_subnet.public_details :
    id => {
      id                = s.id
      availability_zone = s.availability_zone
    }
  }
}
