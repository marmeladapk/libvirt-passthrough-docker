#!/bin/bash

xhost +local:root
docker container exec qemud virt-manager
xhost -local:root
