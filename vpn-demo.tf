// Creates VPN Tunnels, cloud router interface and bgp peers

################################################ cx-vpc-transit-am usc1 to cx-vpc-onprem-dc1 ################################################

######################## Tunnel 1 ########################
######################## ----->>> ########################

resource "google_compute_vpn_tunnel" "cx-vpc-transit-am-vpn-cx-vpc-onprem-dc1-01" {
  name                  = "cx-vpc-transit-am-vpn-cx-vpc-onprem-dc1-01"
  vpn_gateway           = google_compute_ha_vpn_gateway.vpngw-cx-vpc-transit-am-usc1.id
  vpn_gateway_interface = 0
  peer_gcp_gateway      = google_compute_ha_vpn_gateway.vpngw-cx-vpc-onprem-dc1-usc1.id
  shared_secret         = "abcd1234"
  project               = local.project_id
  region                = "us-central1"
  router                = google_compute_router.cr-cx-vpc-transit-am-usc1.name
}

resource "google_compute_router_interface" "if-cx-vpc-transit-am-vpn-cx-vpc-onprem-dc1-01" {
  name       = "if-cx-vpc-transit-am-vpn-cx-vpc-onprem-dc1-01"
  router     = google_compute_router.cr-cx-vpc-transit-am-usc1.name
  region     = "us-central1"
  project    = local.project_id
  ip_range   = "169.254.1.1/30"
  vpn_tunnel = google_compute_vpn_tunnel.cx-vpc-transit-am-vpn-cx-vpc-onprem-dc1-01.name
}

resource "google_compute_router_peer" "peer-cx-vpc-transit-am-vpn-cx-vpc-onprem-dc1-01" {
  name                      = "peer-cx-vpc-transit-am-vpn-cx-vpc-onprem-dc1-01"
  router                    = google_compute_router.cr-cx-vpc-transit-am-usc1.name
  region                    = "us-central1"
  project                   = local.project_id
  peer_asn                  = google_compute_router.cr-cx-vpc-onprem-dc1-usc1.bgp[0].asn
  peer_ip_address           = "169.254.1.2"
  advertised_route_priority = 100
  # advertise_mode            = "CUSTOM"
  # advertised_groups         = ["ALL_SUBNETS"]
  # advertised_ip_ranges {
  #   range       = "10.100.11.0/24"
  #   description = "workload usc1"
  # }
  # advertised_ip_ranges {
  #   range       = "10.100.12.0/24"
  #   description = "workload use4"
  # }
  interface = google_compute_router_interface.if-cx-vpc-transit-am-vpn-cx-vpc-onprem-dc1-01.name
}

######################## <<<----- ########################

resource "google_compute_vpn_tunnel" "cx-vpc-onprem-dc1-vpn-cx-vpc-transit-am-01" {
  name                  = "cx-vpc-onprem-dc1-vpn-cx-vpc-transit-am-01"
  vpn_gateway           = google_compute_ha_vpn_gateway.vpngw-cx-vpc-onprem-dc1-usc1.id
  vpn_gateway_interface = 0
  peer_gcp_gateway      = google_compute_ha_vpn_gateway.vpngw-cx-vpc-transit-am-usc1.id
  shared_secret         = "abcd1234"
  project               = local.project_id
  region                = "us-central1"
  router                = google_compute_router.cr-cx-vpc-onprem-dc1-usc1.name
}

resource "google_compute_router_interface" "if-cx-vpc-onprem-dc1-vpn-cx-vpc-transit-am-01" {
  name       = "if-cx-vpc-onprem-dc1-vpn-cx-vpc-transit-am-01"
  router     = google_compute_router.cr-cx-vpc-onprem-dc1-usc1.name
  region     = "us-central1"
  project    = local.project_id
  ip_range   = "169.254.1.2/30"
  vpn_tunnel = google_compute_vpn_tunnel.cx-vpc-onprem-dc1-vpn-cx-vpc-transit-am-01.name
}

resource "google_compute_router_peer" "peer-cx-vpc-onprem-dc1-vpn-cx-vpc-transit-am-01" {
  name                      = "peer-cx-vpc-onprem-dc1-vpn-cx-vpc-transit-am-01"
  router                    = google_compute_router.cr-cx-vpc-onprem-dc1-usc1.name
  region                    = "us-central1"
  project                   = local.project_id
  peer_asn                  = google_compute_router.cr-cx-vpc-transit-am-usc1.bgp[0].asn
  peer_ip_address           = "169.254.1.1"
  advertised_route_priority = 100
  advertise_mode            = "CUSTOM"
  advertised_groups         = ["ALL_SUBNETS"]
  advertised_ip_ranges {
    range       = "10.0.0.0/8"
    description = "On premises supernet to GCP"
  }
  # advertised_ip_ranges {
  #   range       = "172.16.0.0/12"
  #   description = "PSC Subnet"
  # }
  interface = google_compute_router_interface.if-cx-vpc-onprem-dc1-vpn-cx-vpc-transit-am-01.name
}

