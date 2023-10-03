locals {
  asg = var.asg == "yes" ? 0 : 1
  ha = var.ha == "yes" ? 0 : 1
  server = var.server == "yes" ? 0 : 1
  license_allowed_values = [
    "BYOL",
    "PAYG"]
  // will fail if [var.license] is invalid:
  validate_license = index(local.license_allowed_values, upper(var.license))

  installation_type_allowed_values = [
    "Gateway only",
    "Management only",
    "Cluster",
    "Standalone"
  ]
  // Will fail if the installation type is none of the above
  validate_installation_type = index(local.installation_type_allowed_values, var.installationType)

  regex_validate_mgmt_image_name = "check-point-r8[0-1][1-4]0-(byol|payg)-[0-9]{3}-([0-9]{3,}|[a-z]+)-v[0-9]{8,}"
  regex_validate_single_image_name = "check-point-r8[0-1][1-4]0-gw-(byol|payg)-single-[0-9]{3}-([0-9]{3,}|[a-z]+)-v[0-9]{8,}"
  // will fail if the image name is not in the right syntax
//  validate_image_name = var.installationType != "Gateway only" && length(regexall(local.regex_validate_mgmt_image_name, var.image_name)) > 0 ? 0 : (var.installationType == "Gateway only" && length(regexall(local.regex_validate_single_image_name, var.image_name)) > 0 ? 0 : index(split("-", var.image_name), "INVALID IMAGE NAME"))
  regex_valid_admin_SSH_key = "^(^$|ssh-rsa AAAA[0-9A-Za-z+/]+[=]{0,3})"
  // Will fail if var.admin_SSH_key is invalid
  regex_admin_SSH_key = regex(local.regex_valid_admin_SSH_key, var.admin_SSH_key) == var.admin_SSH_key ? 0 : "Please enter a valid SSH public key or leave empty"
  admin_shell_allowed_values = [
    "/etc/cli.sh",
    "/bin/bash",
    "/bin/csh",
    "/bin/tcsh"]
  // Will fail if var.admin_shell is invalid
  validate_admin_shell = index(local.admin_shell_allowed_values, var.admin_shell)
  disk_type_allowed_values = [
    "SSD Persistent Disk",
    "Balanced Persistent Disk",
    "Standard Persistent Disk"]
  // Will fail if var.disk_type is invalid
  validate_disk_type = index(local.disk_type_allowed_values, var.diskType)
  adminPasswordSourceMetadata = var.generatePassword ?random_string.generated_password.result : ""
  disk_type_condition = var.diskType == "SSD Persistent Disk" ? "pd-ssd" : var.diskType == "Balanced Persistent Disk" ? "pd-balanced" : var.diskType == "Standard Persistent Disk" ? "pd-standard" : ""
  admin_SSH_key_condition = var.admin_SSH_key != "" ? true : false
  ICMP_traffic_condition = length(var.network_icmpSourceRanges	) == 0 ? 0 : 1
  TCP_traffic_condition = length(var.network_tcpSourceRanges) == 0 ? 0 : 1
  UDP_traffic_condition = length(var.network_udpSourceRanges	) == 0 ? 0 : 1
  SCTP_traffic_condition = length(var.network_sctpSourceRanges) == 0 ? 0 : 1
  ESP_traffic_condition = length(var.network_espSourceRanges) == 0 ? 0 : 1

//HA Stuff
  //create_cluster_network_condition = var.cluster_network_subnetwork == "" ? false : true
  //create_mgmt_network_condition = var.mgmt_network_name == "" ? false : true
  create_internal_network1_condition = var.internal_network1_subnetwork == "" ? false : true
  create_internal_network2_condition = var.internal_network2_subnetwork == "" && var.num_internal_networks >= 2 ? false : true
  create_internal_network3_condition = var.internal_network3_subnetwork == "" && var.num_internal_networks >= 3 ? false : true
  create_internal_network4_condition = var.internal_network4_subnetwork == "" && var.num_internal_networks >= 4 ? false : true
  create_internal_network5_condition = var.internal_network5_subnetwork == "" && var.num_internal_networks >= 5 ? false : true
  create_internal_network6_condition = var.internal_network6_subnetwork == "" && var.num_internal_networks == 6 ? false : true
  /*cluster_ICMP_traffic_condition = length(var.cluster_ICMP_traffic) == 0 ? 0 : 1
  cluster_TCP_traffic_condition = length(var.cluster_TCP_traffic) == 0 ? 0 : 1
  cluster_UDP_traffic_condition = length(var.cluster_UDP_traffic) == 0 ? 0 : 1
  cluster_SCTP_traffic_condition = length(var.cluster_SCTP_traffic) == 0 ? 0 : 1
  cluster_ESP_traffic_condition = length(var.cluster_ESP_traffic) == 0 ? 0 : 1
  mgmt_ICMP_traffic_condition = length(var.mgmt_ICMP_traffic) == 0 ? 0 : 1
  mgmt_TCP_traffic_condition = length(var.mgmt_TCP_traffic) == 0 ? 0 : 1
  mgmt_UDP_traffic_condition = length(var.mgmt_UDP_traffic) == 0 ? 0 : 1
  mgmt_SCTP_traffic_condition = length(var.mgmt_SCTP_traffic) == 0 ? 0 : 1
  mgmt_ESP_traffic_condition = length(var.mgmt_ESP_traffic) == 0 ? 0 : 1
*/
}