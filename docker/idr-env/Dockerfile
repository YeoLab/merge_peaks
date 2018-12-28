################## BASE IMAGE ######################

FROM continuumio/miniconda:latest

################## METADATA ######################

LABEL base_image="continuumio/miniconda:latest"
LABEL version="1"
LABEL software="IDR"
LABEL software.version="2.0.2"
LABEL about.summary="The IDR (Irreproducible Discovery Rate) framework is a uniﬁed approach to measure the reproducibility of ﬁndings identiﬁed from replicate experiments and provide highly stable thresholds based on reproducibility. Unlike the usual scalar measures of reproducibility, the IDR approach creates a curve, which quantitatively assesses when the ﬁndings are no longer consistent across replicates. In layman's terms, the IDR method compares a pair of ranked lists of identifications (such as ChIP-seq peaks). These ranked lists should not be pre-thresholded i.e. they should provide identifications across the entire spectrum of high confidence/enrichment (signal) and low confidence/enrichment (noise). The IDR method then fits the bivariate rank distributions over the replicates in order to separate signal from noise based on a defined confidence of rank consistency and reproducibility of identifications i.e the IDR threshold."
LABEL about.home="https://github.com/nboley/idr"
LABEL about.documentation="https://github.com/nboley/idr/blob/master/README.md"
LABEL about.license_file="https://github.com/nboley/idr/blob/master/LICENSE"
LABEL about.license="GPL-2.0"
LABEL about.tags="Genomics"

################## MAINTAINER ######################
MAINTAINER Brian Yee <brian.alan.yee@gmail.com>

RUN apt-get update
# RUN apt-get upgrade --yes

RUN apt-get install -y unzip libblas-dev liblapack-dev python3-dev python3-numpy python3-setuptools python3-matplotlib libc-dev g++

RUN cd /opt/ && \
    wget https://github.com/nboley/idr/archive/2.0.2.zip && \
    unzip /opt/2.0.2.zip && \
    cd /opt/idr-2.0.2/ && \
    python3 setup.py install

WORKDIR /data/

CMD ["idr"]