######################## Tunnel 2 ########################
######################## ----->>> ########################

resource "google_compute_vpn_tunnel" "cx-vpc-transit-am-vpn-cx-vpc-onprem-dc1-02" {
  name                  = "cx-vpc-transit-am-vpn-cx-vpc-onprem-dc1-02"
  vpn_gateway           = google_compute_ha_vpn_gateway.vpngw-cx-vpc-transit-am-usc1.id
  vpn_gateway_interface = 1
  peer_gcp_gateway      = google_compute_ha_vpn_gateway.vpngw-cx-vpc-onprem-dc1-usc1.id
  shared_secret         = "abcd1234"
  project               = local.project_id
  region                = "us-central1"
  router                = google_compute_router.cr-cx-vpc-transit-am-usc1.name
}

resource "google_compute_router_interface" "if-cx-vpc-transit-am-vpn-cx-vpc-onprem-dc1-02" {
  name       = "if-cx-vpc-transit-am-vpn-cx-vpc-onprem-dc1-02"
  router     = google_compute_router.cr-cx-vpc-transit-am-usc1.name
  region     = "us-central1"
  project    = local.project_id
  ip_range   = "169.254.1.17/30"
  vpn_tunnel = google_compute_vpn_tunnel.cx-vpc-transit-am-vpn-cx-vpc-onprem-dc1-02.name
}

resource "google_compute_router_peer" "peer-cx-vpc-transit-am-vpn-cx-vpc-onprem-dc1-02" {
  name                      = "peer-cx-vpc-transit-am-vpn-cx-vpc-onprem-dc1-02"
  router                    = google_compute_router.cr-cx-vpc-transit-am-usc1.name
  region                    = "us-central1"
  project                   = local.project_id
  peer_asn                  = google_compute_router.cr-cx-vpc-onprem-dc1-usc1.bgp[0].asn
  peer_ip_address           = "169.254.1.18"
  advertised_route_priority = 100
  # advertise_mode            = "CUSTOM"
  # advertised_groups         = ["ALL_SUBNETS"]
  # advertised_ip_ranges {
  #   range       = "10.100.11.0/24"
  #   description = "workload usc1"
  # }
  # advertised_ip_ranges {
  #   range       = "10.100.12.0/24"
  #   description = "workload use4"
  # }
  interface = google_compute_router_interface.if-cx-vpc-transit-am-vpn-cx-vpc-onprem-dc1-02.name
}

######################## <<<----- ########################

resource "google_compute_vpn_tunnel" "cx-vpc-onprem-dc1-vpn-cx-vpc-transit-am-02" {
  name                  = "cx-vpc-onprem-dc1-vpn-cx-vpc-transit-am-02"
  vpn_gateway           = google_compute_ha_vpn_gateway.vpngw-cx-vpc-onprem-dc1-usc1.id
  vpn_gateway_interface = 1
  peer_gcp_gateway      = google_compute_ha_vpn_gateway.vpngw-cx-vpc-transit-am-usc1.id
  shared_secret         = "abcd1234"
  project               = local.project_id
  region                = "us-central1"
  router                = google_compute_router.cr-cx-vpc-onprem-dc1-usc1.name
}

resource "google_compute_router_interface" "if-cx-vpc-onprem-dc1-vpn-cx-vpc-transit-am-02" {
  name       = "if-cx-vpc-onprem-dc1-vpn-cx-vpc-transit-am-02"
  router     = google_compute_router.cr-cx-vpc-onprem-dc1-usc1.name
  region     = "us-central1"
  project    = local.project_id
  ip_range   = "169.254.1.18/30"
  vpn_tunnel = google_compute_vpn_tunnel.cx-vpc-onprem-dc1-vpn-cx-vpc-transit-am-02.name
}

