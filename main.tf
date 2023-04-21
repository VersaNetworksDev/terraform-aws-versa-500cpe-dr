# Configure the AWS Provider
terraform {
  required_providers {
    aws = {
      version = "~>3.51.0"
    }
  }
}
provider "aws" {

    region = "${var.region}"
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
}
data "aws_availability_zones" "available" {
  state = "available"
}

#create VPC
resource "aws_vpc" "versa_he_500_cpe_dr_vpc" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"

  tags = {
    Name = "${var.tag_name}_versa_he_500_cpe_dr_vpc"
  }
}

#create internet gateway

resource "aws_internet_gateway" "versa_he_500_cpe_dr_ig" {
  vpc_id = aws_vpc.versa_he_500_cpe_dr_vpc.id
  tags = {
    Name = "${var.tag_name}_versa_he_500_cpe_dr_ig"
  }
}

#Add default route to the internet gateway

resource "aws_default_route_table" "versa_he_500_cpe_dr_rt" {
  default_route_table_id = aws_vpc.versa_he_500_cpe_dr_vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.versa_he_500_cpe_dr_ig.id
  }
  tags = {
    Name = "${var.tag_name}_versa_he_500_cpe_dr_rt"
  }
}

#create security group for controller managment

resource "aws_security_group" "versa_he_500_cpe_dr_sg_controller_mgnt" {
  name        = "${var.tag_name}_versa_he_500_cpe_dr_sg_controller_mgnt"
  description = "Allow SSH and Netconf inbound for managment traffic"
  vpc_id      = aws_vpc.versa_he_500_cpe_dr_vpc.id 
    
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.tag_name}_versa_he_500_cpe_dr_sg_controller_mgnt"
  }
}

resource "aws_security_group_rule" "versa_he_500_cpe_dr_sg_controller_mgnt_tcp_rules" {
  count = length(var.flex_controller_mgnt_tcp_rules)
  type              = "ingress"
  from_port         = var.flex_controller_mgnt_tcp_rules[count.index]
  to_port           = var.flex_controller_mgnt_tcp_rules[count.index]
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.versa_he_500_cpe_dr_sg_controller_mgnt.id

}

#create security group for Director and analytics

resource "aws_security_group" "versa_he_500_cpe_dr_sg_dir_ana_mgnt" {
  name        = "${var.tag_name}_versa_he_500_cpe_dr_dir_ana_mgnt"
  description = "Open External Ports"
  vpc_id      = aws_vpc.versa_he_500_cpe_dr_vpc.id 
    
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.tag_name}_versa_he_500_cpe_dr_sg_dir_ana_mgnt"
  }
}

# Add ingress rules to Director and analytics private security group

resource "aws_security_group_rule" "versa_he_500_cpe_dc_sg_dir_mgnt_tcp_rules" {
  count = length(var.dir_mgnt_tcp_port)
  type              = "ingress"
  from_port         = var.dir_mgnt_tcp_port[count.index]
  to_port           = var.dir_mgnt_tcp_port[count.index]
  protocol          = "tcp"
  cidr_blocks       = [var.DC_mgmt_subnet]
  security_group_id = aws_security_group.versa_he_500_cpe_dr_sg_dir_ana_mgnt.id

}
# Add ingress rules to Director and analytics public security group


resource "aws_security_group_rule" "versa_he_500_cpe_dr_sg_dir_ana_public_mgnt_tcp_rules" {
  count = length(var.dir_ana_public_mgnt_tcp_rules)
  type              = "ingress"
  from_port         = var.dir_ana_public_mgnt_tcp_rules[count.index]
  to_port           = var.dir_ana_public_mgnt_tcp_rules[count.index]
  protocol          = "tcp"
  cidr_blocks       = [var.Public_subnet_resource_access]
  security_group_id = aws_security_group.versa_he_500_cpe_dr_sg_dir_ana_mgnt.id

}

#create security group for sdwan

