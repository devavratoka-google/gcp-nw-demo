// Creates BGP Route Policy for dc2 and dc4 cloud routers

################################################ cx-vpc-onprem-dc2 ################################################

// Route Policy
resource "google_compute_router_route_policy" "cr-cx-vpc-onprem-dc2-use4-export" {
  depends_on = [google_compute_router.cr-cx-vpc-onprem-dc2-use4]
  router     = google_compute_router.cr-cx-vpc-onprem-dc2-use4.name
  region     = google_compute_router.cr-cx-vpc-onprem-dc2-use4.region
  project    = google_compute_router.cr-cx-vpc-onprem-dc2-use4.project
  name       = "secondary-dc-route-policy" // "${google_compute_router.cr-cx-vpc-onprem-dc2-use4.name}-export-policy"
  type       = "ROUTE_POLICY_TYPE_EXPORT"
  terms {
    // Add community tag
    priority = 1
    match {
      expression = "destination.inAnyRange(prefix('10.0.0.0/8'))"
    }
    actions {
      expression = "communities.replaceAll(['64532:1234'])"
    }
  }
  terms {
    // as-path prepend
    priority = 2
    match {
      expression = "destination.inAnyRange(prefix('10.0.0.0/8'))"
    }
    actions {
      expression = "asPath.prependSequence([64532, 64532, 64532])"
    }
  }
}

################################################ cx-vpc-onprem-dc4 ################################################

// Route Policy
resource "google_compute_router_route_policy" "cr-cx-vpc-onprem-dc4-euw4-export" {
  depends_on = [google_compute_router.cr-cx-vpc-onprem-dc4-euw4]
  router     = google_compute_router.cr-cx-vpc-onprem-dc4-euw4.name
  region     = google_compute_router.cr-cx-vpc-onprem-dc4-euw4.region
  project    = google_compute_router.cr-cx-vpc-onprem-dc4-euw4.project
  name       = "secondary-dc-route-policy" // "${google_compute_router.cr-cx-vpc-onprem-dc4-euw4.name}-export-policy"
  type       = "ROUTE_POLICY_TYPE_EXPORT"
  terms {
    // Add community tag
    priority = 1
    match {
      expression = "destination.inAnyRange(prefix('10.0.0.0/8'))"
    }
    actions {
      expression = "communities.replaceAll(['64534:13104'])"
    }
  }
  terms {
    // as-path prepend
    priority = 2
    match {
      expression = "destination.inAnyRange(prefix('10.0.0.0/8'))"
    }
    actions {
      expression = "asPath.prependSequence([64534, 64534, 64534])"
    }
  }
}