resource "google_compute_router_peer" "peer-cx-vpc-onprem-dc1-vpn-cx-vpc-transit-am-02" {
  name                      = "peer-cx-vpc-onprem-dc1-vpn-cx-vpc-transit-am-02"
  router                    = google_compute_router.cr-cx-vpc-onprem-dc1-usc1.name
  region                    = "us-central1"
  project                   = local.project_id
  peer_asn                  = google_compute_router.cr-cx-vpc-transit-am-usc1.bgp[0].asn
  peer_ip_address           = "169.254.1.17"
  advertised_route_priority = 100
  advertise_mode            = "CUSTOM"
  advertised_groups         = ["ALL_SUBNETS"]
  advertised_ip_ranges {
    range       = "10.0.0.0/8"
    description = "On premises supernet to GCP"
  }
  # advertised_ip_ranges {
  #   range       = "172.16.0.0/12"
  #   description = "PSC Subnet"
  # }
  interface = google_compute_router_interface.if-cx-vpc-onprem-dc1-vpn-cx-vpc-transit-am-02.name
}

################################################ cx-vpc-transit-am use4 to cx-vpc-onprem-dc2 ################################################

######################## Tunnel 1 ########################
######################## ----->>> ########################

resource "google_compute_vpn_tunnel" "cx-vpc-transit-am-vpn-cx-vpc-onprem-dc2-01" {
  name                  = "cx-vpc-transit-am-vpn-cx-vpc-onprem-dc2-01"
  vpn_gateway           = google_compute_ha_vpn_gateway.vpngw-cx-vpc-transit-am-use4.id
  vpn_gateway_interface = 0
  peer_gcp_gateway      = google_compute_ha_vpn_gateway.vpngw-cx-vpc-onprem-dc2-use4.id
  shared_secret         = "abcd1234"
  project               = local.project_id
  region                = "us-east4"
  router                = google_compute_router.cr-cx-vpc-transit-am-use4.name
}

resource "google_compute_router_interface" "if-cx-vpc-transit-am-vpn-cx-vpc-onprem-dc2-01" {
  name       = "if-cx-vpc-transit-am-vpn-cx-vpc-onprem-dc2-01"
  router     = google_compute_router.cr-cx-vpc-transit-am-use4.name
  region     = "us-east4"
  project    = local.project_id
  ip_range   = "169.254.1.5/30"
  vpn_tunnel = google_compute_vpn_tunnel.cx-vpc-transit-am-vpn-cx-vpc-onprem-dc2-01.name
}

resource "google_compute_router_peer" "peer-cx-vpc-transit-am-vpn-cx-vpc-onprem-dc2-01" {
  name                      = "peer-cx-vpc-transit-am-vpn-cx-vpc-onprem-dc2-01"
  router                    = google_compute_router.cr-cx-vpc-transit-am-use4.name
  region                    = "us-east4"
  project                   = local.project_id
  peer_asn                  = google_compute_router.cr-cx-vpc-onprem-dc2-use4.bgp[0].asn
  peer_ip_address           = "169.254.1.6"
  advertised_route_priority = 100
  interface                 = google_compute_router_interface.if-cx-vpc-transit-am-vpn-cx-vpc-onprem-dc2-01.name
}

######################## <<<----- ########################

resource "google_compute_vpn_tunnel" "cx-vpc-onprem-dc2-vpn-cx-vpc-transit-am-01" {
  name                  = "cx-vpc-onprem-dc2-vpn-cx-vpc-transit-am-01"
  vpn_gateway           = google_compute_ha_vpn_gateway.vpngw-cx-vpc-onprem-dc2-use4.id
  vpn_gateway_interface = 0
  peer_gcp_gateway      = google_compute_ha_vpn_gateway.vpngw-cx-vpc-transit-am-use4.id
  shared_secret         = "abcd1234"
  project               = local.project_id
  region                = "us-east4"
  router                = google_compute_router.cr-cx-vpc-onprem-dc2-use4.name
}

resource "google_compute_router_interface" "if-cx-vpc-onprem-dc2-vpn-cx-vpc-transit-am-01" {
  name       = "if-cx-vpc-onprem-dc2-vpn-cx-vpc-transit-am-01"
  router     = google_compute_router.cr-cx-vpc-onprem-dc2-use4.name
  region     = "us-east4"
  project    = local.project_id
  ip_range   = "169.254.1.6/30"
  vpn_tunnel = google_compute_vpn_tunnel.cx-vpc-onprem-dc2-vpn-cx-vpc-transit-am-01.name
}

