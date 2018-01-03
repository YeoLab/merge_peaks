#!/bin/bash

BINDIR=bin/

conda create -y -n merge-peaks python=3.4.5;
source activate merge-peaks;
conda install -y numpy=1.11 pandas=0.20 scipy=0.18 setuptools=27.2 matplotlib=2.0; # mostly IDR dependencies

cd $BINDIR
wget https://github.com/nboley/idr/archive/2.0.2.zip;
unzip 2.0.2.zip;
cd idr-2.0.2/;

python3 setup.py install;

pip install cwlref-runner;

export PATH=${PWD}/bin:$PATH
export PATH=${PWD}/bin/perl:$PATH
export PATH=${PWD}/cwl:$PATH

