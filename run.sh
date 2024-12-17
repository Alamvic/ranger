#!/usr/bin/env bash
# Bash3 Boilerplate. Copyright (c) 2014, kvz.io

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

# Set magic variables for current file & dir
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

#Build out of source
mkdir build
cd build

wget -O - get.pharo.org/120+vm | bash
./pharo Pharo.image eval --save "Metacello new baseline: 'Ranger'; repository: 'gitlocal://${__dir}'; load"
nohup ./pharo Pharo.image eval "MutationsExperiment main" > log.txt 2>&1 &

zip results.zip *.json log.txt