resource "google_compute_router_peer" "peer-cx-vpc-onprem-dc2-vpn-cx-vpc-transit-am-01" {
  name                      = "peer-cx-vpc-onprem-dc2-vpn-cx-vpc-transit-am-01"
  router                    = google_compute_router.cr-cx-vpc-onprem-dc2-use4.name
  region                    = "us-east4"
  project                   = local.project_id
  peer_asn                  = google_compute_router.cr-cx-vpc-transit-am-use4.bgp[0].asn
  peer_ip_address           = "169.254.1.5"
  advertised_route_priority = 100
  advertise_mode            = "CUSTOM"
  advertised_groups         = ["ALL_SUBNETS"]
  advertised_ip_ranges {
    range       = "10.0.0.0/8"
    description = "On premises supernet to GCP"
  }
  # advertised_ip_ranges {
  #   range       = "172.16.0.0/12"
  #   description = "PSC Subnet"
  # }
  interface       = google_compute_router_interface.if-cx-vpc-onprem-dc2-vpn-cx-vpc-transit-am-01.name
  export_policies = ["secondary-dc-route-policy"]
}

######################## Tunnel 2 ########################
######################## ----->>> ########################

resource "google_compute_vpn_tunnel" "cx-vpc-transit-am-vpn-cx-vpc-onprem-dc2-02" {
  name                  = "cx-vpc-transit-am-vpn-cx-vpc-onprem-dc2-02"
  vpn_gateway           = google_compute_ha_vpn_gateway.vpngw-cx-vpc-transit-am-use4.id
  vpn_gateway_interface = 1
  peer_gcp_gateway      = google_compute_ha_vpn_gateway.vpngw-cx-vpc-onprem-dc2-use4.id
  shared_secret         = "abcd1234"
  project               = local.project_id
  region                = "us-east4"
  router                = google_compute_router.cr-cx-vpc-transit-am-use4.name
}

resource "google_compute_router_interface" "if-cx-vpc-transit-am-vpn-cx-vpc-onprem-dc2-02" {
  name       = "if-cx-vpc-transit-am-vpn-cx-vpc-onprem-dc2-02"
  router     = google_compute_router.cr-cx-vpc-transit-am-use4.name
  region     = "us-east4"
  project    = local.project_id
  ip_range   = "169.254.1.21/30"
  vpn_tunnel = google_compute_vpn_tunnel.cx-vpc-transit-am-vpn-cx-vpc-onprem-dc2-02.name
}

resource "google_compute_router_peer" "peer-cx-vpc-transit-am-vpn-cx-vpc-onprem-dc2-02" {
  name                      = "peer-cx-vpc-transit-am-vpn-cx-vpc-onprem-dc2-02"
  router                    = google_compute_router.cr-cx-vpc-transit-am-use4.name
  region                    = "us-east4"
  project                   = local.project_id
  peer_asn                  = google_compute_router.cr-cx-vpc-onprem-dc2-use4.bgp[0].asn
  peer_ip_address           = "169.254.1.22"
  advertised_route_priority = 100
  interface                 = google_compute_router_interface.if-cx-vpc-transit-am-vpn-cx-vpc-onprem-dc2-02.name
}

######################## <<<----- ########################

resource "google_compute_vpn_tunnel" "cx-vpc-onprem-dc2-vpn-cx-vpc-transit-am-02" {
  name                  = "cx-vpc-onprem-dc2-vpn-cx-vpc-transit-am-02"
  vpn_gateway           = google_compute_ha_vpn_gateway.vpngw-cx-vpc-onprem-dc2-use4.id
  vpn_gateway_interface = 1
  peer_gcp_gateway      = google_compute_ha_vpn_gateway.vpngw-cx-vpc-transit-am-use4.id
  shared_secret         = "abcd1234"
  project               = local.project_id
  region                = "us-east4"
  router                = google_compute_router.cr-cx-vpc-onprem-dc2-use4.name
}

resource "google_compute_router_interface" "if-cx-vpc-onprem-dc2-vpn-cx-vpc-transit-am-02" {
  name       = "if-cx-vpc-onprem-dc2-vpn-cx-vpc-transit-am-02"
  router     = google_compute_router.cr-cx-vpc-onprem-dc2-use4.name
  region     = "us-east4"
  project    = local.project_id
  ip_range   = "169.254.1.22/30"
  vpn_tunnel = google_compute_vpn_tunnel.cx-vpc-onprem-dc2-vpn-cx-vpc-transit-am-02.name
}

resource "google_compute_router_peer" "peer-cx-vpc-onprem-dc2-vpn-cx-vpc-transit-am-02" {
  name                      = "peer-cx-vpc-onprem-dc2-vpn-cx-vpc-transit-am-02"
  router                    = google_compute_router.cr-cx-vpc-onprem-dc2-use4.name
  region                    = "us-east4"
  project                   = local.project_id
  peer_asn                  = google_compute_router.cr-cx-vpc-transit-am-use4.bgp[0].asn
  peer_ip_address           = "169.254.1.21"
  advertised_route_priority = 100
  advertise_mode            = "CUSTOM"
  advertised_groups         = ["ALL_SUBNETS"]
  advertised_ip_ranges {
    range       = "10.0.0.0/8"
    description = "On premises supernet to GCP"
  }
  # advertised_ip_ranges {
  #   range       = "172.16.0.0/12"
  #   description = "PSC Subnet"
  # }
  interface       = google_compute_router_interface.if-cx-vpc-onprem-dc2-vpn-cx-vpc-transit-am-02.name
  export_policies = ["secondary-dc-route-policy"]
}

