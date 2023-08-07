# Define the Google Cloud provider
provider "google" {
  credentials = file("/Users/sckelley/Downloads/devsecop-captsone-cf7a1a3762eb.json")
  project     = "devsecop-captsone"
  region      = "us-central1"   # Replace with your desired region
}

# Define the Kubernetes Engine cluster
resource "google_container_cluster" "my_cluster" {
  name               = "my-gke-cluster"
  location           = "us-central1"   # Replace with your desired region
  initial_node_count = 3               # Number of initial nodes in the cluster

  node_config {
    machine_type = "n1-standard-2"     # Replace with your desired machine type
    disk_size_gb = 30                  # Replace with your desired node disk size (in GB)
  }

  # Optional: Enable network policy (if needed)
  network_policy {
    enabled = true
  }
}

# Define tags for the worker nodes
resource "google_compute_instance" "cluster_worker_tags" {
  count        = google_container_cluster.my_cluster.initial_node_count
  project      = "devsecop-captsone"    # Replace with your GCP project ID
  name         = "node-${count.index + 1}"  # Generate unique names for the instances
  zone         = "us-central1-a"          # Replace with your desired zone
  machine_type = "n1-standard-2"          # Replace with your desired machine type
  tags         = ["web", "api"]           # Specify the desired tags for the worker nodes

  network_interface {
    # You can specify the network and subnetwork if you want to use custom ones.
    # If not specified, it will use the default network and subnetwork.
  }

  boot_disk {
    auto_delete = true
    initialize_params {
      size = 30  # Replace with the desired size of the boot disk (in GB)
      # You can specify other disk initialization parameters here if needed.
    }
  }
}

# Output the kubeconfig for kubectl to use
output "kubeconfig" {
  value = google_container_cluster.my_cluster.master_auth[0].kubeconfig
}

# Provisioner to fetch kubeconfig and save it locally
resource "null_resource" "get_kubeconfig" {
  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials my-gke-cluster --region=us-central1 --project=devsecop-captsone && kubectl config view --raw --minify --flatten > kubeconfig.txt"
  }
}

# Data source to read the kubeconfig from the file
data "local_file" "kubeconfig" {
  filename = "kubeconfig.txt"
}

# Output the content of the kubeconfig
output "kubeconfig_content" {
  value = data.local_file.kubeconfig.content
}
