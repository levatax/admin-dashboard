terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }
  }
}

variable "hcloud_token" {
  sensitive = true
}

provider "hcloud" {
  token = var.hcloud_token
}

resource "hcloud_ssh_key" "my_mac" {
  name       = "my-mac-key"
  public_key = file("~/.ssh/id_ed25519.pub")
}

resource "hcloud_server" "test_node" {
  name        = "nextjs-mongo-docker"
  image       = "ubuntu-24.04"
  server_type = "cx23" 
  location    = "nbg1"  
  ssh_keys    = [hcloud_ssh_key.my_mac.id]
  
  # This tells Terraform to upload and run your bash script
  user_data   = file("setup.sh") 
}

output "server_ip" {
  value = hcloud_server.test_node.ipv4_address
}