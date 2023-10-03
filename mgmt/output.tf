output mgmt_ext_ip {
    value = try(google_compute_instance.manager.network_interface.0.access_config.0.nat_ip, "")
    description = "External IP of Chkp Manager"
}