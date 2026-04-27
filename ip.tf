resource "digitalocean_floating_ip" "public-ip" {
  region = var.region
}

# ATTACH FLOATING IP TO EXISTING DROPLET (manual ID)
resource "digitalocean_floating_ip_assignment" "public-ip" {
  ip_address = digitalocean_floating_ip.public-ip.ip_address
  droplet_id = 552985733
}

output "public_ip" {
  value = digitalocean_floating_ip.public-ip.ip_address
}