#!/bin/bash

export PATH="/home/bay001/projects/codebase/merge_peaks/bin:$PATH"

full_to_bed.py \
--input /home/bay001/projects/codebase/merge_peaks/data/pipeline_outputs/204_01.RBFOX2.inputnorm.ericsversioncwl.bed.full.compressed.bed.full.entropy \
--output /home/bay001/projects/codebase/merge_peaks/data/pipeline_outputs/204_01.RBFOX2.inputnorm.ericsversioncwl.bed.full.compressed.bed.full.entropy.bed;

full_to_bed.py \
--input /home/bay001/projects/codebase/merge_peaks/data/pipeline_outputs/204_02.RBFOX2.inputnorm.ericsversioncwl.bed.full.compressed.bed.full.entropy \
--output /home/bay001/projects/codebase/merge_peaks/data/pipeline_outputs/204_02.RBFOX2.inputnorm.ericsversioncwl.bed.full.compressed.bed.full.entropy.bed;

