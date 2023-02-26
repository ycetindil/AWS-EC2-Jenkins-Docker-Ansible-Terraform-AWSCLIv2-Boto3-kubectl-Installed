variable "prefix" {
  default = "jenkins"
}

variable "ssh_key_name" {
  default = "nvirginia"
}

variable "ssh_private_key_path" {
  default = "~/Documents/DevOps/AWS/"
}

variable "ingress_ports" {
  type    = list(number)
  default = [22, 80, 8080]
}