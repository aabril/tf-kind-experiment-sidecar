terraform {
  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = "~> 0.0.19"
    }
  }
}

provider "kind" {
}

resource "kind_cluster" "default" {
  name = "el-kind-cluster"
  wait_for_ready = true
  kind_config {
    kind = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    node {
      role = "control-plane"
    }

    node {
      role = "worker"
    }

    node {
      role = "worker"
    }
  }
}

provider "kubernetes" {
    config_path = "~/.kube/config"
}

resource "kubernetes_deployment" "color" {
    metadata {
        name = "color-blue-dep"
        labels = {
            app   = "color"
            color = "blue"
        } 
    } 
    
    spec {
        selector {
            match_labels = {
                app   = "color"
                color = "blue"
            } 
        } 
        replicas = 3

        template { 
            metadata {
                labels = {
                    app   = "color"
                    color = "blue"
                } 
            } 
            spec {
                container {
                    image = "itwonderlab/color"   
                    name  = "color-blue"         
                    
                    env { 
                        name = "COLOR"
                        value = "blue"
                    } 
                    
                    port { 
                        container_port = 8080
                    }
                    
                    resources {
                        limits = {
                            cpu    = "0.5"
                            memory = "512Mi"
                        } 
                        requests = {
                            cpu    = "250m"
                            memory = "50Mi"
                        } 
                    } 
                } 
            } 
        }
    } 
} 
