terraform {
  cloud {
    organization = "lfccalegari"

    workspaces {
      name = "demo"
    }
  }
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.19.0"
    }
    linode = {
      source  = "linode/linode"
      version = "1.27.0"
    }
    google = {
      source = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "digitalocean" {
  token = var.digitalocean_token
}

provider "linode" {
  token = var.linode_token
}

data "digitalocean_ssh_key" "default" {
  name = "default"
}

data "linode_sshkey" "default" {
  label = "default"
}

provider "google" {
  credentials = {
    "type": "service_account",
    "project_id": "lively-transit-268912",
    "private_key_id": "14bac7040f8319c4733fcddbbb004463b3dbcb90",
    "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCgeyk1CpEG0thz\nzWb3+0lVF5UiYN1NYnMxNoq1dTNex5WM+CKqc1z+XLz9kUGUu2RPJBJ+3fM4Z+Ua\n11hhK/Hlx24AeftQITM3JLcZX1bd4BObIr2jS5++J3hh83oRAHXSLpddZPBk9/4d\nGY7R7Uf7r6pqVCdITCD0KlLhiT63ovnfRDEEITDxH4qjuiiOcyFPnC6HNCZFMoWK\nMjxvMk7JDYd2WTbVHn4ccOwBuSEv6x8rLbF2puTJLmq4rvPdxnavtuscCWRPinD+\nwIn59rPMlAPAuViwYZ4lVoRwlJ5s+i2BsxKYiieisHKPzfxmVwCbolH/7auE6UoL\neYmoggLHAgMBAAECggEACJ2kIDdhguLGAS2ZZh3lGX7rIE3gA7wR4CYD+2r/54pC\nkq9tuQX5i6Rx9xEZ2sDWyVLv9US4PqKBT9gY5BqmYYY79yWVYv9tTvwXInMWaFIT\n62PJl59DQ8O9uFCIkKocKT0cHkUBjQItb+WD3+xjzXToas36z+xaZpFxIq+qINS2\nwYdx+ssOFFdgY8xAueYt0XVOJkOe7kHF8461xXGGpbOLu6lD1RTTc5llOCjLSyEd\nTVrwYIdHIrutTh9n4emsabK8r+d2IZlu9Cl2SnS8HuCV6e0FEDYrkgX99eNtzlOS\n8RJi7Uo5/VpkH6C7m11KbtsGQfNtANPU0cztXHQQvQKBgQDgn/xBxe7AEYG9hx0p\nGqtQJ5JMpfN3Ilqj54adnuZah1XER2LkbcB6pUVugWyUP6mWL4C8L7LS9JiSgkPx\noG88xhT5V7lqr/3fqpgAmYbdq6YuwiAN1O6E6TGLbtRJN1dsEq20c1YzvGVxkRmD\n+9+qZX67jIwDxgddFrd7mx5VbQKBgQC25Y4umRshkxPxn61LQV2u6eTgfhA/0yh7\nfsCfo6NLOQJYLWXlrX6kqrryRjNX3e13xym4vqEmT6IaAClOwhWJxjA7R2ApRoZO\nfkqgl7HlN8KXqJEk7u6MgZ/A4e13GKZ7ryt+QVlnJJUuwi422oV3c4zTBhXO3wRw\nT8K7/Vn8gwKBgQCPR/3UxrkAcypbBvCm44gbXOKJWeHvQE6o9mp76Hvvixw+U3rV\nUtzQXtPnJU9pUSKP1kU7xQFAZx1bdxR38GqETaXbVwXC8/fw0BSdbVEF3RPoB5QC\nvqxWw5kC4/MtsMtm+JMs49U8sxPSWUf5VJTbUFqCr6gwUAUqb+8iPVQgEQKBgByk\nMDLd6SDF3o6tGb86OkiE+kGpnDPShnlobRPS1WSXReW3HkjsdXOmBOah1bKB34kt\nWDxFJglQ2SrHMbDStfrAXZc64zUzhR7PqjIh70rdA40qaahl/ldkiTb0anKHGrMt\nyFraMvzy/qW25PPUHqiJINl/D3U4+YH5C57S2v+vAoGAbvwLNHESob1EAPXE761X\nEEmSb8XO9/Tc0DeEerqGAEroPERtBGRW9ZMIwRILYZ0LYlRn3v+yuN3376C/PPpu\nc6IWynivFDQkvAxu7ddHHgPHx3Y8xQw+uwgHvt0zyv0TUVrAp6Keu2Giwf284yrQ\n9uG+2Uwir02xu+3MgZ3dHKM=\n-----END PRIVATE KEY-----\n",
    "client_email": "treinamento@lively-transit-268912.iam.gserviceaccount.com",
    "client_id": "105333029772708131412",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/treinamento%40lively-transit-268912.iam.gserviceaccount.com"
  }

  project = "lively-transit-268912"
  region  = "us-central1"
  zone    = "us-central1-c"
}

resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}

resource "digitalocean_droplet" "cluster-manager" {
  image    = "debian-10-x64"
  name     = "cluster-manager"
  region   = "nyc1"
  size     = "s-2vcpu-4gb"
  ssh_keys = [data.digitalocean_ssh_key.default.id]

  provisioner "remote-exec" {
    inline = [
      "hostnamectl set-hostname cluster-manager",
      "apt -y update",
      "sleep 5",
      "apt -y upgrade",
      "apt -y install curl wget htop unzip dnsutils",
      "export K3S_TOKEN=${var.k3s_token}",
      "curl -sfL https://get.k3s.io | sh -",
      "kubectl apply -n portainer -f https://raw.githubusercontent.com/portainer/k8s/master/deploy/manifests/portainer/portainer-lb.yaml"#,
      #"export DD_AGENT_MAJOR_VERSION=7",
      #"export DD_API_KEY=${var.datadog_agent_key}",
      #"export DD_SITE=datadoghq.com",
      #"curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script.sh -o install_script.sh",
      #"chmod +x ./install_script.sh",
      #"./install_script.sh"
    ]

    connection {
      type        = "ssh"
      user        = "root"
      agent       = false
      private_key = var.digitalocean_ssh_key
      host        = self.ipv4_address
    }
  }
}

resource "linode_instance" "cluster-worker" {
  label           = "cluster-worker"
  image           = "linode/debian10"
  region          = "eu-central"
  type            = "g6-standard-2"
  authorized_keys = [data.linode_sshkey.default.ssh_key]
  depends_on      = [digitalocean_droplet.cluster-manager]

  provisioner "remote-exec" {
    inline = [
      "hostnamectl set-hostname cluster-worker",
      "apt -y update",
      "sleep 5",
      "apt -y upgrade",
      "apt -y install curl wget htop unzip dnsutils",
      "export K3S_URL=https://${digitalocean_droplet.cluster-manager.ipv4_address}:6443",
      "export K3S_TOKEN=${var.k3s_token}",
      "curl -sfL https://get.k3s.io | sh -"#,
      #"export DD_AGENT_MAJOR_VERSION=7",
      #"export DD_API_KEY=${var.datadog_agent_key}",
      #"export DD_SITE=datadoghq.com",
      #"curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script.sh -o install_script.sh",
      #"chmod +x ./install_script.sh",
      #"./install_script.sh"
    ]

    connection {
      type        = "ssh"
      user        = "root"
      agent       = false
      private_key = var.linode_ssh_key
      host        = self.ip_address
    }
  }
}

output "cluster-manager-ip" {
  value = digitalocean_droplet.cluster-manager.ipv4_address
}