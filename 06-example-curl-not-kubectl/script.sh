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