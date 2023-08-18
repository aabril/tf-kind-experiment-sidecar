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
        replicas = 1

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

                # Sidecar responsible of running load-policies script
                # container {
                #     name    = "sidecar"
                #     image   = "alpine:3.18.3"
                #     command = ["sh", "-c", "./script.sh"]
                # }

                container {
                    name    = "sidecar"
                    # image   = "alpine:3.18.3"
                    image = "docker.io/kubernetes/kubectl"
                    command = ["/bin/sh", "-c"]
                    args    = [<<EOF
#!/bin/sh

# Get the namespace and pod name
NAMESPACE=$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace)
POD_NAME=$(hostname) 

# Watch for events related to the pod
kubectl get events --namespace="$NAMESPACE" --field-selector=involvedObject.name="$POD_NAME" --watch-only=true | \
while read -r line; do
    # Parse the event to check if it's a redeployment event
    if echo "$line" | grep -q "Reason=Started"; then
        echo "Sibling container redeployed! Launching your command..."
        echo "NAMESPACE: "$NAMESPACE
        echo "POD_NAME: "$POD_NAME
    fi
done
EOF
                ]



                } 
            }
        } 
    } 
}