resource "aws_security_group" "versa_he_500_cpe_dr_sg_sdwan" {
  name        = "${var.tag_name}_versa_he_500_cpe_dr_sg_sdwan"
  description = "Allow SDWAN inbound traffic"
  vpc_id      = aws_vpc.versa_he_500_cpe_dr_vpc.id 
    
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.tag_name}_versa_he_500_cpe_dr_sg_sdwan"
  }
}

# Add ingress rules to the sdwan security group


resource "aws_security_group_rule" "versa_he_500_cpe_dr_sg_sdwan_tcp_rules" {
  count = length(var.sdwan_tcp_port)
  type              = "ingress"
  from_port         = var.sdwan_tcp_port[count.index]
  to_port           = var.sdwan_tcp_port[count.index]
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.versa_he_500_cpe_dr_sg_sdwan.id

}
resource "aws_security_group_rule" "versa_he_500_cpe_dr_sg_sdwan_udp_rules" {
  count = length(var.sdwan_udp_port)
  type              = "ingress"
  from_port         = var.sdwan_udp_port[count.index]
  to_port           = var.sdwan_udp_port[count.index]
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.versa_he_500_cpe_dr_sg_sdwan.id

}

#create security group for south_bound_network

resource "aws_security_group" "versa_he_500_cpe_dr_sg_south_bound_network" {
  name        = "${var.tag_name}_versa_he_500_cpe_dr_sg_south_bound_network"
  description = "Allow all traffic"
  vpc_id      = aws_vpc.versa_he_500_cpe_dr_vpc.id 
    
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.tag_name}_versa_he_500_cpe_dr_sg_south_bound_network"
  }
}

#create subnet for managment

resource "aws_subnet" "versa_he_500_cpe_dr_mgnt" {
  vpc_id     = aws_vpc.versa_he_500_cpe_dr_vpc.id
  cidr_block = var.mgmt_subnet
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  tags = {
    Name = "${var.tag_name}_versa_he_500_cpe_dr_mgnt"
  }
}

  # create Director managment interface
 
resource "aws_network_interface" "versa_he_500_cpe_dr_dir_ana_mgnt_interface" {
  count = length(var.dir_ana_mgnt_interfaces)
  subnet_id = aws_subnet.versa_he_500_cpe_dr_mgnt.id
  private_ips = ["${var.dir_ana_mgnt_interfaces_IP[count.index]}"]  
  source_dest_check = false
  security_groups = [aws_security_group.versa_he_500_cpe_dr_sg_dir_ana_mgnt.id]
    tags = {
    Name = "${var.tag_name}_versa_he_500_cpe_dr_${var.dir_ana_mgnt_interfaces[count.index]}"

  }
}
#EIPs associated with director managment network interface
resource "aws_eip" "versa_he_500_cpe_dr_dir_ana_mgnt_interface_public_ip" {
  count = length(var.dir_ana_mgnt_interfaces)  
  vpc                       = true
  network_interface         = aws_network_interface.versa_he_500_cpe_dr_dir_ana_mgnt_interface[count.index].id
    tags = {
    Name = "${var.tag_name}_versa_he_500_cpe_dr_${var.dir_ana_mgnt_interfaces[count.index]}"
  }
}


# create controller and flex managment interface

resource "aws_network_interface" "versa_he_500_cpe_dr_controller_flex_mgnt_interface" {
  count = length(var.controller_flex_mgnt_interfaces)    
  subnet_id = aws_subnet.versa_he_500_cpe_dr_mgnt.id
  private_ips = ["${var.controller_flex_mgnt_interfaces_IP[count.index]}"]   
  source_dest_check = false
  security_groups = [aws_security_group.versa_he_500_cpe_dr_sg_controller_mgnt.id]
    tags = {
    Name = "${var.tag_name}_versa_he_500_cpe_dr_${var.controller_flex_mgnt_interfaces[count.index]}"
  }
}

