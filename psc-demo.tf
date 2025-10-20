// Creates compute instance templates for respective VPCs
// compute instances from template
// cloud sql instances
// PSC (address + forwarding rule)

## TODO - done ##
// Add apt-get install telnet to cloud-config-nginx.yaml
// Add apt-get install dnsutils to cloud-config-nginx.yaml

## Instructions on how to connect ## 

// Memcached 
// https://cloud.google.com/memorystore/docs/memcached/connect-memcached-instance
// us-central1 memcached
// telnet 10.200.1.131 11211
// europe-west3 memcached
// telnet 10.200.1.3 11211

// CloudSQL
// PSC in cx-vpc-infra-am
// mysql --host=10.100.21.10 --user=testsql --password=sql1234
// PSC in cx-vpc-transit-am
// mysql --host=172.16.1.10 --user=testsql --password=sql1234
// PSC in cx-vpc-infra-eu
// mysql --host=10.100.3.10 --user=testsql --password=sql1234
// user and password are in 'google_sql_user' resource

################################################ cx-vpc-infra-am ################################################

// Instance Template
resource "google_compute_region_instance_template" "cx-vpc-infra-am-instance-template" {
  machine_type = "e2-micro"
  metadata = {
    enable-oslogin = "true"
  }
  metadata_startup_script = file("${path.module}/cloud-config-nginx.yaml")
  name                    = "cx-vpc-infra-am-instance-template"
  project                 = local.project_id
  region                  = local.primary_region
  resource_manager_tags = {
    "tagKeys/281480126525795" = "tagValues/281477869187443"
  }
  disk {
    auto_delete  = true
    boot         = true
    device_name  = "disk01"
    disk_size_gb = 10
    disk_type    = "pd-balanced"
    mode         = "READ_WRITE"
    source_image = "projects/debian-cloud/global/images/debian-12-bookworm-v20250610"
    type         = "PERSISTENT"
  }
  network_interface {
    network            = "https://www.googleapis.com/compute/v1/projects/${local.project_id}/global/networks/cx-vpc-infra-am"
    network_ip         = null
    stack_type         = "IPV4_ONLY"
    subnetwork         = "https://www.googleapis.com/compute/v1/projects/${local.project_id}/regions/us-central1/subnetworks/cx-vpc-infra-am-sn2-usc1"
    subnetwork_project = local.project_id
  }
  service_account {
    email  = local.service_account_email
    scopes = local.service_account_scopes
  }
  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = true
    enable_vtpm                 = true
  }
}

// VM from Instance Template
resource "google_compute_instance_from_template" "vm-cx-vpc-infra-am" {
  depends_on = [google_compute_router_nat.nat-cr-cx-vpc-infra-am-usc1]
  name       = "vm-cx-vpc-infra-am"
  project    = local.project_id
  zone       = local.primary_region_zonea
  # desired_status = "TERMINATED"

  source_instance_template = google_compute_region_instance_template.cx-vpc-infra-am-instance-template.self_link
}

################################################ cx-vpc-infra-eu ################################################

// Instance Template
resource "google_compute_region_instance_template" "cx-vpc-infra-eu-instance-template" {
  machine_type = "e2-micro"
  metadata = {
    enable-oslogin = "true"
  }
  metadata_startup_script = file("${path.module}/cloud-config-nginx.yaml")
  name                    = "cx-vpc-infra-eu-instance-template"
  project                 = local.project_id
  region                  = local.primary_region_eu
  resource_manager_tags = {
    "tagKeys/281480126525795" = "tagValues/281477869187443"
  }
  disk {
    auto_delete  = true
    boot         = true
    device_name  = "disk01"
    disk_size_gb = 10
    disk_type    = "pd-balanced"
    mode         = "READ_WRITE"
    source_image = "projects/debian-cloud/global/images/debian-12-bookworm-v20250610"
    type         = "PERSISTENT"
  }
  network_interface {
    network            = "https://www.googleapis.com/compute/v1/projects/${local.project_id}/global/networks/cx-vpc-infra-eu"
    network_ip         = null
    stack_type         = "IPV4_ONLY"
    subnetwork         = "https://www.googleapis.com/compute/v1/projects/${local.project_id}/regions/${local.primary_region_eu}/subnetworks/cx-vpc-infra-eu-sn-euw3"
    subnetwork_project = local.project_id
  }
  service_account {
    email  = local.service_account_email
    scopes = local.service_account_scopes
  }
  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = true
    enable_vtpm                 = true
  }
}