################################################ cx-vpc-transit-eu euw3 to cx-vpc-onprem-dc3 ################################################

######################## Tunnel 1 ########################
######################## ----->>> ########################

resource "google_compute_vpn_tunnel" "cx-vpc-transit-eu-vpn-cx-vpc-onprem-dc3-01" {
  name                  = "cx-vpc-transit-eu-vpn-cx-vpc-onprem-dc3-01"
  vpn_gateway           = google_compute_ha_vpn_gateway.vpngw-cx-vpc-transit-eu-euw3.id
  vpn_gateway_interface = 0
  peer_gcp_gateway      = google_compute_ha_vpn_gateway.vpngw-cx-vpc-onprem-dc3-euw3.id
  shared_secret         = "abcd1234"
  project               = local.project_id
  region                = "europe-west3"
  router                = google_compute_router.cr-cx-vpc-transit-eu-euw3.name
}

resource "google_compute_router_interface" "if-cx-vpc-transit-eu-vpn-cx-vpc-onprem-dc3-01" {
  name       = "if-cx-vpc-transit-eu-vpn-cx-vpc-onprem-dc3-01"
  router     = google_compute_router.cr-cx-vpc-transit-eu-euw3.name
  region     = "europe-west3"
  project    = local.project_id
  ip_range   = "169.254.1.9/30"
  vpn_tunnel = google_compute_vpn_tunnel.cx-vpc-transit-eu-vpn-cx-vpc-onprem-dc3-01.name
}

resource "google_compute_router_peer" "peer-cx-vpc-transit-eu-vpn-cx-vpc-onprem-dc3-01" {
  name                      = "peer-cx-vpc-transit-eu-vpn-cx-vpc-onprem-dc3-01"
  router                    = google_compute_router.cr-cx-vpc-transit-eu-euw3.name
  region                    = "europe-west3"
  project                   = local.project_id
  peer_asn                  = google_compute_router.cr-cx-vpc-onprem-dc3-euw3.bgp[0].asn
  peer_ip_address           = "169.254.1.10"
  advertised_route_priority = 100
  interface                 = google_compute_router_interface.if-cx-vpc-transit-eu-vpn-cx-vpc-onprem-dc3-01.name
}

######################## <<<----- ########################

resource "google_compute_vpn_tunnel" "cx-vpc-onprem-dc3-vpn-cx-vpc-transit-eu-01" {
  name                  = "cx-vpc-onprem-dc3-vpn-cx-vpc-transit-eu-01"
  vpn_gateway           = google_compute_ha_vpn_gateway.vpngw-cx-vpc-onprem-dc3-euw3.id
  vpn_gateway_interface = 0
  peer_gcp_gateway      = google_compute_ha_vpn_gateway.vpngw-cx-vpc-transit-eu-euw3.id
  shared_secret         = "abcd1234"
  project               = local.project_id
  region                = "europe-west3"
  router                = google_compute_router.cr-cx-vpc-onprem-dc3-euw3.name
}

resource "google_compute_router_interface" "if-cx-vpc-onprem-dc3-vpn-cx-vpc-transit-eu-01" {
  name       = "if-cx-vpc-onprem-dc3-vpn-cx-vpc-transit-eu-01"
  router     = google_compute_router.cr-cx-vpc-onprem-dc3-euw3.name
  region     = "europe-west3"
  project    = local.project_id
  ip_range   = "169.254.1.10/30"
  vpn_tunnel = google_compute_vpn_tunnel.cx-vpc-onprem-dc3-vpn-cx-vpc-transit-eu-01.name
}

resource "google_compute_router_peer" "peer-cx-vpc-onprem-dc3-vpn-cx-vpc-transit-eu-01" {
  name                      = "peer-cx-vpc-onprem-dc3-vpn-cx-vpc-transit-eu-01"
  router                    = google_compute_router.cr-cx-vpc-onprem-dc3-euw3.name
  region                    = "europe-west3"
  project                   = local.project_id
  peer_asn                  = google_compute_router.cr-cx-vpc-transit-eu-euw3.bgp[0].asn
  peer_ip_address           = "169.254.1.9"
  advertised_route_priority = 100
  advertise_mode            = "CUSTOM"
  advertised_groups         = ["ALL_SUBNETS"]
  #   advertised_ip_ranges {
  #     range       = "10.0.0.0/8"
  #     description = "On premises supernet to GCP"
  #   }
  interface = google_compute_router_interface.if-cx-vpc-onprem-dc3-vpn-cx-vpc-transit-eu-01.name
}

