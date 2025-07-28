# Prerequisites

## Getting Gateway API up and running

Run this script to set up the gateway:

https://github.com/llm-d/llm-d-deployer/blob/main/chart-dependencies/istio/install.sh

- Installed Istio 2.6
- Installed Kiali 2.4.7

Run:
```
oc adm policy add-cluster-role-to-user cluster-admin -z ingress-operator -n openshift-ingress-operator
clusterrole.rbac.authorization.k8s.io/cluster-admin added: "ingress-operator"

oc patch featuregates/cluster --type=merge --patch='{"spec":{"featureSet":"CustomNoUpgrade","customNoUpgrade":{"enabled":["GatewayAPI"]}}}'
```

This should return Gateway Stuff
```
oc get crd gatewayclasses.gateway.networking.k8s.io httproutes.gateway.networking.k8s.io gateways.gateway.networking.k8s.io referencegrants.gateway.networking.k8s.io

Returns:
NAME                                       CREATED AT
gatewayclasses.gateway.networking.k8s.io   2023-04-04T18:02:55
httproutes.gateway.networking.k8s.io        2023-04-04T18:02:55Z
gateways.gateway.networking.k8s.io          2023-04-04T18:02:55Z
referencegrants.gateway.networking.k8s.io   2023-04-04T18:02:56Z
```

Followed this:
https://github.com/openshift/network-edge-tools/blob/main/docs/blogs/EnhancedDevPreviewGatewayAPI/GettingStarted.md

## Disabled Peer Authentication


Had to disable tls with:

```sh
cat <<'EOF' | kubectl apply -f -
apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata:
  name: vllm-plaintext
  namespace: llm-d
spec:
  selector:
    matchLabels:
      app: vllm-llama3-8b-instruct
  mtls:
    mode: DISABLE
---
apiVersion: networking.istio.io/v1beta1
kind: DestinationRule
metadata:
  name: vllm-plaintext
  namespace: llm-d
spec:
  host: vllm-llama3-8b-instruct.llm-d.svc.cluster.local
  trafficPolicy:
    tls:
      mode: DISABLE
EOF
```


Using this folder as I explore installing Kuadrant on my Openshift Cluster.


1. Install the [Connectivity Operator](openshift-objects/connectivity-subscription.yaml)
2. Install the [Kuadrant Control Plane](openshift-objects/kuadrant.yaml)
3. Install the [Limitador](openshift-objects/limitador.yaml)
   - This is created by Kuadrant but needs to be updated
4. Install the [Gateway](openshift-objects/gateway/istio-gateway.yaml)
