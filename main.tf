provider "ibm" {
  ibmcloud_api_key = var.apikey
  region           = "br-sao"
}

## VPC A ##

resource "ibm_is_vpc" "vpc_a" {
  name = "vpc-a"
}

resource "ibm_is_subnet" "subnets_a_1" {
  name                     = "subnet-vpc-a-001"
  vpc                      = ibm_is_vpc.vpc_a.id
  zone                     = "br-sao-1"
  total_ipv4_address_count = 128
}

resource "ibm_is_subnet" "subnets_a_2" {
  name                     = "subnet-vpc-a-002"
  vpc                      = ibm_is_vpc.vpc_a.id
  zone                     = "br-sao-2"
  total_ipv4_address_count = 128
}

## vpc B ##

resource "ibm_is_vpc" "vpc_b" {
  name = "vpc-b"
}

resource "ibm_is_subnet" "subnets_b_1" {
  name                     = "subnet-vpc-b-001"
  vpc                      = ibm_is_vpc.vpc_b.id
  zone                     = "br-sao-1"
  total_ipv4_address_count = 128
}

resource "ibm_is_subnet" "subnets_b_2" {
  name                     = "subnet-vpc-b-002"
  vpc                      = ibm_is_vpc.vpc_b.id
  zone                     = "br-sao-2"
  total_ipv4_address_count = 128
}

resource "ibm_tg_gateway" "new_tg_gw" {
  name     = "transit-gateway-1"
  location = "br-sao"
  global   = true
}  

## VSIs ##
resource "ibm_is_instance" "vsi1" {

  name           = "vsi-vpc-a"
  vpc            = ibm_is_vpc.vpc_a.id
  keys           = [ibm_is_ssh_key.ssh_rafa.id]
  zone           = "br-sao-1"
  image          = "r042-0eeb3d3f-ee82-46a4-990c-77a67573c919"
  profile        = "bx2-4x16"

  # References to the subnet and security groups
  primary_network_interface {
    subnet          = ibm_is_subnet.subnets_a_1.id
  }
}

resource "ibm_is_floating_ip" "example" {
  name   = "example-floating-ip"
  target = ibm_is_instance.vsi1.primary_network_interface[0].id
}

# resource "ibm_is_instance" "vsi2" {

#   name           = "vsi-vpc-b"
#   vpc            = ibm_is_vpc.vpc_b.id
#   keys           = [ibm_is_ssh_key.ssh_rafa.id]
#   zone           = "br-sao-1"
#   image          = "r042-0eeb3d3f-ee82-46a4-990c-77a67573c919"
#   profile        = "bx2-4x16"

#   # References to the subnet and security groups
#   primary_network_interface {
#     subnet          = ibm_is_subnet.subnets_b_1.id
#   }
# }

# resource "ibm_is_floating_ip" "example_2" {
#   name   = "example-floating-ip-2"
#   target = ibm_is_instance.vsi2.primary_network_interface[0].id
# }


### SSH ###

resource "ibm_is_ssh_key" "ssh_rafa" {
  name       = "ssh-rafa"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCaoqih72rWA2AA9SHf4EaQtPGfx5AGGpex0Tnp2sBB2ArhYCLaw7D4t0C3UnySXmhqsXz6fzrQmmlrgHAIqdm3QbgQJNaPnoLyqJqpR7M6OFqBBSIu6Tfps+8kxGBBfzVirY7JyWcrXJxe2DTlJJOiywNsRUXTRiwHboQSv1C2Lq6t2SVIOMLzaorNgccP5zLOl3JJRpxmEVdsRdOEGMjD6Xw1R9obesUUPIaMtvCRWQFg8YvHC3nAMegcvh2QEk2U++O5zGeIhJOchpumrRL1iJ79odiiFIlxe1+GkCCAXBDl1IKO54AJwnEOfJ87g9sqa27bKzi8sTe1gZq6t1qVrJW3FouxuTqyCeWWIUKCFl+CvvpzKwFdJSMBSCCP8cHs+E6AJBqUCok46k8m/O+ZZEj4dqhrAGRCLnNduvBx/ZtyV2W5yfrQbF1a9LH+Ii0c5WlL3rw86mVlcL4PP42kCDg9/IK3XDBf8AIapz3fVh71I2KzX7ZbytURr7azUWea/qu5E6WETeiaGZklHqL3hwTicYltYrPmE/O9f20AWff2p+nrsfc3DYiiDSdj9p4b+2FWTpTL/crqpD+q2o4j4SJJLZDagRzlMfpKN0g8n/0vW5CnE73UBKSuoVNb1+dHVxo0FM8BN6sK14DWC6oMhEIvBgmahPVY/qoHx9rKdw=="
}