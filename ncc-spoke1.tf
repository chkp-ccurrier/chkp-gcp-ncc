resource "google_compute_address" "addr_intf_1" {
  name         = "gwb-interface-addr"
  region       = var.region
  subnetwork   = var.subnetwork[1]
  address_type = "INTERNAL"
  address      = "${var.new_subnet_1_str[0]}250"
  depends_on = [
              google_compute_network.new_net_0,
              google_compute_network.new_net_1,
              google_compute_subnetwork.new_subnet_0
  ]
}
resource "google_compute_address" "addr_intf_1a" {
  name         = "gwb1-interface-addr"
  region       = var.region
  subnetwork   = var.subnetwork[1]
  address_type = "INTERNAL"
  address      = "${var.new_subnet_1_str[0]}251"
  depends_on = [
              google_compute_network.new_net_0,
              google_compute_network.new_net_1,
              google_compute_subnetwork.new_subnet_0
  ]
}

resource "google_network_connectivity_spoke" "chkp2" {
  project  = var.project
  name     = "${var.ncc_hub_name}-spoke-chkp-2"
  location = var.region
  hub      = google_network_connectivity_hub.new_ncc.id
linked_router_appliance_instances {
    instances{
        virtual_machine = google_compute_instance.gatewayB.self_link
        ip_address = google_compute_instance.gatewayB.network_interface.0.network_ip
    }
    site_to_site_data_transfer = true
  }
  depends_on = [ google_compute_network.new_net_0,
                google_compute_instance.gatewayB,
                google_network_connectivity_hub.new_ncc
              ]
}

resource "google_compute_router_interface" "routeriface_2" {
  name        = "gwb-interface"
  router      = "spoke1-router"
  region      = var.region
  project     = var.project
  private_ip_address = google_compute_address.addr_intf_1.address
  subnetwork  = google_compute_subnetwork.new_subnet_01.self_link
  depends_on = [
    google_compute_address.addr_intf_1,
    google_compute_network.new_net_0,
    google_compute_subnetwork.new_subnet_02,
    google_compute_router_interface.routeriface_2
  ]
}

resource "google_compute_router_interface" "routeriface_2a" {
  name        = "gwb1-interface"
  router      = "spoke1-router"
  region      = var.region
  project     = var.project
  private_ip_address = google_compute_address.addr_intf_1a.address
  subnetwork  = google_compute_subnetwork.new_subnet_01.self_link
  redundant_interface = google_compute_router_interface.routeriface_2.name
  depends_on = [ 
    google_compute_address.addr_intf_1a,
    google_compute_network.new_net_0,
    google_compute_subnetwork.new_subnet_01,
    google_compute_router_interface.routeriface_2
  ]
}

resource "google_compute_router_peer" "peer2a" {
  name                      = "peerb-1"
  router                    = "spoke1-router"
  region                    = var.region
  interface                 = google_compute_router_interface.routeriface_2.name
  router_appliance_instance = google_compute_instance.gatewayB.self_link
  peer_asn                  = 65002
  peer_ip_address           = "${var.new_subnet_1_str[0]}${var.ha_vip}"
  depends_on = [
    google_compute_instance.gatewayB,
    google_compute_router_interface.routeriface_2
  ]
}
resource "google_compute_router_peer" "peer2b" {
  name                      = "peerb-2"
  router                    = "spoke1-router"
  region                    = var.region
  interface                 = google_compute_router_interface.routeriface_2a.name
  router_appliance_instance = google_compute_instance.gatewayB.self_link
  peer_asn                  = 65002
  peer_ip_address           = "${var.new_subnet_1_str[0]}${var.ha_vip}"
  depends_on = [
    google_compute_instance.gatewayB,
    google_compute_router_interface.routeriface_1a
  ]
}
