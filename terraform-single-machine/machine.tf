resource "digitalocean_domain" "docker-bday" {
    name = "docker-bday.do.lab.seqvence.com"
    ip_address = "${digitalocean_droplet.docker-bday.ipv4_address}"
}

resource "digitalocean_droplet" "docker-bday" {
    image = "ubuntu-14-04-x64"
    name = "docker-bday"
    region = "ams3"
    size = "2gb"
    private_networking = true
    ssh_keys = [
      "${var.ssh_fingerprint_1}",
      "${var.ssh_fingerprint_2}"
    ]
}

resource "null_resource" "docker-bday" {

  connection {
      user = "root"
      type = "ssh"
      key_file = "${var.pvt_key}"
      timeout = "6m"
      host = "${digitalocean_domain.docker-bday.name}"
  }

  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      "apt-get update -y; apt-get install -y software-properties-common; apt-add-repository -y ppa:ansible/ansible; apt-get update -y; apt-get install -y ansible git",
      ]
  }
}
