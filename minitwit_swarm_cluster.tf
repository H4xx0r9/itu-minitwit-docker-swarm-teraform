
#  _                _
# | | ___  __ _  __| | ___ _ __
# | |/ _ \/ _` |/ _` |/ _ \ '__|
# | |  __/ (_| | (_| |  __/ |
# |_|\___|\__,_|\__,_|\___|_|

# =========================
# DISABLED: SWARM LEADER
# (existing infrastructure managed outside Terraform)
# =========================

#resource "digitalocean_droplet" "minitwit-swarm-leader" {
#  image  = "ubuntu-22-04-x64"
#  name   = "webserver"
#  region = var.region
#  size   = "s-1vcpu-1gb"
#
#  ssh_keys = [digitalocean_ssh_key.minitwit.fingerprint]
#
#  connection {
#    user        = "root"
#    host        = self.ipv4_address
#    type        = "ssh"
#    private_key = file(var.pvt_key)
#    timeout     = "2m"
#  }
#
#  provisioner "file" {
#    source      = "stack/minitwit_stack.yml"
#    destination = "/root/minitwit_stack.yml"
#  }
#
#  provisioner "remote-exec" {
#    inline = [
#      "ufw allow 2377/tcp",
#      "ufw allow 7946",
#      "ufw allow 4789/udp",
#      "ufw allow 80",
#      "ufw allow 8080",
#      "ufw allow 8888",
#      "ufw allow 22",
#
#      "docker swarm init --advertise-addr ${self.ipv4_address}"
#    ]
#  }
#}

# =========================
# DISABLED: TOKEN GENERATION
# =========================

#resource "null_resource" "swarm-worker-token" {
#  depends_on = [digitalocean_droplet.minitwit-swarm-leader]
#
#  provisioner "local-exec" {
#    command = "ssh -o 'ConnectionAttempts 3600' -o 'StrictHostKeyChecking no' root@<LEADER_IP> -i ssh_key/terraform 'docker swarm join-token worker -q' > temp/worker_token"
#  }
#}
#
#resource "null_resource" "swarm-manager-token" {
#  depends_on = [digitalocean_droplet.minitwit-swarm-leader]
#
#  provisioner "local-exec" {
#    command = "ssh -o 'ConnectionAttempts 3600' -o 'StrictHostKeyChecking no' root@<LEADER_IP> -i ssh_key/terraform 'docker swarm join-token manager -q' > temp/manager_token"
#  }
#}


#  _ __ ___   __ _ _ __   __ _  __ _  ___ _ __
# | '_ ` _ \ / _` | '_ \ / _` |/ _` |/ _ \ '__|
# | | | | | | (_| | | | | (_| | (_| |  __/ |
# |_| |_| |_|\__,_|_| |_|\__,_|\__, |\___|_|
#                              |___/

# =========================
# DISABLED: SWARM MANAGERS
# (existing infrastructure, not managed by Terraform)
# =========================

#resource "digitalocean_droplet" "minitwit-swarm-manager" {
#  depends_on = [null_resource.swarm-manager-token]
#
#  count  = 1
#  image  = "ubuntu-22-04-x64"
#  name   = "webserver-monitoring"
#  region = var.region
#  size   = "s-1vcpu-1gb"
#
#  ssh_keys = [digitalocean_ssh_key.minitwit.fingerprint]
#
#  connection {
#    user        = "root"
#    host        = self.ipv4_address
#    type        = "ssh"
#    private_key = file(var.pvt_key)
#    timeout     = "2m"
#  }
#
#  provisioner "file" {
#    source      = "temp/manager_token"
#    destination = "/root/manager_token"
#  }
#
#  provisioner "remote-exec" {
#    inline = [
#      "ufw allow 2377/tcp",
#      "ufw allow 7946",
#      "ufw allow 4789/udp",
#      "ufw allow 80",
#      "ufw allow 8080",
#      "ufw allow 8888",
#      "ufw allow 22",
#
#      "docker swarm join --token $(cat manager_token) <LEADER_IP>"
#    ]
#  }
#}


#                     _
# __      _____  _ __| | _____ _ __
# \ \ /\ / / _ \| '__| |/ / _ \ '__|
#  \ V  V / (_) | |  |   <  __/ |
#   \_/\_/ \___/|_|  |_|\_\___|_|
#
# =========================
# DISABLED: SWARM WORKERS
# (existing infrastructure, not managed by Terraform)
# =========================

#resource "digitalocean_droplet" "minitwit-swarm-worker" {
#  depends_on = [null_resource.swarm-worker-token]
#
#  count  = 1
#  image  = "ubuntu-22-04-x64"
#  name   = "webserver-test"
#  region = var.region
#  size   = "s-1vcpu-1gb"
#
#  ssh_keys = [digitalocean_ssh_key.minitwit.fingerprint]
#
#  connection {
#    user        = "root"
#    host        = self.ipv4_address
#    type        = "ssh"
#    private_key = file(var.pvt_key)
#    timeout     = "2m"
#  }
#
#  provisioner "file" {
#    source      = "temp/worker_token"
#    destination = "/root/worker_token"
#  }
#
#  provisioner "remote-exec" {
#    inline = [
#      "ufw allow 2377/tcp",
#      "ufw allow 7946",
#      "ufw allow 4789/udp",
#      "ufw allow 80",
#      "ufw allow 8080",
#      "ufw allow 8888",
#      "ufw allow 22",
#
#      "docker swarm join --token $(cat worker_token) <LEADER_IP>"
#    ]
#  }
#}

# =========================
# STATIC OUTPUTS (existing swarm)
# =========================

output "minitwit-swarm-leader-ip-address" {
  value = "<LEADER_IP>"
}

output "minitwit-swarm-manager-ip-address" {
  value = [
    "<MANAGER_1_IP>"
  ]
}

output "minitwit-swarm-worker-ip-address" {
  value = [
    "<WORKER_1_IP>"
  ]
}
