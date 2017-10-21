#!/usr/bin/env bash

# Installation
echo "DOWNLOAD"
curl -L https://install.perlbrew.pl | bash
 
# Initialize
echo "INIT"
perlbrew init

# source
echo "SOURCE"
source ~/perl5/perlbrew/etc/bashrc
 
# See what is available
echo "AVAIL"
perlbrew available
 
# Install some Perls
echo "INSTALL"
perlbrew install 5.10.1

# See what were installed
echo "LIST"
perlbrew list
 
# Swith to an installation and set it as default
perlbrew switch perl-5.10.1
