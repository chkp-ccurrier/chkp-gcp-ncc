# GCP NCC Hub and Spoke  with Check Point single gateway and management Terraform module

Terraform module deploys a GCP NCC Hub, 2 Spokes, each connected to a Router Appliance Interface - single Check Point CGNS gateway and management.

![Transit Routing](/Chkp-GCP-NCC-Transit_Routing.png)

These types of Terraform resources are supported:
 [Instance Template](https://www.terraform.io/docs/providers/google/r/compute_instance_template.html)
 [Firewall](https://www.terraform.io/docs/providers/google/r/compute_firewall.html) - conditional creation
 [Instance Group Manager](https://www.terraform.io/docs/providers/google/r/compute_region_instance_group_manager.html)
 [Compute instance](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance)
 [Google Network Connectivity Hub](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/network_connectivity_hub)
 [Google Network Connectivity Spoke](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/network_connectivity_spoke)
 [Google Cloud Router](https://registry.terraform.io/modules/terraform-google-modules/cloud-router/google/latest)


See Check Point's documentation for Single [here](https://supportcenter.checkpoint.com/supportcenter/portal?eventSubmit_doGoviewsolutiondetails=&solutionid=sk114577)

Terraform is controlled via a very easy to use command-line interface (CLI). Terraform is only a single command-line application: terraform. 

## Before you begin
1. Create a project in the [Google Cloud Console](https://console.cloud.google.com/) and set up billing on that project.
2. [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) and read the Terraform getting started guide that follows. This guide will assume basic proficiency with Terraform - it is an introduction to the Google provider.

## Configuring the Provider
The main.tf file includes the following provider configuration block used to configure the credentials you use to authenticate with GCP, as well as a default project and location for your resources:
```
provider "google" {
  credentials = file(var.service_account_path)
  project     = var.project
}
...
```

1. [Create a Service Account](https://cloud.google.com/docs/authentication/getting-started) (or use the existing one). Next, download the JSON key file. Name it something you can remember and store it somewhere secure on your machine. <br/>
2. Select "Editor" Role or verify you have the following permissions:
   ```
    compute.addresses.get
    compute.addresses.use
    compute.addresses.create
    compute.disks.create
    compute.disks.delete
    compute.firewalls.create
    compute.firewalls.delete
    compute.firewalls.get
    compute.images.get
    compute.images.useReadOnly
    compute.images.getFromFamily
    compute.instanceTemplates.create
    compute.instanceTemplates.delete
    compute.instanceTemplates.get
    compute.instanceTemplates.useReadOnly
    compute.instances.addAccessConfig
    compute.instances.create
    compute.instances.delete
    compute.instances.get
    compute.instances.setMetadata
    compute.instances.setTags
    compute.instances.setLabels
    compute.networks.get
    compute.networks.updatePolicy
    compute.regions.list
    compute.subnetworks.get
    compute.subnetworks.use
    compute.subnetworks.useExternalIp
    compute.zones.get
    iam.serviceAccountKeys.get
    iam.serviceAccountKeys.list
    iam.serviceAccounts.actAs
    iam.serviceAccounts.get
    iam.serviceAccounts.list
    iam.serviceAccounts.set
   ```
3. ```credentials``` - Your service account key file is used to complete a two-legged OAuth 2.0 flow to obtain access tokens to authenticate with the GCP API as needed; Terraform will use it to reauthenticate automatically when tokens expire. <br/> 
The provider credentials can be provided either as static credentials or as [Environment Variables](https://www.terraform.io/docs/providers/google/guides/provider_reference.html#credentials-1).
    - Static credentials can be provided by adding the path to your service-account json file, project-name and region in /gcp/modules/single/terraform.tfvars file as follows:
        ```
        service_account_path = "service-accounts/service-account-file-name.json"
        project = "project-name"
        ```
     - In case the Environment Variables are used, perform modifications described below:<br/>
        a. The next lines in the main.tf file, in the provider google resource, need to be deleted or commented:
        ```
        provider "google" {
          //  credentials = file(var.service_account_path)
          //  project = var.project
       
        }
       ```
       b.In the terraform.tfvars file leave empty double quotes for credentials and project variables:
       ```
       service_account_path = ""
       project = ""
       ```
## Usage
- Fill all variables in the /gcp/single/terraform.tfvars file with proper values (see below for variables descriptions).
- From a command line initialize the Terraform configuration directory:
    ```
    terraform init
    ```
- Create an execution plan:
    ```
    terraform plan
    ```
- Create or modify the deployment:
    ```
    terraform apply
    ```
  
#### Variables are configured in single/terraform.tfvars file as follows:
```
# --- Google Provider ---
service_account_path = "service-accounts/service-account-file-name.json"
project = "project-name"

# --- Check Point---
image_name = "check-point-r8110-gw-byol-single-335-985-v20220126"
installationType = "Gateway only"
license = "BYOL"
prefix = "chkp-single-tf-"
management_nic = "Ephemeral Public IP (eth0)"
admin_shell = "/etc/cli.sh"
admin_SSH_key = "ssh-rsa xxxxxxxxxxxxxxxxxxxxxxxx imported-openssh-key"
generatePassword = false
allow_upload_download = true
sicKey = ""
managementGUIClientNetwork = "0.0.0.0/0"

# --- Networking ---
zone = "us-central1-a
network = ["default"]
subnetwork = ["default"]
network_enableTcp= true
network_tcpSourceRanges= ["0.0.0.0/0"]
network_enableGwNetwork= false
network_gwNetworkSourceRanges= [""]
network_enableIcmp= false
network_icmpSourceRanges = [""]
network_enableUdp=  false
network_udpSourceRanges= [""]
network_enableSctp= false
network_sctpSourceRanges= [""]
network_enableEsp= false
network_espSourceRanges= [""]
numAdditionalNICs= 0
externalIP= "static"
internal_network1_network= [""]
internal_network1_subnetwork  = [""]

# --- Instance Configuration ---
machine_type = "n1-standard-4"
diskType = "SSD Persistent Disk"
bootDiskSizeGb = 100
enableMonitoring = false

```

- To tear down your resources:
    ```
    terraform destroy
    ```

## Inputs
| Name          | Description   | Type          | Allowed values |Default| Required      |
| ------------- | ------------- | ------------- | -------------  |-------|---------------|
| service_account_path | User service account path in JSON format - From the service account key page in the Cloud Console choose an existing account or create a new one. Next, download the JSON key file. Name it something you can remember, store it somewhere secure on your machine, and supply the path to the location is stored. (e.g. "service-accounts/service-account-name.json")  | string  | N/A | "" | yes |
|  |  |  |  |  |
| project  | Personal project id. The project indicates the default GCP project all of your resources will be created in.  | string  | N/A | "" | yes |
|  |  |  |  |  |
| ha  | Is this deployment a High Availabilty deployment?  | string  | yes <br/>no | "no" | yes |
|  |  |  |  |  |
| image_name |The HA gateway image name (e.g. check-point-r8120-gw-byol-single for gateway). You can choose the desired gateway image value from [Github](https://github.com/CheckPointSW/CloudGuardIaaS/blob/master/gcp/deployment-packages/single-byol/images.py).| string | N/A | N/A | yes |
|  |  |  |  |  |
| image_single_name |The single gateway name (e.g. check-point-r8120-gw-byol-single for gateway). You can choose the desired gateway image value from [Github](https://github.com/CheckPointSW/CloudGuardIaaS/blob/master/gcp/deployment-packages/single-byol/images.py).| string | N/A | N/A | yes |
|  |  |  |  |  |
| mgmt_image_name |The single gateway name (e.g. check-point-r8120-byol for management). You can choose the desired management image value from [Github](https://github.com/CheckPointSW/CloudGuardIaaS/blob/master/gcp/deployment-packages/single-byol/images.py).| string | N/A | N/A | yes |
|  |  |  |  |  |
| installationType | Installation type and version | string |Gateway only;<br/> Management only;<br/> Manual Configuration<br/>Gateway and Management (Standalone) |Gateway only|yes|
|  |  |  |  |  |
| license | Checkpoint license (BYOL or PAYG).|string|BYOL; <br/>PAYG;|BYOL|yes|
|  |  |  |  |  |
| prefix | (Optional) Resources name prefix|string|N\A|chkp-ncc-tf-|no|
|  |  |  |  |  |
| region | A region is a specific geographical location where you can host your resources. Regions have three or more zones. | string | List of allowed [Regions and Zones](https://cloud.google.com/compute/docs/regions-zones?_ga=2.31926582.-962483654.1585043745) |us-central1|yes|
|  |  |  |  |  |
| region2 | The regions determines what computing resources are available and where your data is stored and used | string | List of allowed [Regions and Zones](https://cloud.google.com/compute/docs/regions-zones?_ga=2.31926582.-962483654.1585043745) |us-east1|yes|
|  |  |  |  |  |
| zone | The zone determines what computing resources are available and where your data is stored and used. This is for Management | string | List of allowed [Regions and Zones](https://cloud.google.com/compute/docs/regions-zones?_ga=2.31926582.-962483654.1585043745) |us-central1-a|yes|
|  |  |  |  |  |
| zoneA | The zone determines what computing resources are available and where your data is stored and used. This is for GW A Zone | string | List of allowed [Regions and Zones](https://cloud.google.com/compute/docs/regions-zones?_ga=2.31926582.-962483654.1585043745) |us-central1-a|yes|
|  |  |  |  |  |
| zoneB | The zone determines what computing resources are available and where your data is stored and used. This is for GW B zone. | string | List of allowed [Regions and Zones](https://cloud.google.com/compute/docs/regions-zones?_ga=2.31926582.-962483654.1585043745) |us-central1-a|yes|
|  |  |  |  |  |
| network | The network determines what network traffic the instance can access | list(string) | Available network in the chosen zone  |N/A|yes|
|  |  |  |  |  |
| Subnetwork | Assigns the instance an IPv4 address from the subnetwork’s range. Instances in different subnetworks can communicate with each other using their internal IPs as long as they belong to the same network. | list(string) | Available subnetwork in the chosen network  |N/A|yes|
|  |  |  |  |  |
| network_tcpSourceRanges | Allow TCP traffic from the Internet | list(string) | Traffic is only allowed from sources within these IP address ranges. Use CIDR notation when entering ranges. For gateway all ports are allowed. For management allowed ports are: 257,18191,18210,18264,22,443,18190,19009 [Learn more](https://cloud.google.com/vpc/docs/vpc?_ga=2.36703144.-962483654.1585043745#firewalls) |N/A|no|
|  |  |  |  |  |
| internal_network1_network | The internal_network1_network is a list of network namces created on different spokes | list(string) | Available network in the chosen zone  |N/A|yes|
|  |  |  |  |  |
| internal_network1_subnetwork | Are subnets created under the internal_network1_networks. Instances in different subnetworks can communicate with each other using their internal IPs as long as they belong to the same network. | list(string) | Available subnetwork in the chosen network  |N/A|yes|
|  |  |  |  |  |
| new_subnet_0_cidr | TCP Address definitions for related internal_network1_subnetworks | list(string) | Traffic is only allowed from sources within these IP address ranges. Use CIDR notation when entering ranges. [Learn more](https://cloud.google.com/vpc/docs/vpc?_ga=2.36703144.-962483654.1585043745#firewalls) |N/A|no|
|  |  |  |  |  |
| new_subnet_1_cidr | TCP Address definitions for related internal_network1_subnetworks | list(string) | Traffic is only allowed from sources within these IP address ranges. Use CIDR notation when entering ranges. [Learn more](https://cloud.google.com/vpc/docs/vpc?_ga=2.36703144.-962483654.1585043745#firewalls) |N/A|no|
|  |  |  |  |  |
| new_subnet_0_str | String representation of related TCP Subnet Cidr  | list(string) | Traffic is only allowed from sources within these IP address ranges. Use CIDR notation when entering ranges. [Learn more](https://cloud.google.com/vpc/docs/vpc?_ga=2.36703144.-962483654.1585043745#firewalls) |N/A|no|
|  |  |  |  |  |
| ha_vip | String value for HA VIP  | string | Traffic for Cluster vip. |"2"|no|
|  |  |  |  |  |
| ha_a_ip | String value for A GW  | string | IP for Traffic for GW. |"3"|no|
|  |  |  |  |  |
| ha_b_ip | String value for B GW  | string | IP for Traffic for GW. |"4"|no|
|  |  |  |  |  |
| mgmt_ip | String value for Management Ip Address  | string | IP for Traffic for Management. |"100"|no|
|  |  |  |  |  |
| machineType | Machine types determine the specifications of your machines, such as the amount of memory, virtual cores, and persistent disk limits an instance will have | string | [Learn more about Machine Types](https://cloud.google.com/compute/docs/machine-types?hl=en_US&_ga=2.267871494.-962483654.1585043745) | n1-standard-4|no|
|  |  |  |  |  |
| diskType | Disk type | string | SSD Persistent Disk;<br/>standard-Persistent Disk;<br/>Storage space is much less expensive for a standard persistent disk. An SSD persistent disk is better for random IOPS or streaming throughput with low latency. [Learn more](https://cloud.google.com/compute/docs/disks/?hl=en_US&_ga=2.66020774.-962483654.1585043745#overview_of_disk_types)|SSD Persistent Disk|no|
|  |  |  |  |  |
| bootDiskSizeGb | Disk size in GB | number | Persistent disk performance is tied to the size of the persistent disk volume. You are charged for the actual amount of provisioned disk space. [Learn more](https://cloud.google.com/compute/docs/disks/?hl=en_US&_ga=2.232680471.-962483654.1585043745#pdperformance)|100|no|
|  |  |  |  |  |
| generatePassword | Automatically generate an administrator password | boolean | true; <br/>false; |false|no|
|  |  |  |  |  |
| allowUploadDownload | Allow download from/upload to Check Point  | boolean | true; <br/>false; |false|no|
|  |  |  |  |  |
| enableMonitoring | Enable Stackdriver monitoring | boolean | true; <br/>false; |false|no|
|  |  |  |  |  |
| admin_shell | Change the admin shell to enable advanced command line configuration. | string | /etc/cli.sh;<br/>/bin/bash;<br/>/bin/csh;<br/>/bin/tcsh;<br/> |/etc/cli.sh|no|
|  |  |  |  |  |
| admin_SSH_key | Public SSH key for the user 'admin' - The SSH public key for SSH authentication to the instances. Leave this field blank to use all project-wide pre-configured SSH keys. | string | A valid public ssh key | "" | no |
|  |  |  |  |  |
| sicKey | The Secure Internal Communication one time secret used to set up trust between the single gateway object and the management server | string | At least 8 alpha numeric characters.<br/>If SIC is not provided and needed, a key will be automatically generated |""|no|
|  |  |  |  |  |
| managementGUIClientNetwork | Allowed GUI clients | string | A valid IPv4 network CIDR (e.g. 0.0.0.0/0) |0.0.0.0/0|no|
|  |  |  |  |  |
| numAdditionalNICs | Number of additional network interfaces | number | A number in the range 0 - 8.<br/>Multiple network interfaces deployment is described in [sk121637 - Deploy a CloudGuard for GCP with Multiple Network Interfaces](https://supportcenter.checkpoint.com/supportcenter/portal?eventSubmit_doGoviewsolutiondetails=&solutionid=sk121637) |0|no|
|  |  |  |  |  |
| externalIP | External IP address type | string | Static;<br/>Ephemeral;<br/>An external IP address associated with this instance. Selecting "None" will result in the instance having no external internet access. [Learn more](https://cloud.google.com/compute/docs/ip-addresses/reserve-static-external-ip-address?_ga=2.259654658.-962483654.1585043745) |static|no|
|  |  |  |  |  |
| management_nic | Management Interface - Security Gateways in GCP can be managed by an ephemeral public IP or using the private IP of the internal interface (eth1). | string | Ephemeral Public IP (eth0) <br/> - Private IP (eth1) |XEphemeral Public IP (eth0)|no|
|  |  |  |  |  |

## Outputs
| Name  | Description |
| ------------- | ------------- |
| SIC_key  | Secure Internal Communication (SIC) initiation key.  |
| ManagementIP  | Public IP address of the Management server.  |
| GW_A_IP  | Public IP Address of the A gateway.  |
| GW_B_IP  | Public IP Address of the A gateway.  |


## Revision History
In order to check the template version refer to the [sk116585](https://supportcenter.checkpoint.com/supportcenter/portal?eventSubmit_doGoviewsolutiondetails=&solutionid=sk116585)

| Template Version | Description   |
| ---------------- | ------------- |
| 20231005 | First commit of GCP NCC Hub and Spoke with Check Point Check Point CloudGuard IaaS single gateway and management Terraform module. |
| | | |
|  | Addition of "template_type" parameter to "cloud-version" files. |
| | | |

## Authors
[CB Currier - Cloud Alliance Architect](mailto:ccurrier@checkpoint.com)

## License

This project is licensed under the Apache License - see the [LICENSE](/LICENSE) file for details
