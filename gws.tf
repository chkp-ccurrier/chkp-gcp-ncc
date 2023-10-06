resource "google_compute_instance" "gatewayA" {
  name = "${var.prefix}gw-a"
  description = "Check Point Security ${replace(var.installationType,"(Standalone)","--")==var.installationType?split(" ",var.installationType)[0]:" Gateway and Management"}"
  zone = var.zoneA
  labels = {goog-dm = "${var.prefix}-${random_string.random_string.result}"}
  tags =replace(var.installationType,"(Standalone)","--")==var.installationType?[
    "checkpoint-${split(" ",lower(var.installationType))[0]}","${var.prefix}${random_string.random_string.result}"
  ]:["checkpoint-gateway","checkpoint-management","${var.prefix}${random_string.random_string.result}"]
  machine_type = var.machine_type
  can_ip_forward = var.installationType == "Management only"? false:true
  boot_disk {
    auto_delete = true
    device_name = "chkp-single-boot-${random_string.random_string.result}"
    initialize_params {
      size = var.bootDiskSizeGb
      type = local.disk_type_condition
      image = "checkpoint-public/${var.image_name}"
    }
  }
  network_interface {
    network_ip = "${var.new_subnet_0_str[0]}${var.ha_vip}"
    network = var.network[0]
    subnetwork = var.subnetwork[0]
    dynamic "access_config" {
      for_each = var.externalIP == "None"? []:[1]
      content {
        nat_ip = var.externalIP=="static" ? google_compute_address.staticA.address : null
      }
    }
  }
  network_interface {
      network_ip = "${var.new_subnet_1_str[2]}${var.ha_vip}"
      network = var.internal_network1_network[0]
      subnetwork = var.internal_network1_subnetwork[0]
  }
  dynamic "network_interface" {
    for_each = var.numAdditionalNICs >= 2 ? [
      1] : []
    content {
      network = var.internal_network2_network[0]
      subnetwork = var.internal_network2_subnetwork[0]
    }
  }
  dynamic "network_interface" {
    for_each = var.numAdditionalNICs >= 3 ? [
      1] : []
    content {
      network = var.internal_network3_network[0]
      subnetwork = var.internal_network3_subnetwork[0]
    }
  }
  dynamic "network_interface" {
    for_each = var.numAdditionalNICs >= 4 ? [
      1] : []
    content {
      network = var.internal_network4_network[0]
      subnetwork = var.internal_network4_subnetwork[0]
    }
  }
  dynamic "network_interface" {
    for_each = var.numAdditionalNICs >= 5 ? [
      1] : []
    content {
      network = var.internal_network5_network[0]
      subnetwork = var.internal_network5_subnetwork[0]
    }
  }
  dynamic "network_interface" {
    for_each = var.numAdditionalNICs == 6 ? [
      1] : []
    content {
      network = var.internal_network6_network[0]
      subnetwork = var.internal_network6_subnetwork[0]
    }
  }
  dynamic "network_interface" {
    for_each = var.numAdditionalNICs == 7 ? [
      1] : []
    content {
      network = var.internal_network7_network[0]
      subnetwork = var.internal_network7_subnetwork[0]
    }
  }
  dynamic "network_interface" {
    for_each = var.numAdditionalNICs == 8 ? [
      1] : []
    content {
      network = var.internal_network8_network[0]
      subnetwork = var.internal_network8_subnetwork[0]
    }
  }

  service_account {
    scopes = [
      "https://www.googleapis.com/auth/cloudruntimeconfig",
      "https://www.googleapis.com/auth/monitoring.write"]
  }

  metadata = local.admin_SSH_key_condition ? {
    instanceSSHKey = var.admin_SSH_key
    adminPasswordSourceMetadata = var.generatePassword ?random_string.generated_password.result : ""
  } : {adminPasswordSourceMetadata = var.generatePassword?random_string.generated_password.result : ""}

  metadata_startup_script = templatefile("startup-script.sh", {
    // script's arguments
    generatePassword = var.generatePassword
    config_url = "https://runtimeconfig.googleapis.com/v1beta1/projects/${var.project}/configs/-config"
    config_path = "projects/${var.project}/configs/-config"
    sicKey = var.sicKey
    allowUploadDownload = var.allowUploadDownload
    templateName = "Single_tf"
    templateVersion = "20230622"
    templateType = "terraform"
    hasInternet = "true"
    enableMonitoring = var.enableMonitoring
    shell = var.admin_shell
    installationType = var.installationType
    computed_sic_key = var.sicKey
    managementGUIClientNetwork = var.managementGUIClientNetwork
    installSecurityManagement = false
    primary_cluster_address_name = ""
    secondary_cluster_address_name = ""
    subnet_router_meta_path = ""
    mgmtNIC = var.management_nic
    managementNetwork = var.managementGUIClientNetwork
    numAdditionalNICs = var.numAdditionalNICs
  })
  depends_on = [ google_compute_network.new_net_0,
                google_compute_network.new_net_1,
                google_compute_subnetwork.new_subnet_0,
                google_compute_subnetwork.new_subnet_1
   ]
}

resource "google_compute_address" "staticA" {
  name = "ipv4-address-a"
}

