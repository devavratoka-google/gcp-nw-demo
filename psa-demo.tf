// Creates a VPC which will be a consumer VPC for PSA
// PSA ranges and vpc peering
// memcached instance using a range from PSA VPC

################################################ cx-vpc-psa-test ################################################

// VPC
module "cx-vpc-psa-test" {
  source                                    = "terraform-google-modules/network/google"
  version                                   = "11.1.1"
  project_id                                = local.project_id
  network_name                              = "cx-vpc-psa-test"
  network_firewall_policy_enforcement_order = "BEFORE_CLASSIC_FIREWALL"
  subnets = [
    {
      subnet_name           = "${module.cx-vpc-psa-test.network_name}-subnet-01"
      subnet_ip             = "10.40.1.0/24"
      subnet_region         = "us-central1"
      subnet_private_access = "true"
      subnet_flow_logs      = "true"
    },
  ]
}

// PSA Range
resource "google_compute_global_address" "range1" {
  name          = "range1"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 24
  address       = "10.200.1.0"
  project       = local.project_id
  network       = module.cx-vpc-psa-test.network_name
}

// PSA Range
resource "google_compute_global_address" "range2" {
  name          = "range2"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 24
  project       = local.project_id
  address       = "10.200.2.0"
  network       = module.cx-vpc-psa-test.network_name
}

// PSA Range
resource "google_compute_global_address" "range3" {
  name          = "range3"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 28
  project       = local.project_id
  address       = "10.200.3.0"
  network       = module.cx-vpc-psa-test.network_name
}

// PSA Range
resource "google_compute_global_address" "range4" {
  name          = "range4"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 29
  project       = local.project_id
  address       = "10.200.4.0"
  network       = module.cx-vpc-psa-test.network_name
}

// VPC Peering
resource "google_service_networking_connection" "psa-conn-01" {
  network                 = module.cx-vpc-psa-test.network_id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.range1.name, google_compute_global_address.range2.name, google_compute_global_address.range3.name, google_compute_global_address.range4.name] //  
}

// VPC Peering custom routes
resource "google_compute_network_peering_routes_config" "peering_routes" {
  peering              = google_service_networking_connection.psa-conn-01.peering
  network              = module.cx-vpc-psa-test.network_name
  project              = local.project_id
  import_custom_routes = true
  export_custom_routes = true
}

// Memcached Instance
# resource "google_memcache_instance" "ds_memcache_instance" {
#   name                 = "ds-memcache-instance"
#   authorized_network   = google_service_networking_connection.psa-conn-01.network
#   reserved_ip_range_id = [google_compute_global_address.range1.name]
#   project              = local.project_id
#   region               = local.primary_region

#   node_config {
#     cpu_count      = 1
#     memory_size_mb = 1024
#   }
#   node_count       = 1
#   memcache_version = "MEMCACHE_1_5"

#   maintenance_policy {
#     weekly_maintenance_window {
#       day      = "SATURDAY"
#       duration = "14400s"
#       start_time {
#         hours   = 0
#         minutes = 30
#         seconds = 0
#         nanos   = 0
#       }
#     }
#   }
# }

# resource "google_memcache_instance" "ds_memcache_instance_euw3" {
#   name                 = "ds-memcache-instance-euw3"
#   authorized_network   = google_service_networking_connection.psa-conn-01.network
#   reserved_ip_range_id = [google_compute_global_address.range1.name]
#   project              = local.project_id
#   region               = "europe-west3"

#   node_config {
#     cpu_count      = 1
#     memory_size_mb = 1024
#   }
#   node_count       = 1
#   memcache_version = "MEMCACHE_1_5"

#   maintenance_policy {
#     weekly_maintenance_window {
#       day      = "SATURDAY"
#       duration = "14400s"
#       start_time {
#         hours   = 0
#         minutes = 30
#         seconds = 0
#         nanos   = 0
#       }
#     }
#   }
# }

######################################################### Cloud SQL Setup ########################################################## 

// CloudSQL
resource "google_sql_database_instance" "csqlpsctestusc1-02" {
  name             = "csqlpsctestusc1-02"
  database_version = "MYSQL_8_0"
  project          = local.project_id
  region           = local.primary_region
  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled                                  = false
      private_network                               = module.cx-vpc-psa-test.network_self_link
      enable_private_path_for_google_cloud_services = true
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
resource "google_sql_user" "usersusc1-02" {
  project  = local.project_id
  name     = "testsql"
  instance = google_sql_database_instance.csqlpsctestusc1-02.name
  password = "sql1234"
}