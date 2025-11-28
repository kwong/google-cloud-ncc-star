module "vpc-a" {
  source     = "terraform-google-modules/network/google"
  project_id = var.project_id

  network_name = "${var.prefix}-vpc-a"

  subnets = [
    {
      subnet_name           = "vpca-subnet-1"
      subnet_ip             = "10.0.0.0/24"
      subnet_region         = var.region
      subnet_private_access = "true"
    }
  ]
}

module "vpc-b" {
  source     = "terraform-google-modules/network/google"
  project_id = var.project_id

  network_name = "${var.prefix}-vpc-b"

  subnets = [
    {
      subnet_name           = "vpcb-subnet-1"
      subnet_ip             = "10.0.1.0/24"
      subnet_region         = var.region
      subnet_private_access = "true"
    }
  ]
}

module "vpc-datacenter" {
  source = "terraform-google-modules/network/google"

  project_id   = var.project_id
  network_name = "${var.prefix}-vpc-dc"

  subnets = [
    {
      subnet_name           = "dc-subnet-1"
      subnet_ip             = "10.2.0.0/24"
      subnet_region         = var.region
      subnet_private_access = "true"
    }
  ]
}

module "vpc-transit" {
  source     = "terraform-google-modules/network/google"
  project_id = var.project_id

  network_name = "${var.prefix}-vpc-transit"

  subnets = []
}

module "vpc-shared-services" {
  source     = "terraform-google-modules/network/google"
  project_id = var.project_id

  network_name = "${var.prefix}-shared-services"

  subnets = [
    {
      subnet_name           = "shared-subnet-1"
      subnet_ip             = "10.2.0.0/24"
      subnet_region         = var.region
      subnet_private_access = "true"
    }
  ]
}





