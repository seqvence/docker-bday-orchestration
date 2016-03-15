resource "digitalocean_domain" "dbm1" {
    name = "dbm1.do.lab.seqvence.com"
    ip_address = "${digitalocean_droplet.dbm1.ipv4_address}"
}

resource "digitalocean_droplet" "dbm1" {
    image = "ubuntu-14-04-x64"
    name = "dbm1"
    region = "ams3"
    size = "2gb"
    private_networking = true
    ssh_keys = [
      "${var.ssh_fingerprint_1}",
      "${var.ssh_fingerprint_2}",
      "${var.ssh_fingerprint_3}"
    ]
}

resource "null_resource" "dbm1" {

  connection {
      user = "root"
      type = "ssh"
      key_file = "${var.pvt_key}"
      timeout = "6m"
      host = "${digitalocean_droplet.dbm1.ipv4_address}"
  }

  provisioner "file" {
      source = "ansible-playbooks/manager.yml"
      destination = "/root/local_playbook.yml"
  }

  provisioner "remote-exec" {
    inline = [
        "mkdir -p /root/ansible"
    ]
  }

  provisioner "file" {
      source = "ansible-playbooks/manager"
      destination = "/root/ansible/manager"
  }

  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      "apt-get update -y; apt-get install -y software-properties-common; apt-add-repository -y ppa:ansible/ansible; apt-get update -y; apt-get install -y ansible git; apt-get -y install python-pip",
      "git clone https://github.com/weareinteractive/ansible-nginx.git /root/ansible/franklinkim.nginx",
      "git clone https://github.com/nustiueudinastea/ansible-consul.git /root/ansible/ansible-consul",
      "git clone https://github.com/angstwad/docker.ubuntu.git /root/ansible/docker",
      "ansible-playbook -i \"localhost,\" -c local --extra-vars '{\"INTERNAL_IP\":\"${digitalocean_droplet.dbm1.ipv4_address_private}\", \"CONSUL_ENDPOINT\":\"${digitalocean_droplet.dbm1.ipv4_address_private}\", \"HOSTNAME\":\"dbm1\", \"BOOTSTRAP\": false, \"CONSUL_ENDPOINT\":\"${digitalocean_droplet.dbm0.ipv4_address_private}\", \"JOIN\": true}' /root/local_playbook.yml",
      "pip install docker-compose",
      "service docker restart"
      ]
  }
}
