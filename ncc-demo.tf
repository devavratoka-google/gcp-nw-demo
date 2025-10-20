// Creates NCC Hub
// vpc spokes
// hybrid spokes
// producer spoke

################################################ NCC ################################################

// NCC Module
module "network_connectivity_center" {
  source = "terraform-google-modules/network/google//modules/network-connectivity-center"
  depends_on = [
    module.cx-vpc-infra-am,
    module.cx-vpc-infra-eu,
    google_compute_vpn_tunnel.cx-vpc-transit-am-vpn-cx-vpc-onprem-dc1-01,
    google_compute_vpn_tunnel.cx-vpc-transit-am-vpn-cx-vpc-onprem-dc2-01,
    google_compute_vpn_tunnel.cx-vpc-transit-eu-vpn-cx-vpc-onprem-dc3-01,
    google_compute_vpn_tunnel.cx-vpc-transit-eu-vpn-cx-vpc-onprem-dc4-01,
    google_compute_vpn_tunnel.cx-vpc-transit-am-vpn-cx-vpc-onprem-dc1-02,
    google_compute_vpn_tunnel.cx-vpc-transit-am-vpn-cx-vpc-onprem-dc2-02,
    google_compute_vpn_tunnel.cx-vpc-transit-eu-vpn-cx-vpc-onprem-dc3-02,
    google_compute_vpn_tunnel.cx-vpc-transit-eu-vpn-cx-vpc-onprem-dc4-02,
  ]
  project_id   = local.project_id
  ncc_hub_name = "ds-bgp-ncc-hub"
  export_psc   = true
  ncc_hub_labels = {
    "module" = "ncc"
  }
  spoke_labels = {
    "created-by" = "terraform-google-ncc-example"
  }
  // VPC Spokes
  vpc_spokes = {
    "vpc-infra-am" = {
      uri = module.cx-vpc-infra-am.network_id
      labels = {
        "spoke-type" = "vpc"
      }
    },
    "vpc-infra-eu" = {
      uri = module.cx-vpc-infra-eu.network_id
      labels = {
        "spoke-type" = "vpc"
      }
    },
    "cx-vpc-psa-test" = {
      uri = module.cx-vpc-psa-test.network_id
      labels = {
        "spoke-type" = "vpc"
      }
    },
  }
  // Hybrid Spokes
  hybrid_spokes = {
    "cx-vpc-transit-am-vpn-cx-vpc-onprem-dc1-01" = {
      type                  = "vpn"
      uris                  = [google_compute_vpn_tunnel.cx-vpc-transit-am-vpn-cx-vpc-onprem-dc1-01.self_link, google_compute_vpn_tunnel.cx-vpc-transit-am-vpn-cx-vpc-onprem-dc1-02.self_link]
      location              = "us-central1"
      include_import_ranges = ["ALL_IPV4_RANGES"]
    },
    "cx-vpc-transit-am-vpn-cx-vpc-onprem-dc2-01" = {
      type                  = "vpn"
      uris                  = [google_compute_vpn_tunnel.cx-vpc-transit-am-vpn-cx-vpc-onprem-dc2-01.self_link, google_compute_vpn_tunnel.cx-vpc-transit-am-vpn-cx-vpc-onprem-dc2-02.self_link]
      location              = "us-east4"
      include_import_ranges = ["ALL_IPV4_RANGES"]
    },
    "cx-vpc-transit-eu-vpn-cx-vpc-onprem-dc3-01" = {
      type                  = "vpn"
      uris                  = [google_compute_vpn_tunnel.cx-vpc-transit-eu-vpn-cx-vpc-onprem-dc3-01.self_link, google_compute_vpn_tunnel.cx-vpc-transit-eu-vpn-cx-vpc-onprem-dc3-02.self_link]
      location              = "europe-west3"
      include_import_ranges = ["ALL_IPV4_RANGES"]
    },
    "cx-vpc-transit-eu-vpn-cx-vpc-onprem-dc4-01" = {
      type                  = "vpn"
      uris                  = [google_compute_vpn_tunnel.cx-vpc-transit-eu-vpn-cx-vpc-onprem-dc4-01.self_link, google_compute_vpn_tunnel.cx-vpc-transit-eu-vpn-cx-vpc-onprem-dc4-02.self_link]
      location              = "europe-west4"
      include_import_ranges = ["ALL_IPV4_RANGES"]
    },
  }
}

# output "ncc_hub_uri" {
#   value = module.network_connectivity_center.ncc_hub.id
# }

// Producer Spoke
resource "google_network_connectivity_spoke" "producer_spoke_psatest" {
  project  = local.project_id
  name     = "producer-spoke-psatest"
  location = "global"
  labels = {
    "spoke-type" = "producer"
  }
  hub = module.network_connectivity_center.ncc_hub.id
  linked_producer_vpc_network {
    network               = module.cx-vpc-psa-test.network_id
    peering               = google_service_networking_connection.psa-conn-01.peering
    exclude_export_ranges = []
  }
  depends_on = [module.network_connectivity_center]
}