#create subnet for south_bound_network

resource "aws_subnet" "versa_he_500_cpe_dr_south_bound_network" {
  vpc_id     = aws_vpc.versa_he_500_cpe_dr_vpc.id
  cidr_block = var.south_bound_network_subnet
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  tags = {
    Name = "${var.tag_name}_versa_he_500_cpe_dr_south_bound_network"
  }
}

  # create south_bound_network interface

resource "aws_network_interface" "versa_he_500_cpe_dr_south_bound_network_interface" {
  count = length(var.south_bound_network_interfaces)    
  subnet_id = aws_subnet.versa_he_500_cpe_dr_south_bound_network.id
  private_ips = ["${var.south_bound_network_interfaces_IP[count.index]}"]   
  source_dest_check = false
  security_groups = [aws_security_group.versa_he_500_cpe_dr_sg_south_bound_network.id]  
    tags = {
    Name = "${var.tag_name}_versa_he_500_cpe_dr_${var.south_bound_network_interfaces[count.index]}"
  }
}

# #create subnet for controller and flex network

# resource "aws_subnet" "versa_he_500_cpe_dr_controller_flex_ntw" {
#   vpc_id     = aws_vpc.versa_he_500_cpe_dr_vpc.id
#   cidr_block = var.controller_flex_ntw
#   availability_zone = "${data.aws_availability_zones.available.names[0]}"
#   tags = {
#     Name = "${var.tag_name}_versa_he_500_cpe_dr_controller_flex_ntw"
#   }
# }

# # create controller and flex network interface
# variable "controller_flex_network_interfaces" {
#   type = list(string)
#   default = ["dr_router_controller_flex_ntw","controller_2_controller_flex_ntw"]
# }
# resource "aws_network_interface" "versa_he_500_cpe_dr_controller_flex_ntw_interface" {
#   count = length(var.controller_flex_network_interfaces)   
#   subnet_id = aws_subnet.versa_he_500_cpe_dr_controller_flex_ntw.id
#   source_dest_check = false
#   security_groups = [aws_security_group.versa_he_500_cpe_dr_sg_south_bound_network.id]
#     tags = {
#     Name = "${var.tag_name}_versa_he_500_cpe_dr_${var.controller_flex_network_interfaces[count.index]}"
#   }
# }

#create subnet for Internet

resource "aws_subnet" "versa_he_500_cpe_dr_internet" {
  vpc_id     = aws_vpc.versa_he_500_cpe_dr_vpc.id
  cidr_block = var.internet_subnet
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  tags = {
    Name = "${var.tag_name}_versa_he_500_cpe_dr_internet"
  }
}

# create controller internet interface

resource "aws_network_interface" "versa_he_500_cpe_dr_controller_flex_internet_interface" {
  count = length(var.controller_flex_internet_network_interfaces)   
  subnet_id = aws_subnet.versa_he_500_cpe_dr_internet.id
  private_ips = ["${var.controller_flex_internet_network_interfaces_IP[count.index]}"]    
  source_dest_check = false
  security_groups = [aws_security_group.versa_he_500_cpe_dr_sg_sdwan.id]
    tags = {
    Name = "${var.tag_name}_versa_he_500_cpe_dr_${var.controller_flex_internet_network_interfaces[count.index]}"
  }
}
#EIPs associated with internet network interface
resource "aws_eip" "versa_he_500_cpe_dr_controller_flex_internet_interface_public_ip" {
  count = length(var.controller_flex_internet_network_interfaces)   
  vpc                       = true
  network_interface         = aws_network_interface.versa_he_500_cpe_dr_controller_flex_internet_interface[count.index].id
    tags = {
    Name = "${var.tag_name}_versa_he_500_cpe_dr_${var.controller_flex_internet_network_interfaces[count.index]}"
  }
}
#Ec2 instance creation