######################## Tunnel 2 ########################
######################## ----->>> ########################

resource "google_compute_vpn_tunnel" "cx-vpc-transit-eu-vpn-cx-vpc-onprem-dc3-02" {
  name                  = "cx-vpc-transit-eu-vpn-cx-vpc-onprem-dc3-02"
  vpn_gateway           = google_compute_ha_vpn_gateway.vpngw-cx-vpc-transit-eu-euw3.id
  vpn_gateway_interface = 1
  peer_gcp_gateway      = google_compute_ha_vpn_gateway.vpngw-cx-vpc-onprem-dc3-euw3.id
  shared_secret         = "abcd1234"
  project               = local.project_id
  region                = "europe-west3"
  router                = google_compute_router.cr-cx-vpc-transit-eu-euw3.name
}

resource "google_compute_router_interface" "if-cx-vpc-transit-eu-vpn-cx-vpc-onprem-dc3-02" {
  name       = "if-cx-vpc-transit-eu-vpn-cx-vpc-onprem-dc3-02"
  router     = google_compute_router.cr-cx-vpc-transit-eu-euw3.name
  region     = "europe-west3"
  project    = local.project_id
  ip_range   = "169.254.1.25/30"
  vpn_tunnel = google_compute_vpn_tunnel.cx-vpc-transit-eu-vpn-cx-vpc-onprem-dc3-02.name
}

resource "google_compute_router_peer" "peer-cx-vpc-transit-eu-vpn-cx-vpc-onprem-dc3-02" {
  name                      = "peer-cx-vpc-transit-eu-vpn-cx-vpc-onprem-dc3-02"
  router                    = google_compute_router.cr-cx-vpc-transit-eu-euw3.name
  region                    = "europe-west3"
  project                   = local.project_id
  peer_asn                  = google_compute_router.cr-cx-vpc-onprem-dc3-euw3.bgp[0].asn
  peer_ip_address           = "169.254.1.26"
  advertised_route_priority = 100
  interface                 = google_compute_router_interface.if-cx-vpc-transit-eu-vpn-cx-vpc-onprem-dc3-02.name
}

######################## <<<----- ########################

resource "google_compute_vpn_tunnel" "cx-vpc-onprem-dc3-vpn-cx-vpc-transit-eu-02" {
  name                  = "cx-vpc-onprem-dc3-vpn-cx-vpc-transit-eu-02"
  vpn_gateway           = google_compute_ha_vpn_gateway.vpngw-cx-vpc-onprem-dc3-euw3.id
  vpn_gateway_interface = 1
  peer_gcp_gateway      = google_compute_ha_vpn_gateway.vpngw-cx-vpc-transit-eu-euw3.id
  shared_secret         = "abcd1234"
  project               = local.project_id
  region                = "europe-west3"
  router                = google_compute_router.cr-cx-vpc-onprem-dc3-euw3.name
}

resource "google_compute_router_interface" "if-cx-vpc-onprem-dc3-vpn-cx-vpc-transit-eu-02" {
  name       = "if-cx-vpc-onprem-dc3-vpn-cx-vpc-transit-eu-02"
  router     = google_compute_router.cr-cx-vpc-onprem-dc3-euw3.name
  region     = "europe-west3"
  project    = local.project_id
  ip_range   = "169.254.1.26/30"
  vpn_tunnel = google_compute_vpn_tunnel.cx-vpc-onprem-dc3-vpn-cx-vpc-transit-eu-02.name
}

resource "google_compute_router_peer" "peer-cx-vpc-onprem-dc3-vpn-cx-vpc-transit-eu-02" {
  name                      = "peer-cx-vpc-onprem-dc3-vpn-cx-vpc-transit-eu-02"
  router                    = google_compute_router.cr-cx-vpc-onprem-dc3-euw3.name
  region                    = "europe-west3"
  project                   = local.project_id
  peer_asn                  = google_compute_router.cr-cx-vpc-transit-eu-euw3.bgp[0].asn
  peer_ip_address           = "169.254.1.25"
  advertised_route_priority = 100
  advertise_mode            = "CUSTOM"
  advertised_groups         = ["ALL_SUBNETS"]
  #   advertised_ip_ranges {
  #     range       = "10.0.0.0/8"
  #     description = "On premises supernet to GCP"
  #   }
  interface = google_compute_router_interface.if-cx-vpc-onprem-dc3-vpn-cx-vpc-transit-eu-02.name
}

