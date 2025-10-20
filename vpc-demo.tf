// Creates VPCs and subnets
// cloud router + cloud router NAT
// HA VPN Gateways

################################################ cx-vpc-infra-am ################################################

// VPC
module "cx-vpc-infra-am" {
  source                                    = "terraform-google-modules/network/google"
  version                                   = "11.1.1"
  project_id                                = local.project_id
  network_name                              = "cx-vpc-infra-am"
  network_firewall_policy_enforcement_order = "BEFORE_CLASSIC_FIREWALL"
  # bgp_best_path_selection_mode              = "STANDARD"
  # bgp_always_compare_med                    = false
  # bgp_inter_region_cost                     = "DEFAULT"
  subnets = [
    {
      subnet_name           = "${module.cx-vpc-infra-am.network_name}-sn-usc1"
      subnet_ip             = "10.100.11.0/24"
      subnet_region         = "us-central1"
      subnet_private_access = "true"
      subnet_flow_logs      = "true"
    },
    {
      subnet_name           = "${module.cx-vpc-infra-am.network_name}-sn-use4"
      subnet_ip             = "10.100.12.0/24"
      subnet_region         = "us-east4"
      subnet_private_access = "true"
      subnet_flow_logs      = "true"
    },
    # {
    #   subnet_name           = "${module.cx-vpc-infra-am.network_name}-sn2-uss1"
    #   subnet_ip             = "10.10.12.0/24"
    #   subnet_region         = "us-south1"
    #   subnet_private_access = "true"
    #   subnet_flow_logs      = "true"
    # },
    // cx-vpc-infra-am-sn2-usc1
    {
      subnet_name           = "${module.cx-vpc-infra-am.network_name}-sn2-usc1"
      subnet_ip             = "10.100.21.0/24"
      subnet_region         = "us-central1"
      subnet_private_access = "true"
      subnet_flow_logs      = "true"
    },
    { // Proxy Subnet us-central1
      subnet_name   = "${module.cx-vpc-infra-am.network_name}-proxy-usc1"
      subnet_ip     = "10.100.101.0/24"
      subnet_region = "us-central1"
      purpose       = "REGIONAL_MANAGED_PROXY"
      role          = "ACTIVE"
    },
    { // PSC Subnet
      subnet_name   = "${module.cx-vpc-infra-am.network_name}-psc1-usc1"
      subnet_ip     = "10.100.100.0/24"
      subnet_region = "us-central1"
      purpose       = "PRIVATE_SERVICE_CONNECT"
    },
  ]
}

// Cloud Router
resource "google_compute_router" "cr-cx-vpc-infra-am-usc1" {
  name    = "cr-cx-vpc-infra-am-usc1"
  network = module.cx-vpc-infra-am.network_name
  project = local.project_id
  region  = "us-central1"
  bgp {
    asn            = 64521
    advertise_mode = "DEFAULT"
  }
}

// Cloud Router NAT
resource "google_compute_router_nat" "nat-cr-cx-vpc-infra-am-usc1" {
  name                               = "nat-cr-cx-vpc-infra-am-usc1"
  router                             = google_compute_router.cr-cx-vpc-infra-am-usc1.name
  region                             = google_compute_router.cr-cx-vpc-infra-am-usc1.region
  project                            = local.project_id
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  nat_ip_allocate_option             = "AUTO_ONLY"
}

################################################ cx-vpc-infra-eu ################################################

// VPC
module "cx-vpc-infra-eu" {
  source                                    = "terraform-google-modules/network/google"
  version                                   = "11.1.1"
  project_id                                = local.project_id
  network_name                              = "cx-vpc-infra-eu"
  network_firewall_policy_enforcement_order = "BEFORE_CLASSIC_FIREWALL"
  subnets = [
    {
      subnet_name           = "${module.cx-vpc-infra-eu.network_name}-sn-euw3"
      subnet_ip             = "10.100.13.0/24"
      subnet_region         = "europe-west3"
      subnet_private_access = "true"
      subnet_flow_logs      = "true"
    },
    {
      subnet_name           = "${module.cx-vpc-infra-eu.network_name}-sn-euw4"
      subnet_ip             = "10.100.14.0/24"
      subnet_region         = "europe-west4"
      subnet_private_access = "true"
      subnet_flow_logs      = "true"
    },
  ]
}

