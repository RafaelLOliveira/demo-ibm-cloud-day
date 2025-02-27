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
  name = var.vpcname
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
  name     = var.tgname
  location = "br-sao"
  global   = true
}  

## VSIs ##
resource "ibm_is_instance" "vsi1" {

  name           = var.vsiname
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
  name       = "ssh-teste-demo"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDG1xrrLipGM4LFVQHb1q5LCx8/sBaSSHMxSVOJ22vBd4mj2yd8KAUi6cXvmzb/oxkiwMGj+M5yplhzFzNW0ceGmtNCnJx/qYAOOhdIbNw5BmuQcdxHfGHgS4TeUe8ENDYt9TNF6kggTUITVs7/e1k44/ci8Uws0NeBi2n7wzDUVbWqzuslpqCoZTzqBbsSpNGYSSU6L09tfok/bBl2Eoc85Ruq1MSoIIIzYe9uswTKx9r9SLlCA9xxx1ijTFi6XQIX9bXltpXzeqEus1jsafl+YmBjOrjqfLCYlQWAxKJvWHSqwCg3ZSaBRewWS2/RUC3wszLq6jmyNqqA3Rv4Wl9sRGunhKKEmozgT7dry/c9W+znQpF9VifMTu9MsqLg3sWSHxT+OWy7HnBR+/+9qWKZjnGvm9xaInnpVC2x4phs3A5a2p/NIPfGiHhu/nJlPlGuKOWqovqpKl9XM2V3SMhZKakgfqEe8NMmtzHq8U4taipJp3M8JhvaDWjvhKYx6xozVNokf2+rql++1er6xkExvAyARzVOPIaqa9HnfagbyRAn2KXgSBZvduGaRJ8MnrH1/OE4yEle1sOzM0bX7nU2SgKJyYsilfQtu9GhHMvDkWf2Vawyo9SCjh0e+PHzB14NCh/Fq4oEUNB3duQV2ntMtQ67b4f4FukrZfB2ipnIjw=="
}
