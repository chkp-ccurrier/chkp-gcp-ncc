# --- Google Provider ---
service_account_path                        = "../project-name-sa-cert.json"
project                                     = "project-name"
ha                                          = "no"
# --- Check Point Deployment---
image_name                                  = "check-point-r8120-gw-byol-single"              # "check-point-r8120-gw-byol-single-631-991001335-v20230621"
image_single_name                           = "check-point-r8120-gw-byol-single"              # "check-point-r8120-gw-byol-single-631-991001335-v20230621"
mgmt_image_name                             = "check-point-r8120-byol"
installationType                            = "Gateway only"  #"Cluster"
license                                     = "BYOL"
prefix                                      = "chkp-tf-"
management_nic                              = "Ephemeral Public IP (eth0)"
admin_shell                                 = "/bin/bash"
admin_SSH_key                               = ""
generatePassword                            = false
allowUploadDownload                         = true
sicKey                                      = "qwe123qwe123"
managementGUIClientNetwork                  = "0.0.0.0/0"
#management_name                             = ""
# --- Networking---
region                                      = "us-east1" #"us-central1"
region2                                     = "us-central1"  #"us-east1"
zone                                        = "us-east1-b"  #"us-central1-a"
zoneA                                       = "us-east1-b"   #"us-central1-a"
zoneB                                       = "us-east1-c"  #"us-central1-b"
network                                     = ["spoke1","spoke2"]
subnetwork                                  = ["spoke1-sub-a","spoke1-sub-b","spoke2-sub"]
network_tcpSourceRanges                     = ["0.0.0.0/0"]
numAdditionalNICs                           =  1
externalIP                                  = "static"
internal_network1_network                   =  ["int-traffic","internal",]
internal_network1_subnetwork                =  ["int-traffic-sub-a","internal-sub-a","int-traffic-sub-b","internal-sub-b"]

# --- Instances configuration---
machine_type                                = "n1-standard-4"
diskType                                    = "SSD Persistent Disk"
bootDiskSizeGb                              = 100
enableMonitoring                            = false
new_subnet_0_cidr                           = ["10.150.0.0/24","10.100.0.0/24","10.10.0.0/24","10.20.0.0/24"]
new_subnet_1_cidr                           = ["10.150.1.0/24","10.100.1.0/24","10.10.1.0/24","10.20.1.0/24"]
new_subnet_0_str                            = ["10.150.0.","10.100.0.","10.10.0.","10.20.0."]
new_subnet_1_str                            = ["10.150.1.","10.100.1.","10.10.1.","10.20.1."]
ha_vip                                      = "2"
ha_a_ip                                     = "3"
ha_b_ip                                     = "4"
mgmt_ip                                     = "100"