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

  resource_labels = {
    env = "dev"
  }

  tags = ["web", "api"]
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
}

resource "google_container_node_pool" "my_node_pool" {
  name       = "my-node-pool"
  cluster    = google_container_cluster.my_cluster.name
  node_count = 3
  autoscaling {
    min_node_count = 3
    max_node_count = 5
  }
}


resource "google_compute_target_http_proxy" "my_proxy" {
  name    = "my-http-proxy"
  url_map = google_compute_url_map.my_url_map.self_link
}

resource "google_compute_url_map" "my_url_map" {
  name = "my-url-map"

  default_route_action {
    url_redirect {
      https_redirect = true
      strip_query    = true
    }
  }
}

resource "google_compute_global_forwarding_rule" "my_forwarding_rule" {
  name                  = "my-forwarding-rule"
  target                = google_compute_target_http_proxy.my_proxy.self_link
  port_range            = "80"
  load_balancing_scheme = "EXTERNAL"
}

# Output the kubeconfig for kubectl to use
output "kubeconfig" {
  value = google_container_cluster.my_cluster.master_auth[0].kubeconfig
}