#create Slave Director Ec2 instance 
data "template_file" "user_data_slave_director" {
  template = file("./versa_he_500_cpe_multiregion_dr/slave_director.sh")
  
  vars = {
    hostname_dir_1 = var.hostname_dir_1
    hostname_dir_2 = var.hostname_dir_2
    mgmt_subnet_gateway = var.mgmt_subnet_gateway    
    # master_dir_mgmt_ip  = "${aws_eip.versa_he_500_cpe_dr_dir_ana_mgnt_interface_public_ip[0].private_ip}"
    master_dir_mgmt_ip  = var.master_dir_mgmt_ip
    slave_dir_mgmt_ip  = "${aws_eip.versa_he_500_cpe_dr_dir_ana_mgnt_interface_public_ip[0].private_ip}"
    DC_mgmt_subnet = var.DC_mgmt_subnet
    dr_router_mgnt_ip = "${aws_network_interface.versa_he_500_cpe_dr_controller_flex_mgnt_interface[2].private_ip}"  
  }
}
data "template_cloudinit_config" "slave_director_config" {
  gzip          = false
  base64_encode = false
  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.user_data_slave_director.rendered
  }
}
resource "aws_instance" "versa_he_500_cpe_dr_tf_slave_director" {
    # count = var.instance_count    
    ami = var.Director_ami
    instance_type = var.Director_instance_type
    root_block_device {
      delete_on_termination = true
      volume_size = "256"
    }
    availability_zone = "${data.aws_availability_zones.available.names[0]}"
    network_interface {
      network_interface_id = aws_network_interface.versa_he_500_cpe_dr_dir_ana_mgnt_interface[0].id
      device_index         = 0
    }    
    network_interface {
      network_interface_id = aws_network_interface.versa_he_500_cpe_dr_south_bound_network_interface[0].id
      device_index         = 1
    }
    user_data = "${data.template_cloudinit_config.slave_director_config.rendered}"
    key_name = "${var.key_pair_name}"
    tags = {
      Name = "${var.tag_name}_versa_he_500_cpe_dr_tf_slave_director"
    }
}

#create dr_router Ec2 instance 


data "template_file" "user_data_dr_router_cloud_init" {
  template = file("./versa_he_500_cpe_multiregion_dr/dr_dc_network_config_gen.yaml")
  
  vars = {
    parent_org_name = var.parent_org_name
    South_Bound_Network_ip = "${aws_network_interface.versa_he_500_cpe_dr_south_bound_network_interface[1].private_ip}"
    internet_interface_ip  = "${aws_network_interface.versa_he_500_cpe_dr_controller_flex_internet_interface[0].private_ip}"
    DR_DC_NETWORK_CONNECT  = "${aws_network_interface.versa_he_500_cpe_dr_controller_flex_mgnt_interface[2].private_ip}"
    DC_internet_public_IP = var.DC_internet_public_IP
    DC_internet_private_IP = var.DC_internet_private_IP
    master_dir_mgmt_ip  = var.master_dir_mgmt_ip
    master_dir_south_bound_ip = var.master_dir_south_bound_ip
    slave_dir_mgmt_ip = "${aws_network_interface.versa_he_500_cpe_dr_dir_ana_mgnt_interface[0].private_ip}"
    slave_dir_south_bound_ip = "${aws_network_interface.versa_he_500_cpe_dr_south_bound_network_interface[0].private_ip}"
    DC_mgmt_subnet = var.DC_mgmt_subnet
    controller_2_south_bound_ip = "${aws_network_interface.versa_he_500_cpe_dr_south_bound_network_interface[2].private_ip}"
    DR_internet_subnet_gateway = var.DR_internet_subnet_gateway    
  }
}
data "template_cloudinit_config" "user_data_dr_router_config" {
  gzip          = false
  base64_encode = false
  part {
    content_type = "text/cloud-config"
    content      = data.template_file.user_data_dr_router_cloud_init.rendered
  }
}