// Cloud Router
resource "google_compute_router" "cr-cx-vpc-infra-eu-euw3" {
  name    = "cr-cx-vpc-infra-eu-euw3"
  network = module.cx-vpc-infra-eu.network_name
  project = local.project_id
  region  = "europe-west3"
  bgp {
    asn            = 64521
    advertise_mode = "DEFAULT"
  }
}

// Cloud Router NAT
resource "google_compute_router_nat" "nat-cr-cx-vpc-infra-eu-euw3" {
  name                               = "nat-cr-cx-vpc-infra-eu-euw3"
  router                             = google_compute_router.cr-cx-vpc-infra-eu-euw3.name
  region                             = google_compute_router.cr-cx-vpc-infra-eu-euw3.region
  project                            = local.project_id
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  nat_ip_allocate_option             = "AUTO_ONLY"
}

################################################ cx-vpc-transit-am ################################################

// VPC
module "cx-vpc-transit-am" {
  source                                    = "terraform-google-modules/network/google"
  version                                   = "11.1.1"
  project_id                                = local.project_id
  network_name                              = "cx-vpc-transit-am"
  network_firewall_policy_enforcement_order = "BEFORE_CLASSIC_FIREWALL"
  subnets = [
    {
      subnet_name           = "${module.cx-vpc-transit-am.network_name}-sn-usc1"
      subnet_ip             = "10.100.1.0/24"
      subnet_region         = "us-central1"
      subnet_private_access = "true"
      subnet_flow_logs      = "true"
    },
    {
      subnet_name           = "${module.cx-vpc-transit-am.network_name}-sn2-usc1"
      subnet_ip             = "172.16.1.0/24"
      subnet_region         = "us-central1"
      subnet_private_access = "true"
      subnet_flow_logs      = "true"
    },
    {
      subnet_name           = "${module.cx-vpc-transit-am.network_name}-sn-use4"
      subnet_ip             = "10.100.2.0/24"
      subnet_region         = "us-east4"
      subnet_private_access = "true"
      subnet_flow_logs      = "true"
    },
    {
      subnet_name   = "${module.cx-vpc-transit-am.network_name}-psc1-usc1"
      subnet_ip     = "10.100.99.0/24"
      subnet_region = "us-central1"
      purpose       = "PRIVATE_SERVICE_CONNECT"
    },
  ]
}

// Cloud Router
resource "google_compute_router" "cr-cx-vpc-transit-am-usc1" {
  name    = "cr-cx-vpc-transit-am-usc1"
  network = module.cx-vpc-transit-am.network_name
  project = local.project_id
  region  = "us-central1"
  bgp {
    asn            = 64521
    advertise_mode = "DEFAULT"
  }
}

// Cloud Router NAT
resource "google_compute_router_nat" "nat-cr-cx-vpc-transit-am-usc1" {
  name                               = "nat-cr-cx-vpc-transit-am-usc1"
  router                             = google_compute_router.cr-cx-vpc-transit-am-usc1.name
  region                             = google_compute_router.cr-cx-vpc-transit-am-usc1.region
  project                            = local.project_id
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  nat_ip_allocate_option             = "AUTO_ONLY"
}

// HA VPN Gateway
resource "google_compute_ha_vpn_gateway" "vpngw-cx-vpc-transit-am-usc1" {
  name    = "vpngw-cx-vpc-transit-am-usc1"
  network = module.cx-vpc-transit-am.network_name
  project = local.project_id
  region  = "us-central1"
}