resource "google_compute_instance" "gatewayB" {
  name = "${var.prefix}gw-b"
  description = "Check Point Security ${replace(var.installationType,"(Standalone)","--")==var.installationType?split(" ",var.installationType)[0]:" Gateway and Management"}"
  zone = var.zoneB
  labels = {goog-dm = "${var.prefix}-${random_string.random_string.result}"}
  tags =replace(var.installationType,"(Standalone)","--")==var.installationType?[
    "checkpoint-${split(" ",lower(var.installationType))[0]}","${var.prefix}${random_string.random_string.result}"
  ]:["checkpoint-gateway","checkpoint-management","${var.prefix}${random_string.random_string.result}"]
  machine_type = var.machine_type
  can_ip_forward = var.installationType == "Management only"? false:true
  boot_disk {
    auto_delete = true
    device_name = "chkp-single-boot-${random_string.random_string.result}"
    initialize_params {
      size = var.bootDiskSizeGb
      type = local.disk_type_condition
      image = "checkpoint-public/${var.image_name}"
    }
  }
  network_interface {
      network_ip = "${var.new_subnet_1_str[0]}${var.ha_vip}"
      network = google_compute_network.new_net_0.name
      subnetwork = google_compute_subnetwork.new_subnet_01.name
    dynamic "access_config" {
      for_each = var.externalIP == "None"? []:[1]
      content {
        nat_ip = var.externalIP=="static" ? google_compute_address.staticB.address : null
      }
    }

  }
  network_interface {
      network_ip = "${var.new_subnet_1_str[1]}${var.ha_vip}"
      network = google_compute_network.new_net_1.name
      subnetwork = google_compute_subnetwork.new_subnet_2.name
  }
  dynamic "network_interface" {
    for_each = var.numAdditionalNICs >= 2 ? [
      1] : []
    content {
      network = var.internal_network2_network[0]
      subnetwork = var.internal_network2_subnetwork[0]
    }
  }
  dynamic "network_interface" {
    for_each = var.numAdditionalNICs >= 3 ? [
      1] : []
    content {
      network = var.internal_network3_network[0]
      subnetwork = var.internal_network3_subnetwork[0]
    }
  }
  dynamic "network_interface" {
    for_each = var.numAdditionalNICs >= 4 ? [
      1] : []
    content {
      network = var.internal_network4_network[0]
      subnetwork = var.internal_network4_subnetwork[0]
    }
  }
  dynamic "network_interface" {
    for_each = var.numAdditionalNICs >= 5 ? [
      1] : []
    content {
      network = var.internal_network5_network[0]
      subnetwork = var.internal_network5_subnetwork[0]
    }
  }
  dynamic "network_interface" {
    for_each = var.numAdditionalNICs == 6 ? [
      1] : []
    content {
      network = var.internal_network6_network[0]
      subnetwork = var.internal_network6_subnetwork[0]
    }
  }
  dynamic "network_interface" {
    for_each = var.numAdditionalNICs == 7 ? [
      1] : []
    content {
      network = var.internal_network7_network[0]
      subnetwork = var.internal_network7_subnetwork[0]
    }
  }
  dynamic "network_interface" {
    for_each = var.numAdditionalNICs == 8 ? [
      1] : []
    content {
      network = var.internal_network8_network[0]
      subnetwork = var.internal_network8_subnetwork[0]
    }
  }

  service_account {
    scopes = [
      "https://www.googleapis.com/auth/cloudruntimeconfig",
      "https://www.googleapis.com/auth/monitoring.write"]
  }

  metadata = local.admin_SSH_key_condition ? {
    instanceSSHKey = var.admin_SSH_key
    adminPasswordSourceMetadata = var.generatePassword ?random_string.generated_password.result : ""
  } : {adminPasswordSourceMetadata = var.generatePassword?random_string.generated_password.result : ""}

  metadata_startup_script = templatefile("startup-script.sh", {
    // script's arguments
    generatePassword = var.generatePassword
    config_url = "https://runtimeconfig.googleapis.com/v1beta1/projects/${var.project}/configs/-config"
    config_path = "projects/${var.project}/configs/-config"
    sicKey = var.sicKey
    allowUploadDownload = var.allowUploadDownload
    templateName = "single_tf"
    templateVersion = "20230109"
    templateType = "terraform"
    hasInternet = "true"
    enableMonitoring = var.enableMonitoring
    shell = var.admin_shell
    installationType = var.installationType
    computed_sic_key = var.sicKey
    managementGUIClientNetwork = var.managementGUIClientNetwork
    installSecurityManagement = false
    primary_cluster_address_name = ""
    secondary_cluster_address_name = ""
    subnet_router_meta_path = ""
    mgmtNIC = var.management_nic
    managementNetwork = var.managementGUIClientNetwork
    numAdditionalNICs = var.numAdditionalNICs
  })
  depends_on = [ google_compute_network.new_net_0,
                google_compute_network.new_net_1,
                google_compute_subnetwork.new_subnet_01,
                google_compute_subnetwork.new_subnet_03
  ]
}

resource "google_compute_address" "staticB" {
  name = "ipv4-address-b"
}