// VM from Instance Template
resource "google_compute_instance_from_template" "vm-cx-vpc-infra-eu" {
  depends_on = [google_compute_router_nat.nat-cr-cx-vpc-infra-eu-euw3]
  name       = "vm-cx-vpc-infra-eu"
  project    = local.project_id
  zone       = local.primary_region_eu_zonea
  # desired_status = "TERMINATED"

  source_instance_template = google_compute_region_instance_template.cx-vpc-infra-eu-instance-template.self_link
}

################################################ cx-vpc-transit-am ################################################

// Instance Template
resource "google_compute_region_instance_template" "cx-vpc-transit-am-instance-template" {
  machine_type = "e2-micro"
  metadata = {
    enable-oslogin = "true"
  }
  metadata_startup_script = file("${path.module}/cloud-config-nginx.yaml")
  name                    = "cx-vpc-transit-am-instance-template"
  project                 = local.project_id
  region                  = local.primary_region
  resource_manager_tags = {
    "tagKeys/281480126525795" = "tagValues/281477869187443"
  }
  disk {
    auto_delete  = true
    boot         = true
    device_name  = "disk01"
    disk_size_gb = 10
    disk_type    = "pd-balanced"
    mode         = "READ_WRITE"
    source_image = "projects/debian-cloud/global/images/debian-12-bookworm-v20250610"
    type         = "PERSISTENT"
  }
  network_interface {
    network            = "https://www.googleapis.com/compute/v1/projects/${local.project_id}/global/networks/cx-vpc-transit-am"
    network_ip         = null
    stack_type         = "IPV4_ONLY"
    subnetwork         = "https://www.googleapis.com/compute/v1/projects/${local.project_id}/regions/us-central1/subnetworks/cx-vpc-transit-am-sn-usc1"
    subnetwork_project = local.project_id
  }
  service_account {
    email  = local.service_account_email
    scopes = local.service_account_scopes
  }
  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = true
    enable_vtpm                 = true
  }
}

// VM from Instance Template
resource "google_compute_instance_from_template" "vm-cx-vpc-transit-am" {
  depends_on = [google_compute_router_nat.nat-cr-cx-vpc-transit-am-usc1]
  name       = "vm-cx-vpc-transit-am"
  project    = local.project_id
  zone       = local.primary_region_zonea
  # desired_status = "TERMINATED"

  source_instance_template = google_compute_region_instance_template.cx-vpc-transit-am-instance-template.self_link
}

// Instance Template
resource "google_compute_region_instance_template" "cx-vpc-transit-am-instance-template2" {
  depends_on   = [module.cx-vpc-transit-am]
  machine_type = "e2-micro"
  metadata = {
    enable-oslogin = "true"
  }
  metadata_startup_script = file("${path.module}/cloud-config-nginx.yaml")
  name                    = "cx-vpc-transit-am-instance-template2"
  project                 = local.project_id
  region                  = local.primary_region
  resource_manager_tags = {
    "tagKeys/281480126525795" = "tagValues/281477869187443"
  }
  disk {
    auto_delete  = true
    boot         = true
    device_name  = "disk01"
    disk_size_gb = 10
    disk_type    = "pd-balanced"
    mode         = "READ_WRITE"
    source_image = "projects/debian-cloud/global/images/debian-12-bookworm-v20250610"
    type         = "PERSISTENT"
  }
  network_interface {
    network            = "https://www.googleapis.com/compute/v1/projects/${local.project_id}/global/networks/cx-vpc-transit-am"
    network_ip         = null
    stack_type         = "IPV4_ONLY"
    subnetwork         = "https://www.googleapis.com/compute/v1/projects/${local.project_id}/regions/us-central1/subnetworks/cx-vpc-transit-am-sn2-usc1"
    subnetwork_project = local.project_id
  }
  service_account {
    email  = local.service_account_email
    scopes = local.service_account_scopes
  }
  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = true
    enable_vtpm                 = true
  }
}

// VM from Instance Template
resource "google_compute_instance_from_template" "vm-cx-vpc-transit-am2" {
  depends_on = [google_compute_router_nat.nat-cr-cx-vpc-transit-am-usc1]
  name       = "vm-cx-vpc-transit-am2"
  project    = local.project_id
  zone       = local.primary_region_zonea
  # desired_status = "TERMINATED"

  source_instance_template = google_compute_region_instance_template.cx-vpc-transit-am-instance-template2.self_link
}

