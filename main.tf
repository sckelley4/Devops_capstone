# Google Cloud provider
provider "google" {
  credentials = file("/Users/sckelley/Downloads/devsecop-captsone-cf7a1a3762eb.json")
  project     = "devsecop-captsone"
  region      = "us-south1"   # Replace with desired region
}

# Kubernetes Engine cluster
resource "google_container_cluster" "my_cluster" {
  name               = "my-gke-cluster"
  location           = "us-south1"   # Replace with desired region
  initial_node_count = 2               # Number of initial nodes in the cluster

  node_config {
    machine_type = "n1-standard-2"     # Replace with desired machine type
    disk_size_gb = 30                  # Replace with desired node disk size (in GB)
  }

  # Optional: Enable network policy (if needed)
  network_policy {
    enabled = true
  }
}

# tags for the worker nodes
resource "google_compute_instance" "cluster_worker_tags" {
  count        = google_container_cluster.my_cluster.initial_node_count
  project      = "devsecop-captsone"    # Replace with GCP project ID
  name         = "node-${count.index + 1}"  # Generate unique names for the instances
  zone         = "us-south1-a"          # Replace with desired zone
  machine_type = "n1-standard-2"          # Replace with desired machine type
  tags         = ["web", "api"]           # Specify the desired tags for the worker nodes

  network_interface {
    # specify the network and subnetwork if needed.
    # If not specified, it will use the default network and subnetwork.
  }

  boot_disk {
    auto_delete = true
    initialize_params {
      size = 30  # Replace with the desired size of the boot disk (in GB)
      # specify other disk initialization parameters here if needed.
    }
  }
}

# null_resource to trigger the local-exec provisioner
resource "null_resource" "get_kubeconfig" {
  depends_on = [google_container_cluster.my_cluster]

  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials my-gke-cluster --region=us-central1 --project=devsecop-captsone"
  }
}

# Output the kubeconfig file path
output "kubeconfig_file_path" {
  value = "kubeconfig.txt"
}

# local_file data source to read the kubeconfig from the file
data "local_file" "kubeconfig" {
  depends_on = [null_resource.get_kubeconfig]

  filename = "kubeconfig.txt"
}

# Output the content of the kubeconfig
output "kubeconfig_content" {
  value = data.local_file.kubeconfig.content
}
