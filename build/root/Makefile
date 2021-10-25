DBG_MAKEFILE ?=
ifeq ($(DBG_MAKEFILE),1)
    $(warning ***** starting Makefile for goal(s) "$(MAKECMDGOALS)")
    $(warning ***** $(shell date))
else
    MAKEFLAGS += -s
endif

SHELL := /usr/bin/env bash

# Define variables so help command work
PRINT_HELP ?=

# Don't need make's built-in rules
MAKEFLAGS += --no-builtin-rules

ROOT_DIR=${PWD}
BUILD_DIR = ${ROOT_DIR}/build
BUILD_ROOT_DIR=${BUILD_DIR}/root

include ${BUILD_ROOT_DIR}/local-k8s.mk

all: incremental-tasks alway-run-tasks

.PHONY: incremental-tasks
incremental-tasks:

.PHONY: alway-run-tasks  
alway-run-tasks: 

.PHONY: docker-images
docker-images:

SCRIPTS_DIR=${ROOT_DIR}/scripts

.PHONY: update-manifests
update-manifests:
	${SCRIPTS_DIR}/update_manifest_upstream.sh

.PHONY: deploy
deploy:
	${SCRIPTS_DIR}/deploy.sh

.PHONY: undeploy
undeploy:
	${SCRIPTS_DIR}/undeploy.sh

.PHONY: forward
forward:
	${SCRIPTS_DIR}/forward.sh