################################################ cx-vpc-transit-eu euw4 to cx-vpc-onprem-dc4 ################################################

######################## Tunnel 1 ########################
######################## ----->>> ########################

resource "google_compute_vpn_tunnel" "cx-vpc-transit-eu-vpn-cx-vpc-onprem-dc4-01" {
  name                  = "cx-vpc-transit-eu-vpn-cx-vpc-onprem-dc4-01"
  vpn_gateway           = google_compute_ha_vpn_gateway.vpngw-cx-vpc-transit-eu-euw4.id
  vpn_gateway_interface = 0
  peer_gcp_gateway      = google_compute_ha_vpn_gateway.vpngw-cx-vpc-onprem-dc4-euw4.id
  shared_secret         = "abcd1234"
  project               = local.project_id
  region                = "europe-west4"
  router                = google_compute_router.cr-cx-vpc-transit-eu-euw4.name
}

resource "google_compute_router_interface" "if-cx-vpc-transit-eu-vpn-cx-vpc-onprem-dc4-01" {
  name       = "if-cx-vpc-transit-eu-vpn-cx-vpc-onprem-dc4-01"
  router     = google_compute_router.cr-cx-vpc-transit-eu-euw4.name
  region     = "europe-west4"
  project    = local.project_id
  ip_range   = "169.254.1.13/30"
  vpn_tunnel = google_compute_vpn_tunnel.cx-vpc-transit-eu-vpn-cx-vpc-onprem-dc4-01.name
}

resource "google_compute_router_peer" "peer-cx-vpc-transit-eu-vpn-cx-vpc-onprem-dc4-01" {
  name                      = "peer-cx-vpc-transit-eu-vpn-cx-vpc-onprem-dc4-01"
  router                    = google_compute_router.cr-cx-vpc-transit-eu-euw4.name
  region                    = "europe-west4"
  project                   = local.project_id
  peer_asn                  = google_compute_router.cr-cx-vpc-onprem-dc4-euw4.bgp[0].asn
  peer_ip_address           = "169.254.1.14"
  advertised_route_priority = 100
  interface                 = google_compute_router_interface.if-cx-vpc-transit-eu-vpn-cx-vpc-onprem-dc4-01.name
}

######################## <<<----- ########################

resource "google_compute_vpn_tunnel" "cx-vpc-onprem-dc4-vpn-cx-vpc-transit-eu-01" {
  name                  = "cx-vpc-onprem-dc4-vpn-cx-vpc-transit-eu-01"
  vpn_gateway           = google_compute_ha_vpn_gateway.vpngw-cx-vpc-onprem-dc4-euw4.id
  vpn_gateway_interface = 0
  peer_gcp_gateway      = google_compute_ha_vpn_gateway.vpngw-cx-vpc-transit-eu-euw4.id
  shared_secret         = "abcd1234"
  project               = local.project_id
  region                = "europe-west4"
  router                = google_compute_router.cr-cx-vpc-onprem-dc4-euw4.name
}

resource "google_compute_router_interface" "if-cx-vpc-onprem-dc4-vpn-cx-vpc-transit-eu-01" {
  name       = "if-cx-vpc-onprem-dc4-vpn-cx-vpc-transit-eu-01"
  router     = google_compute_router.cr-cx-vpc-onprem-dc4-euw4.name
  region     = "europe-west4"
  project    = local.project_id
  ip_range   = "169.254.1.14/30"
  vpn_tunnel = google_compute_vpn_tunnel.cx-vpc-onprem-dc4-vpn-cx-vpc-transit-eu-01.name
}

resource "google_compute_router_peer" "peer-cx-vpc-onprem-dc4-vpn-cx-vpc-transit-eu-01" {
  name                      = "peer-cx-vpc-onprem-dc4-vpn-cx-vpc-transit-eu-01"
  router                    = google_compute_router.cr-cx-vpc-onprem-dc4-euw4.name
  region                    = "europe-west4"
  project                   = local.project_id
  peer_asn                  = google_compute_router.cr-cx-vpc-transit-eu-euw4.bgp[0].asn
  peer_ip_address           = "169.254.1.13"
  advertised_route_priority = 100
  advertise_mode            = "CUSTOM"
  advertised_groups         = ["ALL_SUBNETS"]
  #   advertised_ip_ranges {
  #     range       = "10.0.0.0/8"
  #     description = "On premises supernet to GCP"
  #   }
  interface       = google_compute_router_interface.if-cx-vpc-onprem-dc4-vpn-cx-vpc-transit-eu-01.name
  export_policies = ["secondary-dc-route-policy"]
}

