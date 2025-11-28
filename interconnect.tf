module "vpn-ha-1" {
  source     = "terraform-google-modules/vpn/google//modules/vpn_ha"
  version    = "~> 4.0"
  project_id = var.project_id
  region     = var.region

  network          = module.vpc-transit.network_name
  name             = "transit-to-dc"
  peer_gcp_gateway = module.vpn-ha-2.self_link
  router_asn       = 64514
  tunnels = {
    remote-0 = {
      bgp_peer = {
        address = "169.254.1.1"
        asn     = 64513
      }
      bgp_peer_options = {
        advertise_mode = "CUSTOM"
        advertise_ip_ranges = {
          "10.2.0.0/24" = "vpc-shared",
          "10.0.1.0/24" = "vpc-a",
          "10.0.2.0/24" = "vpc-b",
        }
        advertise_groups = ["ALL_SUBNETS"]
        route_priority   = 100

      }

      bgp_session_range               = "169.254.1.2/30"
      ike_version                     = 2
      vpn_gateway_interface           = 0
      peer_external_gateway_interface = null
      shared_secret                   = "foobar"
    }
  }
}

module "vpn-ha-2" {
  source     = "terraform-google-modules/vpn/google//modules/vpn_ha"
  version    = "~> 4.0"
  project_id = var.project_id
  region     = var.region

  network          = module.vpc-transit.network_name
  name             = "transit-to-dc"
  peer_gcp_gateway = module.vpn-ha-1.self_link
  router_asn       = 65002
  tunnels = {
    remote-0 = {
      bgp_peer = {
        address = "169.254.1.1"
        asn     = 65001
      }
      bgp_peer_options = {
        advertise_mode = "CUSTOM"
        advertise_ip_ranges = {
          "10.2.0.0/24" = "vpc-shared",
          "10.0.1.0/24" = "vpc-a",
          "10.0.2.0/24" = "vpc-b",
        }
        advertise_groups = ["ALL_SUBNETS"]
        route_priority   = 100

      }

      bgp_session_range               = "169.254.1.2/30"
      ike_version                     = 2
      vpn_gateway_interface           = 0
      peer_external_gateway_interface = null
      shared_secret                   = "foobar"
    }
  }
}
