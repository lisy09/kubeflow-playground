#!/usr/bin/env bash

readonly SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
readonly ROOT_DIR="$( cd $SCRIPT_DIR/.. >/dev/null 2>&1 && pwd )"
source $ROOT_DIR/.env

usage() {
  echo -n "Usage: ${0} " >&2
  echo -n "--branch BRANCH (git branch to be clone for kubeflow-manifest) " >&2
  echo >&2
}

COMMANDS=git
IFS=',' read -a commands <<< ${COMMANDS}
for COMMAND in ${commands[@]}; do
    if ! command -v ${COMMAND} &> /dev/null; then
        echo "Command could not be found: ${COMMAND}"
        exit 1
    fi
done

while [[ ${#} -gt 0 ]]; do
  parameter="${1}"

  case "${parameter}" in
    --branch|-b)
      branch="${2}"
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo "Invalid parameter: ${parameter}" >&2
      exit 1
      ;;
  esac

  shift
done

branch=${branch:-$DEFAULT_MANIFEST_BRANCH}

for parameter in branch; do
  if [[ -z ${!parameter} ]]; then
    echo "Missing ${parameter}" >&2
    echo >&2
    usage
    exit 1
  fi
done

echo "Cloning branch: $branch ..."

readonly CLONE_TARGET_DIR=$ROOT_DIR/$MANIFEST_TARGET_DIR
rm -rf $CLONE_ROOT_DIR
git clone --depth 1 --branch $branch $MANIFEST_UPSTREAM_REPO $CLONE_ROOT_DIR
rm -rf $CLONE_ROOT_DIR/.git