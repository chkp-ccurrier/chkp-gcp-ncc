variable "project" {
  type = string
  default = "project-name"
  description = "Project env"
}
variable "zone" {
  type        = string
  default     = "us-central1-a"
  description = "Zone for deployment"
}
variable "naming_prefix" {
  type        = string
  default     = "da" 
} 
variable "service_account_path" {
  type = string
  description = "User service account path in JSON format - From the service account key page in the Cloud Console choose an existing account or create a new one. Next, download the JSON key file. Name it something you can remember, store it somewhere secure on your machine, and supply the path to the location is stored."
  default = ""
}
variable "installationType" {
  type = string
  description = "Installation type and version"
  default = "Management only"
}
variable "license" {
  type = string
  description = "Checkpoint license (BYOL or PAYG)."
  default = "BYOL"
}
variable "prefix" {
  type = string
  description = "(Optional) Resources name prefix"
  default = "chkp-single-tf-"
}
variable "image_name" {
  type = string
  description = "The High Availability (cluster) image name (e.g. check-point-r8110-gw-byol-cluster-335-985-v20220126). You can choose the desired cluster image value from: https://github.com/CheckPointSW/CloudGuardIaaS/blob/master/gcp/deployment-packages/ha-byol/images.py"
}
variable "machine_type" {
  type = string
  default = "n1-standard-4"
}
variable "mgmt_vpc" {
  type = string
  default     = "management"
  description = "management vpc name"
}
variable "mgmt_subnet" {
  type        = string
  default     = "management-subnet"
  description = "Management subnet name"
}
variable "network" {
  type = list(string)
  description = "The network determines what network traffic the instance can access"
  default = ["default"]
}
variable "subnetwork" {
  type = list(string)
  description = "Assigns the instance an IPv4 address from the subnetwork’s range. Instances in different subnetworks can communicate with each other using their internal IPs as long as they belong to the same network."
  default = ["default"]
}
variable "diskType" {
  type = string
  description ="Disk type"
  default = "pd-ssd"
}
variable "bootDiskSizeGb" {
  type = number
  description ="Disk size in GB"
  default = 100
}
variable "generatePassword" {
  type = bool
  description ="Automatically generate an administrator password	"
  default = false
}
variable "management_nic" {
  type = string
  description = "Management Interface - Gateways in GCP can be managed by an ephemeral public IP or using the private IP of the internal interface (eth1)."
  default = "Ephemeral Public IP (eth0)"
}
variable "allowUploadDownload" {
  type = string
  description ="Allow download from/upload to Check Point"
  default = true
}
variable "enableMonitoring" {
  type = bool
  description ="Enable Stackdriver monitoring"
  default = false
}
variable "admin_shell" {
  type = string
  description = "Change the admin shell to enable advanced command line configuration."
  default = "/etc/cli.sh"
}
variable "ssh_key" {
  type = string
  description ="Pub ssh key"
  default = ""
}
variable "ssh_priv_key" {
  type = string
  default = "keys/id_rsa"

}
variable "managementGUIClientNetwork" {
  type = string
  description ="Allowed GUI clients	"
  default = "0.0.0.0/0"
}
variable "externalIP" {
  type = string
  description = "External IP address type"
  default = "static"
}
variable "mgmt_ip" {
  type = string
  default = ""
}