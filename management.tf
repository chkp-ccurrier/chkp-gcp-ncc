
module "management" {
  source = "./mgmt"
  project                             = var.project
  service_account_path                = var.service_account_path
  naming_prefix                       = var.prefix
  image_name                          = var.mgmt_image_name
  mgmt_vpc                            = var.network[0]
  mgmt_subnet                         = var.subnetwork[0]
  installationType                    = "Management only"
  license                             = var.license
  prefix                              = var.prefix
  management_nic                      = "Ephemeral Public IP (eth0)"
  admin_shell                         = var.admin_shell
  generatePassword                    = false
  allowUploadDownload                 = true
  ssh_key                             = var.admin_SSH_key
  managementGUIClientNetwork          = "0.0.0.0/0"
  zone                                = var.zone
  externalIP                          = "static"
  mgmt_ip                             = "${var.new_subnet_0_str[0]}${var.mgmt_ip}"
  machine_type                        = var.machine_type
  diskType                            = var.diskType
  bootDiskSizeGb                      = var.bootDiskSizeGb
  enableMonitoring                    = false

  depends_on = [ 
                google_compute_instance.gatewayA,
                google_compute_instance.gatewayB,
                google_compute_network.new_net_0,
                google_compute_subnetwork.new_subnet_0
              ]
}