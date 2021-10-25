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

set -x


cd $ROOT_DIR/$MANIFEST_TARGET_DIR

kustomize build common/user-namespace/base | kubectl delete -f -

kustomize build apps/training-operator/upstream/overlays/kubeflow | kubectl delete -f -
kustomize build apps/mpi-job/upstream/overlays/kubeflow | kubectl delete -f -

kustomize build apps/tensorboard/tensorboard-controller/upstream/overlays/kubeflow | kubectl delete -f -
kustomize build apps/tensorboard/tensorboards-web-app/upstream/overlays/istio | kubectl delete -f -

kustomize build apps/jupyter/jupyter-web-app/upstream/overlays/istio | kubectl delete -f -
kustomize build apps/jupyter/notebook-controller/upstream/overlays/kubeflow | kubectl delete -f -

kustomize build apps/admission-webhook/upstream/overlays/cert-manager | kubectl delete -f -

kustomize build apps/centraldashboard/upstream/overlays/istio | kubectl delete -f -

if [ $ENABLE_KATIB == "true" ]; then
    kustomize build apps/katib/upstream/installs/katib-with-kubeflow | kubectl delete -f -
fi

if [ $ENABLE_KFSERVING == "true" ]; then
    kustomize build apps/kfserving/upstream/overlays/kubeflow | kubectl delete -f -
fi

kustomize build apps/pipeline/upstream/env/platform-agnostic-multi-user | kubectl delete -f -
kustomize build apps/profiles/upstream/overlays/kubeflow | kubectl delete -f -

kustomize build common/istio-1-9/kubeflow-istio-resources/base | kubectl delete -f -

kustomize build common/kubeflow-roles/base | kubectl delete -f -

kustomize build common/kubeflow-namespace/base | kubectl delete -f -

kustomize build common/knative/knative-eventing/base | kubectl delete -f -
kustomize build common/istio-1-9/cluster-local-gateway/base | kubectl delete -f -
kustomize build common/knative/knative-serving/base | kubectl delete -f -

kustomize build common/oidc-authservice/base | kubectl delete -f -

kustomize build common/dex/overlays/istio | kubectl delete -f -

kustomize build common/istio-1-9/istio-install/base | kubectl delete -f -
kustomize build common/istio-1-9/istio-namespace/base | kubectl delete -f -
kustomize build common/istio-1-9/istio-crds/base | kubectl delete -f -

kustomize build common/cert-manager/kubeflow-issuer/base | kubectl delete -f -
kustomize build common/cert-manager/cert-manager/base | kubectl delete -f -