################################################ cx-vpc-onprem-dc1 ################################################

// Instance Template
resource "google_compute_region_instance_template" "cx-vpc-onprem-dc1-instance-template" {
  machine_type = "e2-micro"
  metadata = {
    enable-oslogin = "true"
  }
  metadata_startup_script = file("${path.module}/cloud-config-nginx.yaml")
  name                    = "cx-vpc-onprem-dc1-instance-template"
  project                 = local.project_id
  region                  = local.primary_region
  resource_manager_tags = {
    "tagKeys/281480126525795" = "tagValues/281477869187443"
  }
  disk {
    auto_delete  = true
    boot         = true
    device_name  = "disk01"
    disk_size_gb = 10
    disk_type    = "pd-balanced"
    mode         = "READ_WRITE"
    source_image = "projects/debian-cloud/global/images/debian-12-bookworm-v20250610"
    type         = "PERSISTENT"
  }
  network_interface {
    network            = "https://www.googleapis.com/compute/v1/projects/${local.project_id}/global/networks/cx-vpc-onprem-dc1"
    network_ip         = null
    stack_type         = "IPV4_ONLY"
    subnetwork         = "https://www.googleapis.com/compute/v1/projects/${local.project_id}/regions/us-central1/subnetworks/cx-vpc-onprem-dc1-sn"
    subnetwork_project = local.project_id
  }
  service_account {
    email  = local.service_account_email
    scopes = local.service_account_scopes
  }
  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = true
    enable_vtpm                 = true
  }
}

// VM from Instance Template
resource "google_compute_instance_from_template" "vm-cx-vpc-onprem-dc1" {
  depends_on = [google_compute_router_nat.nat-cr-cx-vpc-onprem-dc1-usc1]
  name       = "vm-cx-vpc-onprem-dc1"
  project    = local.project_id
  zone       = local.primary_region_zonea
  # desired_status = "TERMINATED"

  source_instance_template = google_compute_region_instance_template.cx-vpc-onprem-dc1-instance-template.self_link
}

################################################ cx-vpc-onprem-dc3 ################################################

// Instance Template
resource "google_compute_region_instance_template" "cx-vpc-onprem-dc3-instance-template" {
  machine_type = "e2-micro"
  metadata = {
    enable-oslogin = "true"
  }
  metadata_startup_script = file("${path.module}/cloud-config-nginx.yaml")
  name                    = "cx-vpc-onprem-dc3-instance-template"
  project                 = local.project_id
  region                  = local.primary_region_eu
  resource_manager_tags = {
    "tagKeys/281480126525795" = "tagValues/281477869187443"
  }
  disk {
    auto_delete  = true
    boot         = true
    device_name  = "disk01"
    disk_size_gb = 10
    disk_type    = "pd-balanced"
    mode         = "READ_WRITE"
    source_image = "projects/debian-cloud/global/images/debian-12-bookworm-v20250610"
    type         = "PERSISTENT"
  }
  network_interface {
    network            = "https://www.googleapis.com/compute/v1/projects/${local.project_id}/global/networks/cx-vpc-onprem-dc3"
    network_ip         = null
    stack_type         = "IPV4_ONLY"
    subnetwork         = "https://www.googleapis.com/compute/v1/projects/${local.project_id}/regions/${local.primary_region_eu}/subnetworks/cx-vpc-onprem-dc3-sn"
    subnetwork_project = local.project_id
  }
  service_account {
    email  = local.service_account_email
    scopes = local.service_account_scopes
  }
  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = true
    enable_vtpm                 = true
  }
}

// VM from Instance Template
resource "google_compute_instance_from_template" "vm-cx-vpc-onprem-dc3" {
  depends_on = [google_compute_router_nat.nat-cr-cx-vpc-onprem-dc3-euw3]
  name       = "vm-cx-vpc-onprem-dc3"
  project    = local.project_id
  zone       = local.primary_region_eu_zonea
  # desired_status = "TERMINATED"

  source_instance_template = google_compute_region_instance_template.cx-vpc-onprem-dc3-instance-template.self_link
}

######################################################### Cloud SQL Setup ########################################################## 

