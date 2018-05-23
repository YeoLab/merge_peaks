#!/bin/bash

BINDIR=bin/

conda create -y -n merge-peaks python=3.4.5;
source activate merge-peaks;
conda install -y numpy=1.11 pandas=0.20 scipy=0.18 setuptools=27.2 matplotlib=2.0 samtools=1.5; # mostly IDR dependencies



### Install these if you want perl 5.22 with nondeterministic hashes ###
conda install -y -c bioconda \
perl=5.22.0 \
perl-app-cpanminus;

### bioconda channel ###
conda install -y -c bioconda \
samtools=1.5 \
bedtools=2.25.0 \
pysam \
pybedtools \
pybigwig;

### anaconda channel ###
conda install -y -c anaconda \
cython \
pycrypto \
pytest \
pandas \
numpy \
zlib=1.2;

conda install -y -c r r-base;

cpanm Statistics::Basic;
cpanm Statistics::Distributions;
cpanm Statistics::R;
###

cd $BINDIR
wget https://github.com/nboley/idr/archive/2.0.2.zip;
unzip 2.0.2.zip;
cd idr-2.0.2/;

python3 setup.py install;

pip install cwlref-runner;

cd ../../;
export PATH=${PWD}/bin:$PATH
export PATH=${PWD}/bin/perl:$PATH
export PATH=${PWD}/cwl:$PATH
export PATH=${PWD}/wf:$PATH;
