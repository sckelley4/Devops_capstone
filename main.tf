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

  # Optional: Enable autoscaling
  autoscaling {
    min_node_count = 3                 # Minimum number of nodes in the cluster
    max_node_count = 5                 # Maximum number of nodes in the cluster
  }

  # Optional: Add labels to the cluster (if needed)
  labels = {
    env = "dev"
  }

  # Optional: Add tags to the cluster (if needed)
  tags = ["web", "api"]

  # Optional: Enable network policy (if needed)
  network_policy {
    enabled = true
  }

  # Optional: Enable HTTP load balancing (if needed)
  http_load_balancing {
    disabled = false
  }

  # Optional: Enable Kubernetes dashboard (if needed)
  # Addons are disabled by default. Uncomment this block to enable the dashboard.
  # addon {
  #   name = "KubernetesDashboard"
  #   enabled = true
  # }
}

# Output the kubeconfig for kubectl to use
output "kubeconfig" {
  value = google_container_cluster.my_cluster.master_auth[0].kubeconfig
}
