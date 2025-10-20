// Creates Cloud DNS private zones and record sets

// DNS testing
// dig +short vm-cx-vpc-infra-am.cx-vpc-infra-am.com.
// dig +short vm-cx-vpc-infra-eu.cx-vpc-infra-eu.com.
// dig +short vm-dc1.cx-vpc-onprem.com.
// dig +short vm-dc3.cx-vpc-onprem.com.

################################################ Option 1 ################################################

// Creating private DNS zone for cx-vpc-infra-am

// Cloud DNS Private Zone
resource "google_dns_managed_zone" "cx-vpc-infra-am" {
  project     = local.project_id
  name        = "cx-vpc-infra-am"
  dns_name    = "cx-vpc-infra-am.com."
  description = "cx-vpc-infra-am private zone"

  visibility = "private"

  private_visibility_config {
    networks {
      network_url = module.cx-vpc-infra-am.network_id
    }
  }
}

// Cloud DNS Private Zone Record Set
resource "google_dns_record_set" "rs-vm-cx-vpc-infra-am" {
  project      = local.project_id
  name         = "vm-cx-vpc-infra-am.${google_dns_managed_zone.cx-vpc-infra-am.dns_name}"
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.cx-vpc-infra-am.name
  rrdatas      = [google_compute_instance_from_template.vm-cx-vpc-infra-am.network_interface[0].network_ip]
}

// Creating private DNS zone for cx-vpc-infra-eu

// Cloud DNS Private Zone
resource "google_dns_managed_zone" "cx-vpc-infra-eu" {
  project     = local.project_id
  name        = "cx-vpc-infra-eu"
  dns_name    = "cx-vpc-infra-eu.com."
  description = "cx-vpc-infra-eu private zone"

  visibility = "private"

  private_visibility_config {
    networks {
      network_url = module.cx-vpc-infra-eu.network_id
    }
  }
}

// Cloud DNS Private Zone Record Set
resource "google_dns_record_set" "rs-vm-cx-vpc-infra-eu" {
  project      = local.project_id
  name         = "vm-cx-vpc-infra-eu.${google_dns_managed_zone.cx-vpc-infra-eu.dns_name}"
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.cx-vpc-infra-eu.name
  rrdatas      = [google_compute_instance_from_template.vm-cx-vpc-infra-eu.network_interface[0].network_ip]
}

// Creating a peering zone from cx-vpc-infra-am to cx-vpc-infra-eu

// Cloud DNS Peering Zone
resource "google_dns_managed_zone" "peering-zone-am-eu" {
  project     = local.project_id
  name        = "peering-zone-am-eu"
  dns_name    = google_dns_managed_zone.cx-vpc-infra-eu.dns_name
  description = "AM EU Peering Zone"
  visibility  = "private"
  private_visibility_config {
    networks {
      network_url = module.cx-vpc-infra-am.network_id
    }
  }
  peering_config {
    target_network {
      network_url = module.cx-vpc-infra-eu.network_id
    }
  }
}

// Creating a peering zone from cx-vpc-infra-eu to cx-vpc-infra-am

// Cloud DNS Peering Zone
resource "google_dns_managed_zone" "peering-zone-eu-am" {
  project     = local.project_id
  name        = "peering-zone-eu-am"
  dns_name    = google_dns_managed_zone.cx-vpc-infra-am.dns_name
  description = "EU AM Peering Zone"
  visibility  = "private"
  private_visibility_config {
    networks {
      network_url = module.cx-vpc-infra-eu.network_id
    }
  }
  peering_config {
    target_network {
      network_url = module.cx-vpc-infra-am.network_id
    }
  }
}

################################################ Option 2 ################################################

// Both DC1 and DC3 VPCs share same private DNS zone 'cx-vpc-onprem.com.'
// vm-dc1 and vm-dc3 added as records in the zone.

// Cloud DNS Private Zone
resource "google_dns_managed_zone" "cx-vpc-onprem" {
  project     = local.project_id
  name        = "cx-vpc-onprem"
  dns_name    = "cx-vpc-onprem.com."
  description = "cx-vpc-onprem private zone"

  visibility = "private"

  private_visibility_config {
    networks {
      network_url = module.cx-vpc-onprem-dc1.network_id
    }
    networks {
      network_url = module.cx-vpc-onprem-dc2.network_id
    }
    networks {
      network_url = module.cx-vpc-onprem-dc3.network_id
    }
    networks {
      network_url = module.cx-vpc-onprem-dc4.network_id
    }
  }
}

// Cloud DNS Private Zone Record Set
resource "google_dns_record_set" "rs-vm-cx-vpc-onprem-dc1" {
  project      = local.project_id
  name         = "vm-dc1.${google_dns_managed_zone.cx-vpc-onprem.dns_name}"
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.cx-vpc-onprem.name
  rrdatas      = [google_compute_instance_from_template.vm-cx-vpc-onprem-dc1.network_interface[0].network_ip]
}

// Cloud DNS Private Zone Record Set
resource "google_dns_record_set" "rs-vm-cx-vpc-onprem-dc3" {
  project      = local.project_id
  name         = "vm-dc3.${google_dns_managed_zone.cx-vpc-onprem.dns_name}"
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.cx-vpc-onprem.name
  rrdatas      = [google_compute_instance_from_template.vm-cx-vpc-onprem-dc3.network_interface[0].network_ip]
}