######################## Tunnel 2 ########################
######################## ----->>> ########################

resource "google_compute_vpn_tunnel" "cx-vpc-transit-eu-vpn-cx-vpc-onprem-dc4-02" {
  name                  = "cx-vpc-transit-eu-vpn-cx-vpc-onprem-dc4-02"
  vpn_gateway           = google_compute_ha_vpn_gateway.vpngw-cx-vpc-transit-eu-euw4.id
  vpn_gateway_interface = 1
  peer_gcp_gateway      = google_compute_ha_vpn_gateway.vpngw-cx-vpc-onprem-dc4-euw4.id
  shared_secret         = "abcd1234"
  project               = local.project_id
  region                = "europe-west4"
  router                = google_compute_router.cr-cx-vpc-transit-eu-euw4.name
}

resource "google_compute_router_interface" "if-cx-vpc-transit-eu-vpn-cx-vpc-onprem-dc4-02" {
  name       = "if-cx-vpc-transit-eu-vpn-cx-vpc-onprem-dc4-02"
  router     = google_compute_router.cr-cx-vpc-transit-eu-euw4.name
  region     = "europe-west4"
  project    = local.project_id
  ip_range   = "169.254.1.29/30"
  vpn_tunnel = google_compute_vpn_tunnel.cx-vpc-transit-eu-vpn-cx-vpc-onprem-dc4-02.name
}

resource "google_compute_router_peer" "peer-cx-vpc-transit-eu-vpn-cx-vpc-onprem-dc4-02" {
  name                      = "peer-cx-vpc-transit-eu-vpn-cx-vpc-onprem-dc4-02"
  router                    = google_compute_router.cr-cx-vpc-transit-eu-euw4.name
  region                    = "europe-west4"
  project                   = local.project_id
  peer_asn                  = google_compute_router.cr-cx-vpc-onprem-dc4-euw4.bgp[0].asn
  peer_ip_address           = "169.254.1.30"
  advertised_route_priority = 100
  interface                 = google_compute_router_interface.if-cx-vpc-transit-eu-vpn-cx-vpc-onprem-dc4-02.name
}

######################## <<<----- ########################

resource "google_compute_vpn_tunnel" "cx-vpc-onprem-dc4-vpn-cx-vpc-transit-eu-02" {
  name                  = "cx-vpc-onprem-dc4-vpn-cx-vpc-transit-eu-02"
  vpn_gateway           = google_compute_ha_vpn_gateway.vpngw-cx-vpc-onprem-dc4-euw4.id
  vpn_gateway_interface = 1
  peer_gcp_gateway      = google_compute_ha_vpn_gateway.vpngw-cx-vpc-transit-eu-euw4.id
  shared_secret         = "abcd1234"
  project               = local.project_id
  region                = "europe-west4"
  router                = google_compute_router.cr-cx-vpc-onprem-dc4-euw4.name
}

resource "google_compute_router_interface" "if-cx-vpc-onprem-dc4-vpn-cx-vpc-transit-eu-02" {
  name       = "if-cx-vpc-onprem-dc4-vpn-cx-vpc-transit-eu-02"
  router     = google_compute_router.cr-cx-vpc-onprem-dc4-euw4.name
  region     = "europe-west4"
  project    = local.project_id
  ip_range   = "169.254.1.30/30"
  vpn_tunnel = google_compute_vpn_tunnel.cx-vpc-onprem-dc4-vpn-cx-vpc-transit-eu-02.name
}

resource "google_compute_router_peer" "peer-cx-vpc-onprem-dc4-vpn-cx-vpc-transit-eu-02" {
  name                      = "peer-cx-vpc-onprem-dc4-vpn-cx-vpc-transit-eu-02"
  router                    = google_compute_router.cr-cx-vpc-onprem-dc4-euw4.name
  region                    = "europe-west4"
  project                   = local.project_id
  peer_asn                  = google_compute_router.cr-cx-vpc-transit-eu-euw4.bgp[0].asn
  peer_ip_address           = "169.254.1.29"
  advertised_route_priority = 100
  advertise_mode            = "CUSTOM"
  advertised_groups         = ["ALL_SUBNETS"]
  #   advertised_ip_ranges {
  #     range       = "10.0.0.0/8"
  #     description = "On premises supernet to GCP"
  #   }
  interface       = google_compute_router_interface.if-cx-vpc-onprem-dc4-vpn-cx-vpc-transit-eu-02.name
  export_policies = ["secondary-dc-route-policy"]
}