// Cloud Router
resource "google_compute_router" "cr-cx-vpc-transit-am-use4" {
  name    = "cr-cx-vpc-transit-am-use4"
  network = module.cx-vpc-transit-am.network_name
  project = local.project_id
  region  = "us-east4"
  bgp {
    asn            = 64522
    advertise_mode = "DEFAULT"
  }
}

// HA VPN Gateway
resource "google_compute_ha_vpn_gateway" "vpngw-cx-vpc-transit-am-use4" {
  name    = "vpngw-cx-vpc-transit-am-use4"
  network = module.cx-vpc-transit-am.network_name
  project = local.project_id
  region  = "us-east4"
}

################################################ cx-vpc-transit-eu ################################################

// VPC
module "cx-vpc-transit-eu" {
  source                                    = "terraform-google-modules/network/google"
  version                                   = "11.1.1"
  project_id                                = local.project_id
  network_name                              = "cx-vpc-transit-eu"
  network_firewall_policy_enforcement_order = "BEFORE_CLASSIC_FIREWALL"
  subnets = [
    {
      subnet_name           = "${module.cx-vpc-transit-eu.network_name}-sn-euw3"
      subnet_ip             = "10.100.3.0/24"
      subnet_region         = "europe-west3"
      subnet_private_access = "true"
      subnet_flow_logs      = "true"
    },
    {
      subnet_name           = "${module.cx-vpc-transit-eu.network_name}-sn-euw4"
      subnet_ip             = "10.100.4.0/24"
      subnet_region         = "europe-west4"
      subnet_private_access = "true"
      subnet_flow_logs      = "true"
    },
  ]
}

// Cloud Router
resource "google_compute_router" "cr-cx-vpc-transit-eu-euw3" {
  name    = "cr-cx-vpc-transit-eu-euw3"
  network = module.cx-vpc-transit-eu.network_name
  project = local.project_id
  region  = "europe-west3"
  bgp {
    asn            = 64523
    advertise_mode = "DEFAULT"
  }
}

// HA VPN Gateway
resource "google_compute_ha_vpn_gateway" "vpngw-cx-vpc-transit-eu-euw3" {
  name    = "vpngw-cx-vpc-transit-eu-euw3"
  network = module.cx-vpc-transit-eu.network_name
  project = local.project_id
  region  = "europe-west3"
}

// Cloud Router
resource "google_compute_router" "cr-cx-vpc-transit-eu-euw4" {
  name    = "cr-cx-vpc-transit-eu-euw4"
  network = module.cx-vpc-transit-eu.network_name
  project = local.project_id
  region  = "europe-west4"
  bgp {
    asn            = 64524
    advertise_mode = "DEFAULT"
  }
}

// HA VPN Gateway
resource "google_compute_ha_vpn_gateway" "vpngw-cx-vpc-transit-eu-euw4" {
  name    = "vpngw-cx-vpc-transit-eu-euw4"
  network = module.cx-vpc-transit-eu.network_name
  project = local.project_id
  region  = "europe-west4"
}

################################################ cx-vpc-onprem-dc1 ################################################

// VPC
module "cx-vpc-onprem-dc1" {
  source                                    = "terraform-google-modules/network/google"
  version                                   = "11.1.1"
  project_id                                = local.project_id
  network_name                              = "cx-vpc-onprem-dc1"
  network_firewall_policy_enforcement_order = "BEFORE_CLASSIC_FIREWALL"
  # bgp_best_path_selection_mode              = "STANDARD"
  # bgp_always_compare_med                    = true
  # bgp_inter_region_cost                     = "ADD_COST_TO_MED"
  subnets = [
    {
      subnet_name           = "${module.cx-vpc-onprem-dc1.network_name}-sn"
      subnet_ip             = "192.168.1.0/24"
      subnet_region         = "us-central1"
      subnet_private_access = "true"
      subnet_flow_logs      = "true"
    },
    {
      subnet_name           = "${module.cx-vpc-onprem-dc1.network_name}-sn-rfc1918-01"
      subnet_ip             = "10.0.0.0/24"
      subnet_region         = "us-central1"
      subnet_private_access = "true"
      subnet_flow_logs      = "true"
    },
  ]
}

