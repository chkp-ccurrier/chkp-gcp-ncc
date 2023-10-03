resource "random_string" "random_string" {
  length = 5
  special = false
  upper = false
  keepers = {}
}
resource "random_string" "generated_password" {
  length = 12
  special = false
}
resource "google_compute_instance" "manager" {
  name = "${var.prefix}-manager"
  description = "Check Point Security Management"
  zone = var.zone
  labels = {goog-dm = "${var.prefix}-manager"}
  tags =["${var.prefix}manager","mgmt"]
  machine_type = var.machine_type
  can_ip_forward = var.installationType == "Management only"? false:true
  boot_disk {
    auto_delete = true
    device_name = "${var.naming_prefix}-manager-disk"
    initialize_params {
      size = var.bootDiskSizeGb
      type = local.disk_type_condition
      image = "checkpoint-public/${var.image_name}"
    }
  }
  network_interface {
    network_ip = var.mgmt_ip 
    network = var.mgmt_vpc
    subnetwork = var.mgmt_subnet
    dynamic "access_config" {
      for_each = var.externalIP == "None"? []:[1]
      content {
        nat_ip = var.externalIP=="static" ? google_compute_address.staticmgmt.address : null
      }
    }

  }

  service_account {
    scopes = [
      "https://www.googleapis.com/auth/cloudruntimeconfig",
      "https://www.googleapis.com/auth/monitoring.write"]
  }

  metadata = local.admin_SSH_key_condition ? {
    instanceSSHKey = var.ssh_key
    adminPasswordSourceMetadata = var.generatePassword ?random_string.generated_password.result : ""
  } : {adminPasswordSourceMetadata = var.generatePassword?random_string.generated_password.result : ""}

  metadata_startup_script = templatefile("${path.module}/../mgmt-startup-script.sh", {
    // script's arguments
    generatePassword = var.generatePassword
    config_url = "https://runtimeconfig.googleapis.com/v1beta1/projects/${var.project}/configs/-config"
    config_path = "projects/${var.project}/configs/-config"
    allowUploadDownload = var.allowUploadDownload
    templateName = "mgmt_tf"
    templateVersion = "20230509"
    templateType = "terraform"
    hasInternet = "true"
    enableMonitoring = var.enableMonitoring
    shell = var.admin_shell
    installationType = var.installationType
    managementGUIClientNetwork = var.managementGUIClientNetwork
    installSecurityManagement = true
    subnet_router_meta_path = ""
    mgmtNIC = var.management_nic
    managementNetwork = var.mgmt_vpc
  })
}

resource "google_compute_address" "staticmgmt" {
  name = "mgmtipv4-address"
}