resource "aws_instance" "versa_he_500_cpe_dr_tf_dr_router" { 
    ami = var.controller_ami
    instance_type = var.dr_router_instance_type
    root_block_device {
      delete_on_termination = true
    }
    availability_zone = "${data.aws_availability_zones.available.names[0]}"
    network_interface {
      network_interface_id = aws_network_interface.versa_he_500_cpe_dr_controller_flex_mgnt_interface[0].id
      device_index         = 0
    }    
    network_interface {
      network_interface_id = aws_network_interface.versa_he_500_cpe_dr_south_bound_network_interface[1].id
      device_index         = 1
    }
    network_interface {
      network_interface_id = aws_network_interface.versa_he_500_cpe_dr_controller_flex_internet_interface[0].id
      device_index         = 2
    }
    network_interface {
      network_interface_id = aws_network_interface.versa_he_500_cpe_dr_controller_flex_mgnt_interface[2].id
      device_index         = 3
    }
    user_data = "${data.template_cloudinit_config.user_data_dr_router_config.rendered}"
    key_name = "${var.key_pair_name}"
    tags = {
      Name = "${var.tag_name}_versa_he_500_cpe_dr_tf_dr_router"
    }
}
#create controller Ec2 instance 

resource "aws_instance" "versa_he_500_cpe_dr_tf_controller_2" { 
    ami = var.controller_ami
    instance_type = var.controller_instance_type
    root_block_device {
      delete_on_termination = true
    }
    availability_zone = "${data.aws_availability_zones.available.names[0]}"
    network_interface {
      network_interface_id = aws_network_interface.versa_he_500_cpe_dr_controller_flex_mgnt_interface[1].id
      device_index         = 0
    }    
    network_interface {
      network_interface_id = aws_network_interface.versa_he_500_cpe_dr_south_bound_network_interface[2].id
      device_index         = 1
    }
    network_interface {
      network_interface_id = aws_network_interface.versa_he_500_cpe_dr_controller_flex_internet_interface[1].id
      device_index         = 2
    }
    user_data = <<-EOF
    #cloud-config
    cloud_init_modules:
      - write-files
      - set_hostname
      - update_hostname
      - users-groups
      - ssh
    hostname: versa-flexvnf
    write_files:
    - content: |
        #writen by cloud-init write-files module
        auto lo
        auto eth0
        iface lo inet loopback
        iface eth0 inet dhcp
          post-up route add -net ${var.DC_mgmt_subnet} gw ${aws_network_interface.versa_he_500_cpe_dr_controller_flex_mgnt_interface[2].private_ip}
      path: /etc/network/interfaces
    cloud_final_modules:
    - runcmd
    - scripts-user
    runcmd:
    - sed -i.bak "\$a\Match Address ${var.master_dir_mgmt_ip}/32\n  PasswordAuthentication yes\nMatch all" /etc/ssh/sshd_config
    - sed -i.bak "\$a\Match Address ${var.master_dir_south_bound_ip}/32\n  PasswordAuthentication yes\nMatch all" /etc/ssh/sshd_config    
    - sed -i.bak "\$a\Match Address ${aws_network_interface.versa_he_500_cpe_dr_dir_ana_mgnt_interface[0].private_ip}/32\n  PasswordAuthentication yes\nMatch all" /etc/ssh/sshd_config
    - sed -i.bak "\$a\Match Address ${aws_network_interface.versa_he_500_cpe_dr_south_bound_network_interface[0].private_ip}/32\n  PasswordAuthentication yes\nMatch all" /etc/ssh/sshd_config
    - sudo service ssh restart
    - sudo route add -net ${var.DC_mgmt_subnet} gw ${aws_network_interface.versa_he_500_cpe_dr_controller_flex_mgnt_interface[2].private_ip}
      EOF
    key_name = "${var.key_pair_name}"
    tags = {
      Name = "${var.tag_name}_versa_he_500_cpe_dr_tf_controller_2"
    }
}