// Cloud Router
resource "google_compute_router" "cr-cx-vpc-onprem-dc1-usc1" {
  name    = "cr-cx-vpc-onprem-dc1-usc1"
  network = module.cx-vpc-onprem-dc1.network_name
  project = local.project_id
  region  = "us-central1"
  bgp {
    asn            = 64531
    advertise_mode = "DEFAULT"
  }
}

// Cloud Router NAT
resource "google_compute_router_nat" "nat-cr-cx-vpc-onprem-dc1-usc1" {
  name                               = "nat-cr-cx-vpc-onprem-dc1-usc1"
  router                             = google_compute_router.cr-cx-vpc-onprem-dc1-usc1.name
  region                             = google_compute_router.cr-cx-vpc-onprem-dc1-usc1.region
  project                            = local.project_id
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  nat_ip_allocate_option             = "AUTO_ONLY"
}

// HA VPN Gateway
resource "google_compute_ha_vpn_gateway" "vpngw-cx-vpc-onprem-dc1-usc1" {
  name    = "vpngw-cx-vpc-onprem-dc1-usc1"
  network = module.cx-vpc-onprem-dc1.network_name
  project = local.project_id
  region  = "us-central1"
}

################################################ cx-vpc-onprem-dc2 ################################################

// VPC
module "cx-vpc-onprem-dc2" {
  source                                    = "terraform-google-modules/network/google"
  version                                   = "11.1.1"
  project_id                                = local.project_id
  network_name                              = "cx-vpc-onprem-dc2"
  network_firewall_policy_enforcement_order = "BEFORE_CLASSIC_FIREWALL"
  # bgp_best_path_selection_mode              = "STANDARD"
  # bgp_always_compare_med                    = true
  # bgp_inter_region_cost                     = "ADD_COST_TO_MED"
  subnets = [
    {
      subnet_name           = "${module.cx-vpc-onprem-dc2.network_name}-sn"
      subnet_ip             = "192.168.2.0/24"
      subnet_region         = "us-east4"
      subnet_private_access = "true"
      subnet_flow_logs      = "true"
    },
    {
      subnet_name           = "${module.cx-vpc-onprem-dc2.network_name}-sn-rfc1918-02"
      subnet_ip             = "10.0.0.0/24"
      subnet_region         = "us-east4"
      subnet_private_access = "true"
      subnet_flow_logs      = "true"
    },
  ]
}

// Cloud Router
resource "google_compute_router" "cr-cx-vpc-onprem-dc2-use4" {
  name    = "cr-cx-vpc-onprem-dc2-use4"
  network = module.cx-vpc-onprem-dc2.network_name
  project = local.project_id
  region  = "us-east4"
  bgp {
    asn            = 64532
    advertise_mode = "DEFAULT"
  }
}

// HA VPN Gateway
resource "google_compute_ha_vpn_gateway" "vpngw-cx-vpc-onprem-dc2-use4" {
  name    = "vpngw-cx-vpc-onprem-dc2-use4"
  network = module.cx-vpc-onprem-dc2.network_name
  project = local.project_id
  region  = "us-east4"
}

################################################ cx-vpc-onprem-dc3 ################################################

