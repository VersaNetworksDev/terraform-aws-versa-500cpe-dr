
variable "region" {
  description = "Specifie region for instance creation "
}

variable "access_key" {
    description = "Access key of AWS account to be used to deploy VM on AWS."
}

variable "secret_key" {
    description =  "Secret key of AWS account to be used to deploy VM on AWS."
}

variable "key_pair_name" {
    description = "key pair name for device login"
}

variable "key_pair_file_path" {
  description = "Key file path"
}

variable "tag_name" {
  description = "tag Name"
}
variable "hostname_dir_1" {
  description = "Director host name"
  # default = "versa-director-1"
}
variable "hostname_dir_2" {
  description = "Director host name"
  # default = "versa-director-2"
}

variable "cidr_block" {
    description = "IPV4 CIDR for VPC creation"
    # default = "10.193.0.0/16"
}

variable "mgmt_subnet" {
  description = "Management Subnet for VM in AWS"
  # default = "10.193.0.0/24"
}
variable "mgmt_subnet_gateway" {
  description = "Management Ip Gateway for director northbound"
  # default = "10.193.0.1"
}
variable "dir_ana_mgnt_interfaces" {
  type = list(string)
  default = ["slave_director_mgnt"]
} 
variable "dir_ana_mgnt_interfaces_IP" {
  # default = ["10.193.0.21"]
} 
variable "controller_flex_mgnt_interfaces" {
  type = list(string)
  default = ["dr_router_mgnt","controller_2_mgnt","dr_router_to_dc_router"]
}
variable "controller_flex_mgnt_interfaces_IP" {
  # default = ["10.193.0.22","10.193.0.23","10.193.0.24"]
}
variable "Public_subnet_resource_access" {
  description = "Define public IP to access the resources"
#   default = "103.77.37.189/32"
}

variable "internet_subnet" {
  description = "Internet Subnet for VM in AWS"
  # default = "10.193.1.0/24"
}
variable "controller_flex_internet_network_interfaces" {
  type = list(string)
  default = ["dr_router_internet_ntw","controller_2_internet_ntw"]
}
variable "controller_flex_internet_network_interfaces_IP" {
  # default = ["10.193.1.22","10.193.1.23"]
}
variable "south_bound_network_subnet" {
  description = "control network subnet for VM in AWS"
  # default = "10.193.2.0/24"
}
variable "south_bound_network_interfaces" {
  type = list(string)
  default = ["slave_director_south_bound","dr_router_south_bound_ntw","controller_2_south_bound_ntw"]
}
variable "south_bound_network_interfaces_IP" {
  # default = ["10.193.2.21","10.193.2.22","10.193.2.23"]
} 
variable "ana_mgnt_tcp_port" {
    description = "Director Firewall Requirements"
    default = ["22", "443","8080","8443","8010","8020","8983"] 
    type = list
}
variable "dir_mgnt_tcp_port" {
    description = "Director Firewall Requirements"
    default = ["22","4566","4570","5432","9182","9183","9090","20514"] 
    type = list
}
variable "dir_ana_public_mgnt_tcp_rules" {
    description = "Director and Analytics managment ports"
    default = ["22","443","8080","8443"]
    type = list
}
variable "flex_controller_mgnt_tcp_rules" {
    description = "flexvnf and controller managment ports"
    default = ["22","2022","443","8080","8443","8010","8020","8983","4566","4570","5432","9182","9183","9090","20514"] 
    type = list
}

variable "sdwan_tcp_port" {
    description = "Netconf,REST port,Speed Test"
    default = ["2022", "8443","5201"] 
    type = list
}
variable "sdwan_udp_port" {
    description = "IPsec IKE"
    default = ["500", "4500","4790"] 
    type = list
}

variable "controller_ami" {
    description = "AMI Image to be used to deploy Versa FlexVNF Branch"
}

variable "controller_instance_type" {
    description = "Type of Ec2 instance for controller"
}
variable "dr_router_instance_type" {
    description = "Type of Ec2 instance for dr_router"
}
variable "Director_ami" {
    description = "AMI Image to be used to deploy versa director"
}

variable "Director_instance_type" {
    description = "Type of Ec2 instance for director"
}

variable "master_dir_mgmt_ip" {
 description = "Master Director managment IP for slave dirctor to start the startup script" 
}
variable "master_dir_south_bound_ip" {
 description = "Master Director south bound IP for controller and router access" 
}
variable "DC_mgmt_subnet" {
  description = "To add the route in DR"
}
variable "DC_internet_public_IP" {
  description = "Internet IP for IPsec tunnel"
}
variable "DC_internet_private_IP" {
  description = "Internet private IP for IPsec tunnel"
}

variable "parent_org_name" {
  description = "Define org to auto_deployment"
#   default = "versa"
}
# variable "analytics_ami" {
#     description = "AMI Image to be used to deploy versa analytics"
# }

# variable "analytics_instance_type" {
#     description = "Type of Ec2 instance for analytics"
# }
