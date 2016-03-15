resource "digitalocean_domain" "dbs2" {
    name = "dbs2.do.lab.seqvence.com"
    ip_address = "${digitalocean_droplet.dbs2.ipv4_address}"
}

resource "digitalocean_droplet" "dbs2" {
    image = "ubuntu-14-04-x64"
    name = "dbs2"
    region = "ams3"
    size = "2gb"
    private_networking = true
    ssh_keys = [
      "${var.ssh_fingerprint_1}",
      "${var.ssh_fingerprint_2}",
      "${var.ssh_fingerprint_3}"
    ]
}

resource "null_resource" "dbs2" {

  connection {
      user = "root"
      type = "ssh"
      key_file = "${var.pvt_key}"
      timeout = "6m"
      host = "${digitalocean_droplet.dbs2.ipv4_address}"
  }

  provisioner "file" {
      source = "ansible-playbooks/slave.yml"
      destination = "/root/local_playbook.yml"
  }

  provisioner "remote-exec" {
    inline = [
        "mkdir -p /root/ansible"
    ]
  }

  provisioner "file" {
      source = "ansible-playbooks/slave"
      destination = "/root/ansible/slave"
  }

  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      "apt-get update -y; apt-get install -y software-properties-common; apt-add-repository -y ppa:ansible/ansible; apt-get update -y; apt-get install -y ansible git; apt-get -y install python-pip",
      "git clone https://github.com/weareinteractive/ansible-nginx.git /root/ansible/franklinkim.nginx",
      "git clone https://github.com/nustiueudinastea/ansible-consul.git /root/ansible/ansible-consul",
      "git clone https://github.com/angstwad/docker.ubuntu.git /root/ansible/docker",
      "ansible-playbook -i \"localhost,\" -c local --extra-vars '{\"INTERNAL_IP\":\"${digitalocean_droplet.dbs2.ipv4_address_private}\", \"CONSUL_ENDPOINT\":\"${digitalocean_droplet.dbm0.ipv4_address_private}\", \"HOSTNAME\":\"dbs2\"}' /root/local_playbook.yml",
      "pip install docker-compose",
      "service docker restart"
      ]
  }
}
