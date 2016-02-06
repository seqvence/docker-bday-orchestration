variable "do_token" {}
variable "pub_key" {}
variable "pvt_key" {}
variable "ssh_fingerprint_1" {}
variable "ssh_fingerprint_2" {}

provider "digitalocean" {
  token = "${var.do_token}"
}
