# gcp-nw-demo

#TO-DO: note all GCE VM IPs in the psa psc diagram are ephemeral, I will reserve static IPs eventually but for now true up with the IP created for the VMs.

## Architecture

1. VPC, NCC Overview
<img src="images/ncc.png" width="100%">

2. PSA, PSC based connectivity
<img src="images/psapsc.png">

3. Cloud DNS
<img src="images/dns.png" width="100%">

# Apply in following order:

1. VPC
2. VPN (optionally routepolicy after this)
3. NCC
4. PSC
5. PSA