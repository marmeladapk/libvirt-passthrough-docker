#!/bin/bash

cd LookingGlass
mkdir -p client/build
cd client/build
make clean
cmake ../
make

