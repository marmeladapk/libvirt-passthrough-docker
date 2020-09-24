#!/bin/bash

# docker build -t lg-build . && ./start.sh

rm -rf ./LookingGlass
git clone --recursive https://github.com/gnif/LookingGlass
cd LookingGlass
git checkout B2-rc4
git apply ../root.patch
cd ..

docker run --rm -it \
    --name lg-build \
    -v `pwd`/LookingGlass:/LookingGlass \
    lg-build:latest

sudo chown $USER:$USER -R ./LookingGlass

