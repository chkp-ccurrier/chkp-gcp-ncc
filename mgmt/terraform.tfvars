# --- Google Provider ---
service_account_path                        = "../project-name-sa-cert.json"
project                                     = "project-name"

# --- Check Point Deployment---
image_name                                  = "check-point-r8120-byol"
installationType                            = "Management only"
license                                     = "BYOL"
prefix                                      = "da"
management_nic                              = "Ephemeral Public IP (eth0)"
admin_shell                                 = "/bin/bash"
generatePassword                            = false
allowUploadDownload                         = true
ssh_key                                      = ""
managementGUIClientNetwork                  = "0.0.0.0/0"

# --- Networking---
zone                                        = "us-central1-a"
externalIP                                  = "static"
mgmt_ip                                     = "10.150.0.100"

# --- Instances configuration---
machine_type                                = "n1-standard-4"
diskType                                    = "SSD Persistent Disk"
bootDiskSizeGb                              = 100
enableMonitoring                            = false
