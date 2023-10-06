output "SIC_key" {
  value = var.sicKey
}
output "ManagementIP" {
  value = module.management.mgmt_ext_ip
}
output "GW_B_IP" {
  value = google_compute_address.staticB.address
}
output "GW_A_IP" {
  value = google_compute_address.staticA.address
}
/* 
output "spoke1-vm-1" {
    value = google_compute_instance.spoke1-vm-1.network_interface[0].access_config[0].nat_ip
}

output "spoke2-vm-1" {
    value = google_compute_instance.spoke2-vm-1.network_interface[0].access_config[0].nat_ip
}
*/