[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-v2.0%20adopted-ff69b4.svg)](meta/CODE_OF_CONDUCT.md)

# kubeflow-playground

Origin: https://github.com/lisy09/kubeflow-playground

This is a project to ....

It is inspired by the [...](https://github.com/lisy09/kubeflow-playground) project and add additional features.

## License
See the [LICENSE](LICENSE.md) file for license rights and limitations.

## Contributing

Please check [CONTRIBUTING.md](meta/CONTRIBUTING.md).

## Directory

- `scripts/`: scripts for building/running
- `.env`: env file used in scripts
- `Makefile`: GNU Make Makefile as quick command entrypoint

## How to Use

### Prerequisite

- The environment for build needs to be linux/amd64 or macos/amd64
- The environemnt for build needs [docker engine installed](https://docs.docker.com/engine/install/)
- have [docker-compose](https://docs.docker.com/compose/install/) installed
- The environemnt for build needs GNU `make` > 3.8 installed
- The environemnt for build needs `bash` shell

### Build command

To build all docker images locally:
```bash
make all
```

To push built docker images to the remote registry:
```bash
make push
```

To delete built local docker images:
```bash
make clean
```

Or you can check `./Makefile` for more details.


## for microk8s

```bash
sudo snap refresh microk8s --classic --channel=edge

sudo daemonize /usr/bin/unshare --fork --pid --mount-proc /lib/systemd/systemd --system-unit=basic.target
exec sudo nsenter -t (pidof systemd | awk 'NF>1{print $NF}') -a su - $LOGNAME
exec sudo nsenter -t (pidof systemd) -a su - $LOGNAME

mkdir -p ~/.kube && microk8s.config -l  | sed "s/:8080/:$API_PORT/" | sudo tee /var/snap/microk8s/current/kubelet.config > ~/.kube/microk8s.config
```