// CloudSQL
resource "google_sql_database_instance" "csqlpsctestusc1" {
  name             = "csqlpsctestusc1"
  database_version = "MYSQL_8_0"
  project          = local.project_id
  region           = local.primary_region
  settings {
    tier = "db-f1-micro"
    ip_configuration {
      psc_config {
        psc_enabled               = true
        allowed_consumer_projects = [local.project_id]
      }
      ipv4_enabled = false
    }
    backup_configuration {
      enabled            = true
      binary_log_enabled = true
    }
    availability_type           = "REGIONAL"
    deletion_protection_enabled = false
  }
}

// SQL User
resource "google_sql_user" "usersusc1" {
  project  = local.project_id
  name     = "testsql"
  instance = google_sql_database_instance.csqlpsctestusc1.name
  password = "sql1234"
}

// CloudSQL
resource "google_sql_database_instance" "csqlpsctesteuw3" {
  name             = "csqlpsctesteuw3"
  database_version = "MYSQL_8_0"
  project          = local.project_id
  region           = local.primary_region_eu
  settings {
    tier = "db-f1-micro"
    ip_configuration {
      psc_config {
        psc_enabled               = true
        allowed_consumer_projects = [local.project_id]
      }
      ipv4_enabled = false
    }
    backup_configuration {
      enabled            = true
      binary_log_enabled = true
    }
    availability_type           = "REGIONAL"
    deletion_protection_enabled = false
  }
}

// SQL User
resource "google_sql_user" "userseuw3" {
  project  = local.project_id
  name     = "testsql"
  instance = google_sql_database_instance.csqlpsctesteuw3.name
  password = "sql1234"
}

################################################ PSC Setup ################################################

// PSC address
resource "google_compute_address" "csqlpscip" {
  name         = "csqlpscip"
  project      = local.project_id
  region       = local.primary_region
  address_type = "INTERNAL"
  subnetwork   = "cx-vpc-infra-am-sn2-usc1"
  address      = "10.100.21.10"
}

// PSC Forwarding Rule
resource "google_compute_forwarding_rule" "default" {
  depends_on = [
    google_sql_database_instance.csqlpsctestusc1,
    google_compute_address.csqlpscip
  ]
  name                    = "psc-sql-cx-vpc-infra-am"
  project                 = local.project_id
  region                  = local.primary_region
  network                 = module.cx-vpc-infra-am.network_name
  ip_address              = google_compute_address.csqlpscip.self_link
  load_balancing_scheme   = ""
  target                  = google_sql_database_instance.csqlpsctestusc1.psc_service_attachment_link
  allow_psc_global_access = true
}

// PSC address
resource "google_compute_address" "csqlpscip2" {
  name         = "csqlpscip2"
  project      = local.project_id
  region       = local.primary_region
  address_type = "INTERNAL"
  subnetwork   = "cx-vpc-transit-am-sn2-usc1"
  address      = "172.16.1.10"
}

// PSC Forwarding Rule
resource "google_compute_forwarding_rule" "default2" {
  depends_on = [
    google_sql_database_instance.csqlpsctesteuw3,
    google_compute_address.csqlpscip2
  ]
  name                    = "psc-sql-cx-vpc-transit-am"
  project                 = local.project_id
  region                  = local.primary_region
  network                 = module.cx-vpc-transit-am.network_name
  ip_address              = google_compute_address.csqlpscip2.self_link
  load_balancing_scheme   = ""
  target                  = google_sql_database_instance.csqlpsctestusc1.psc_service_attachment_link
  allow_psc_global_access = true
}

// Consumer PSC address
resource "google_compute_address" "csqlpscip3" {
  name         = "csqlpscip3"
  project      = local.project_id
  region       = local.primary_region_eu
  address_type = "INTERNAL"
  subnetwork   = "cx-vpc-transit-eu-sn-euw3"
  address      = "10.100.3.10"
}

// PSC Forwarding Rule
resource "google_compute_forwarding_rule" "default3" {
  depends_on = [
    google_sql_database_instance.csqlpsctesteuw3,
    google_compute_address.csqlpscip3
  ]
  name                    = "psc-sql-cx-vpc-transit-eu"
  project                 = local.project_id
  region                  = local.primary_region_eu
  network                 = module.cx-vpc-transit-eu.network_name
  ip_address              = google_compute_address.csqlpscip3.self_link
  load_balancing_scheme   = ""
  target                  = google_sql_database_instance.csqlpsctesteuw3.psc_service_attachment_link
  allow_psc_global_access = true
}