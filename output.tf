#VPC id
output "vpc_id" {
  value = "${aws_vpc.versa_he_500_cpe_dr_vpc.id}"
}
# Instance ID
output "slave_director_instance_id" {
  value = "${aws_instance.versa_he_500_cpe_dr_tf_slave_director.id}"
}
output "controller_2_instance_id" {
  value = "${aws_instance.versa_he_500_cpe_dr_tf_controller_2.id}"
}
output "dr_router_instance_id" {
  value = "${aws_instance.versa_he_500_cpe_dr_tf_dr_router.id}"
}


# Main route table id

output "main_route_table_id" {
    value = "${aws_vpc.versa_he_500_cpe_dr_vpc.main_route_table_id}"
}
output "internet_gateway" {
    value = "${aws_internet_gateway.versa_he_500_cpe_dr_ig.id}"
}

#security Group's
output "security_group_sdwan" {
  value = "${aws_security_group.versa_he_500_cpe_dr_sg_sdwan.id}"
}
output "security_group_Director_Analytics_mgnt" {
  value = "${aws_security_group.versa_he_500_cpe_dr_sg_dir_ana_mgnt.id}"
}
output "security_group_controller_mgnt" {
  value = "${aws_security_group.versa_he_500_cpe_dr_sg_controller_mgnt.id}"
}

output"security_group_south_bound_network" {
  value = "${aws_security_group.versa_he_500_cpe_dr_sg_south_bound_network.id}"
}

#Public IP for managment

output "slave_director_mgnt_interface_public_ip" {
  value = "${aws_eip.versa_he_500_cpe_dr_dir_ana_mgnt_interface_public_ip[0].public_ip}"
}
output "dr_router_internet_interface_public_ip" {
  value = "${aws_eip.versa_he_500_cpe_dr_controller_flex_internet_interface_public_ip[0].public_ip}"
}
output "controller_2_internet_interface_public_ip" {
  value = "${aws_eip.versa_he_500_cpe_dr_controller_flex_internet_interface_public_ip[1].public_ip}"
}

# #Public IP for INternet
# output "controller_2_internet_interface_public_ip" {
#   value = "${aws_eip.versa_he_500_cpe_dr_controller_flex_internet_interface_public_ip[1].public_ip}"
# }

#Private IP
output "dr_router_mgnt_interface_private_ip" {
  value = "${aws_network_interface.versa_he_500_cpe_dr_controller_flex_mgnt_interface[0].private_ip}"
}
output "dr_router_internet_interface_private_ip" {
  value = "${aws_eip.versa_he_500_cpe_dr_controller_flex_internet_interface_public_ip[0].private_ip}"
}
output "dr_router_south_bound_network_interface_private_ip" {
  value = "${aws_network_interface.versa_he_500_cpe_dr_south_bound_network_interface[1].private_ip}"
}
output "dr_router_dc_router_network_interface_private_ip" {
  value = "${aws_network_interface.versa_he_500_cpe_dr_controller_flex_mgnt_interface[2].private_ip}"
}

output "controller_2_mgnt_interface_private_ip" {
  value = "${aws_network_interface.versa_he_500_cpe_dr_controller_flex_mgnt_interface[1].private_ip}"
}
output "controller_2_south_bound_network_interface_private_ip" {
  value = "${aws_network_interface.versa_he_500_cpe_dr_south_bound_network_interface[2].private_ip}"
}
output "controller_2_internet_interface_private_ip" {
  value = "${aws_eip.versa_he_500_cpe_dr_controller_flex_internet_interface_public_ip[1].private_ip}"
}


output "slave_director_mgnt_interface_private_ip" {
  value = "${aws_eip.versa_he_500_cpe_dr_dir_ana_mgnt_interface_public_ip[0].private_ip}"
}
output "slave_director_south_bound_network_interface_private_ip" {
  value = "${aws_network_interface.versa_he_500_cpe_dr_south_bound_network_interface[0].private_ip}"
}

#Connect to instance

output "slave_director_Connect_to_instance" {
  value = "ssh -i ${var.key_pair_name}.pem Administrator@${aws_eip.versa_he_500_cpe_dr_dir_ana_mgnt_interface_public_ip[0].public_ip}"
} 

# output "controller_2_Connect_to_instance" {
#   value = "ssh -i ${var.key_pair_name}.pem admin@${aws_eip.versa_he_500_cpe_dr_controller_flex_mgnt_interface_public_ip[1].public_ip}"
# } 
# output "dr_router_Connect_to_instance" {
#   value = "ssh -i ${var.key_pair_name}.pem admin@${aws_eip.versa_he_500_cpe_dr_controller_flex_mgnt_interface_public_ip[1].public_ip}"
# } 