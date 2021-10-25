#!/usr/bin/env bash

readonly SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
readonly ROOT_DIR="$( cd $SCRIPT_DIR/.. >/dev/null 2>&1 && pwd )"
source $ROOT_DIR/.env

COMMANDS=kustomize,kubectl
IFS=',' read -a commands <<< ${COMMANDS}
for COMMAND in ${commands[@]}; do
    if ! command -v ${COMMAND} &> /dev/null; then
        echo "Command could not be found: ${COMMAND}"
        exit 1
    fi
done

set -e
set -x

cd $ROOT_DIR/$MANIFEST_TARGET_DIR

kustomize build common/cert-manager/cert-manager/base | kubectl apply -f -
kustomize build common/cert-manager/kubeflow-issuer/base | kubectl apply -f -

kustomize build common/istio-1-9/istio-crds/base | kubectl apply -f -
kustomize build common/istio-1-9/istio-namespace/base | kubectl apply -f -
kustomize build common/istio-1-9/istio-install/base | kubectl apply -f -

kustomize build common/dex/overlays/istio | kubectl apply -f -

kustomize build common/oidc-authservice/base | kubectl apply -f -

kustomize build common/knative/knative-serving/base | kubectl apply -f -
kustomize build common/istio-1-9/cluster-local-gateway/base | kubectl apply -f -
kustomize build common/knative/knative-eventing/base | kubectl apply -f -

kustomize build common/kubeflow-namespace/base | kubectl apply -f -

kustomize build common/istio-1-9/kubeflow-istio-resources/base | kubectl apply -f -

kustomize build common/kubeflow-roles/base | kubectl apply -f -

kustomize build apps/profiles/upstream/overlays/kubeflow | kubectl apply -f -
kustomize build apps/pipeline/upstream/env/platform-agnostic-multi-user | kubectl apply -f -

if [ $ENABLE_KFSERVING == "true" ]; then
    kustomize build apps/kfserving/upstream/overlays/kubeflow | kubectl apply -f -
fi

if [ $ENABLE_KATIB == "true" ]; then
    kustomize build apps/katib/upstream/installs/katib-with-kubeflow | kubectl apply -f -
fi

kustomize build apps/centraldashboard/upstream/overlays/istio | kubectl apply -f -

kustomize build apps/admission-webhook/upstream/overlays/cert-manager | kubectl apply -f -

kustomize build apps/jupyter/notebook-controller/upstream/overlays/kubeflow | kubectl apply -f -
kustomize build apps/jupyter/jupyter-web-app/upstream/overlays/istio | kubectl apply -f -

kustomize build apps/tensorboard/tensorboards-web-app/upstream/overlays/istio | kubectl apply -f -
kustomize build apps/tensorboard/tensorboard-controller/upstream/overlays/kubeflow | kubectl apply -f -

kustomize build apps/training-operator/upstream/overlays/kubeflow | kubectl apply -f -
kustomize build apps/mpi-job/upstream/overlays/kubeflow | kubectl apply -f -

kustomize build common/user-namespace/base | kubectl apply -f -

kubectl patch configmap workflow-controller-configmap -n kubeflow --patch '{"data": {"containerRuntimeExecutor": "pns"}}'