resource "google_sql_database_instance" "default" {
  name = "${var.prefix}-cloudsql-instance"
  project = var.project_id
  region = var.region

  database_version = "POSTGRES_15"
  settings {
    tier = "db-f1-micro"
    availability_type = "REGIONAL"
    backup_configuration {
      enabled = false
      binary_log_enabled = false
    }

    ip_configuration {
      psc_config {
        psc_enabled = true
        allowed_consumer_projects = [var.project_id]
      }
      # private_network = module.vpc-shared-services.network_self_link
      ipv4_enabled = false
    }
  }

}

data "google_sql_database_instance" "default" {
  name = google_sql_database_instance.default.name
}

# module "private_service_connect" {
#   source  = "terraform-google-modules/network/google//modules/private-service-connect"
#   version = "~> 13.0"

#   project_id                 = var.project_id
#   network_self_link          = module.vpc-shared-services.network_self_link
#   private_service_connect_ip = "10.2.0.5"
#   forwarding_rule_target     = google_sql_database_instance.default.psc_service_attachment_link
# }


resource "google_compute_address" "psc_ip_address" {
  name          = "${var.prefix}-psc-ip-address"
  region = var.region
  project       = var.project_id
  address_type  = "INTERNAL"
  # network       = module.vpc-shared-services.network_self_link
  subnetwork = "shared-subnet-1"
  address = "10.150.0.2"
  
}

resource "google_compute_forwarding_rule" "psc_forwarding_rule" {
  name                  = "${var.prefix}-psc-forwarding-rule"
  project               = var.project_id
  network = module.vpc-shared-services.network_self_link
  ip_address = google_compute_address.psc_ip_address.self_link
  region                = var.region
  load_balancing_scheme = ""
  target = data.google_sql_database_instance.default.psc_service_attachment_link
}