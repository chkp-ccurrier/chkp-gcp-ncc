resource "google_compute_address" "addr_intf_0" {
  name         = "gwa-interface-addr"
  region       = var.region
  subnetwork   = var.subnetwork[0]
  address_type = "INTERNAL"
  address      = "${var.new_subnet_0_str[0]}250"
  depends_on = [ 
                google_compute_network.new_net_0,
                google_compute_network.new_net_1,
                google_compute_subnetwork.new_subnet_0,
                google_compute_subnetwork.new_subnet_1
  ]
}
resource "google_compute_address" "addr_intf_01" {
  name         = "gwa1-interface-addr"
  region       = var.region
  subnetwork   = var.subnetwork[0]
  address_type = "INTERNAL"
  address      = "${var.new_subnet_0_str[0]}251"
  depends_on = [ 
                google_compute_network.new_net_0,
                google_compute_network.new_net_1,
                google_compute_subnetwork.new_subnet_0,
                google_compute_subnetwork.new_subnet_1
  ]
}
resource "google_network_connectivity_hub" "new_ncc" {
  project     = var.project
  name        = var.ncc_hub_name
  description = "Created by Check Point NCC module."

  depends_on = [ google_compute_network.new_net_0,
                google_compute_network.new_net_1,
                google_compute_instance.gatewayA,
                google_compute_instance.gatewayB
               ]
}
resource "google_network_connectivity_spoke" "chkp1" {
  project  = var.project
  name     = "${var.ncc_hub_name}-spoke-chkp-1"
  location = var.region
  hub      = google_network_connectivity_hub.new_ncc.id
linked_router_appliance_instances {
    instances {
        virtual_machine = google_compute_instance.gatewayA.self_link
        ip_address = google_compute_instance.gatewayA.network_interface.0.network_ip
    }
    site_to_site_data_transfer = true
  }
  depends_on = [ google_compute_network.new_net_0,
                google_compute_network.new_net_1,
                google_compute_instance.gatewayA,
                google_network_connectivity_hub.new_ncc
              ]
}

module "cloud_router1" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 5.1"

  name    = "spoke1-router"
  project = var.project
  region  = var.region
  network = var.network[0]
  bgp = {
    asn               = 65000
    advertised_groups = ["ALL_SUBNETS"]
  }
  depends_on = [
    google_compute_network.new_net_0
  ]
}

resource "google_compute_router_interface" "routeriface_1" {
  name        = "gwa-interface"
  router      = "spoke1-router"
  region      = var.region
  project     = var.project
  private_ip_address = google_compute_address.addr_intf_0.address
  subnetwork  = google_compute_subnetwork.new_subnet_0.self_link
  depends_on = [
    google_compute_address.addr_intf_0,
    google_compute_network.new_net_0,
    google_compute_subnetwork.new_subnet_0
  ]
}
resource "google_compute_router_interface" "routeriface_1a" {
  name        = "gwa1-interface"
  router      = "spoke1-router"
  region      = var.region
  project     = var.project
  private_ip_address = google_compute_address.addr_intf_01.address
  subnetwork  = google_compute_subnetwork.new_subnet_0.self_link
  redundant_interface = google_compute_router_interface.routeriface_1.name
  depends_on = [ 
    google_compute_address.addr_intf_0,
    google_compute_network.new_net_0,
    google_compute_subnetwork.new_subnet_0
  ]
}

resource "google_compute_router_peer" "peer1a" {
  name                      = "peera-1"
  router                    = "spoke1-router"
  region                    = var.region
  interface                 = google_compute_router_interface.routeriface_1.name
  router_appliance_instance = google_compute_instance.gatewayA.self_link
  peer_asn                  = 65001
  peer_ip_address           = "${var.new_subnet_0_str[0]}${var.ha_vip}"
  depends_on = [
    google_compute_instance.gatewayA,
    google_compute_router_interface.routeriface_1
  ]
}
resource "google_compute_router_peer" "peer1b" {
  name                      = "peera-2"
  router                    = "spoke1-router"
  region                    = var.region
  interface                 = google_compute_router_interface.routeriface_1a.name
  router_appliance_instance = google_compute_instance.gatewayA.self_link
  peer_asn                  = 65001
  peer_ip_address           = "${var.new_subnet_0_str[0]}${var.ha_vip}"
  depends_on = [
    google_compute_instance.gatewayA,
    google_compute_router_interface.routeriface_2
  ]
}
