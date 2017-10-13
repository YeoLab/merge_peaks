#!/bin/bash

python input_norm.py \
--peaks /home/bay001/projects/codebase/merge_peaks/data/204_02_RBFOX2.merged.r2.peaks.bed \
--ip_bam /home/bay001/projects/codebase/merge_peaks/data/204_02_RBFOX2.merged.r2.bam \
--input_bam /home/bay001/projects/codebase/merge_peaks/data/RBFOX2-204-INPUT_S2_R1.unassigned.adapterTrim.round2.rmRep.rmDup.sorted.r2.bam \
--out /home/bay001/projects/codebase/merge_peaks/data/204_02_RBFOX2.merged.r2.peaks.inputnorm.bed \
--out_full /home/bay001/projects/codebase/merge_peaks/data/204_02_RBFOX2.merged.r2.peaks.inputnorm.bed.full
