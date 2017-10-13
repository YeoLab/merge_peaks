#!/bin/bash

export PATH="/home/bay001/projects/codebase/merge_peaks/bin:$PATH"

full_to_bed.py \
--input /home/bay001/projects/codebase/merge_peaks/data/204_01.basedon_204_01.peaks.l2inputnormnew.bed.full.compressed2.bed.full.annotated_proxdist.entropy \
--output /home/bay001/projects/codebase/merge_peaks/data/pipeline_outputs/204_01.basedon_204_01.peaks.l2inputnormnew.bed.full.compressed2.bed.full.annotated_proxdist.entropy.bed;

full_to_bed.py \
--input /home/bay001/projects/codebase/merge_peaks/data/204_02.basedon_204_02.peaks.l2inputnormnew.bed.full.compressed2.bed.full.annotated_proxdist.entropy \
--output /home/bay001/projects/codebase/merge_peaks/data/pipeline_outputs/204_02.basedon_204_02.peaks.l2inputnormnew.bed.full.compressed2.bed.full.annotated_proxdist.entropy.bed;

