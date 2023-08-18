terraform {
  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = "~> 0.0.19"
    }
  }
}

provider "kind" {}

resource "kind_cluster" "default" {
    name = "test-cluster"
}