// VPC
module "cx-vpc-onprem-dc3" {
  source                                    = "terraform-google-modules/network/google"
  version                                   = "11.1.1"
  project_id                                = local.project_id
  network_name                              = "cx-vpc-onprem-dc3"
  network_firewall_policy_enforcement_order = "BEFORE_CLASSIC_FIREWALL"
  # bgp_best_path_selection_mode              = "STANDARD"
  # bgp_always_compare_med                    = true
  # bgp_inter_region_cost                     = "ADD_COST_TO_MED"
  subnets = [
    {
      subnet_name           = "${module.cx-vpc-onprem-dc3.network_name}-sn"
      subnet_ip             = "192.168.3.0/24"
      subnet_region         = "europe-west3"
      subnet_private_access = "true"
      subnet_flow_logs      = "true"
    },
    {
      subnet_name           = "${module.cx-vpc-onprem-dc3.network_name}-sn-rfc1918-03"
      subnet_ip             = "10.0.0.0/24"
      subnet_region         = "europe-west3"
      subnet_private_access = "true"
      subnet_flow_logs      = "true"
    },
  ]
}

// Cloud Router
resource "google_compute_router" "cr-cx-vpc-onprem-dc3-euw3" {
  name    = "cr-cx-vpc-onprem-dc3-euw3"
  network = module.cx-vpc-onprem-dc3.network_name
  project = local.project_id
  region  = "europe-west3"
  bgp {
    asn            = 64533
    advertise_mode = "DEFAULT"
  }
}

// Cloud Router NAT
resource "google_compute_router_nat" "nat-cr-cx-vpc-onprem-dc3-euw3" {
  name                               = "nat-cr-cx-vpc-onprem-dc3-euw3"
  router                             = google_compute_router.cr-cx-vpc-onprem-dc3-euw3.name
  region                             = google_compute_router.cr-cx-vpc-onprem-dc3-euw3.region
  project                            = local.project_id
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  nat_ip_allocate_option             = "AUTO_ONLY"
}

// HA VPN Gateway
resource "google_compute_ha_vpn_gateway" "vpngw-cx-vpc-onprem-dc3-euw3" {
  name    = "vpngw-cx-vpc-onprem-dc3-euw3"
  network = module.cx-vpc-onprem-dc3.network_name
  project = local.project_id
  region  = "europe-west3"
}

################################################ cx-vpc-onprem-dc4 ################################################

// VPC
module "cx-vpc-onprem-dc4" {
  source                                    = "terraform-google-modules/network/google"
  version                                   = "11.1.1"
  project_id                                = local.project_id
  network_name                              = "cx-vpc-onprem-dc4"
  network_firewall_policy_enforcement_order = "BEFORE_CLASSIC_FIREWALL"
  # bgp_best_path_selection_mode              = "STANDARD"
  # bgp_always_compare_med                    = true
  # bgp_inter_region_cost                     = "ADD_COST_TO_MED"
  subnets = [
    {
      subnet_name           = "${module.cx-vpc-onprem-dc4.network_name}-sn"
      subnet_ip             = "192.168.4.0/24"
      subnet_region         = "europe-west4"
      subnet_private_access = "true"
      subnet_flow_logs      = "true"
    },
    {
      subnet_name           = "${module.cx-vpc-onprem-dc4.network_name}-sn-rfc1918-04"
      subnet_ip             = "10.0.0.0/24"
      subnet_region         = "europe-west4"
      subnet_private_access = "true"
      subnet_flow_logs      = "true"
    },
  ]
}

// Cloud Router
resource "google_compute_router" "cr-cx-vpc-onprem-dc4-euw4" {
  name    = "cr-cx-vpc-onprem-dc4-euw4"
  network = module.cx-vpc-onprem-dc4.network_name
  project = local.project_id
  region  = "europe-west4"
  bgp {
    asn            = 64534
    advertise_mode = "DEFAULT"
  }
}

// Cloud Router NAT
resource "google_compute_ha_vpn_gateway" "vpngw-cx-vpc-onprem-dc4-euw4" {
  name    = "vpngw-cx-vpc-onprem-dc4-euw4"
  network = module.cx-vpc-onprem-dc4.network_name
  project = local.project_id
  region  = "europe-west4"
}