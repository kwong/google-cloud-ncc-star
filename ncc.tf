
resource "google_network_connectivity_hub" "hub" {
  name            = "hub"
  description     = "hub"
  preset_topology = "STAR"

  export_psc = true
}

resource "google_network_connectivity_group" "edge" {
  hub         = google_network_connectivity_hub.hub.id
  name        = "edge"
  description = "edge group"

  auto_accept {
    auto_accept_projects = [
      var.project_id
    ]
  }
}

resource "google_network_connectivity_group" "center" {
  hub         = google_network_connectivity_hub.hub.id
  name        = "center"
  description = "center group"

  auto_accept {
    auto_accept_projects = [
      var.project_id
    ]
  }
}

resource "google_network_connectivity_spoke" "spoke-vpc-a" {
  name        = "spoke-vpc-a"
  location    = "global"
  description = "spoke-vpc-a"

  hub   = google_network_connectivity_hub.hub.id
  group = google_network_connectivity_group.edge.id

  linked_vpc_network {
    uri = module.vpc-a.network_id
  }
}


resource "google_network_connectivity_spoke" "spoke-vpc-b" {
  name        = "spoke-vpc-b"
  location    = "global"
  description = "spoke-vpc-b"

  hub   = google_network_connectivity_hub.hub.id
  group = google_network_connectivity_group.edge.id

  linked_vpc_network {
    uri = module.vpc-b.network_id
  }
}

resource "google_network_connectivity_spoke" "spoke-vpc-transit" {
  name        = "spoke-vpc-transit"
  location    = "global"
  description = "spoke-vpc-transit"

  hub   = google_network_connectivity_hub.hub.id
  group = google_network_connectivity_group.center.id

  linked_vpc_network {
    uri = module.vpc-transit.network_id
  }
}

resource "google_network_connectivity_spoke" "spoke-vpc-sharedservices" {
  name        = "spoke-vpc-sharedservices"
  location    = "global"
  description = "spoke-vpc-sharedservices"

  hub   = google_network_connectivity_hub.hub.id
  group = google_network_connectivity_group.center.id

  linked_vpc_network {
    uri = module.vpc-shared-services.network_id
  }
}
