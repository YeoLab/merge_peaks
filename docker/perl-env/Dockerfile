################## BASE IMAGE ######################

FROM continuumio/miniconda:latest

################## METADATA ######################

LABEL base_image="continuumio/miniconda:latest"
LABEL version="1"
LABEL software="eCLIP Input Normalization"
LABEL software.version="0.0.1"
LABEL about.summary="Perl scripts for normalizing IP over size-matched input"
LABEL about.home="https://github.com/yeolab"
LABEL about.documentation=""
LABEL about.license_file=""
LABEL about.license=""
LABEL about.tags="Genomics"

################## MAINTAINER ######################
MAINTAINER Brian Yee <brian.alan.yee@gmail.com>

RUN apt-get update
RUN apt-get install -y apt-utils
RUN apt-get install -y libc-dev unzip zip build-essential
RUN apt-get install -y g++

RUN conda install -y gcc

ENV PERLBREW_ROOT=/perl5 \
PATH=/perl5/bin:/perl5/perls/perl-5.10.1/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:${PATH} \
PERLBREW_PERL=perl-5.10.1 \
PERLBREW_VERSION=0.73 \
PERLBREW_MANPATH=/perl5/perls/perl-5.10.1/man \
PERLBREW_PATH=/perl5/bin:/perl5/perls/perl-5.10.1/bin \
PERLBREW_SKIP_INIT=1

RUN bash -c '\wget -O - http://install.perlbrew.pl | bash' &&\
    /perl5/bin/perlbrew init

RUN /perl5/bin/perlbrew --notest install perl-5.10.1

RUN /perl5/bin/perlbrew install-cpanm

RUN /perl5/bin/perlbrew switch perl-5.10.1

RUN conda install -y -c r r=3.3.2 && \
    cpanm install Statistics::Basic && \
    cpanm install Statistics::Distributions && \
    ln -s /opt/conda/lib/libreadline.so.7 /opt/conda/lib/libreadline.so.6 && \
    cpanm install Statistics::R

## TODO: grab from input norm repo (private for now) ##
RUN cd /opt && \
    git clone https://github.com/YeoLab/merge_peaks

ENV PATH="/opt/merge_peaks/bin/perl:${PATH}"

WORKDIR /data/

CMD ["overlap_peakfi_with_bam.pl"]
