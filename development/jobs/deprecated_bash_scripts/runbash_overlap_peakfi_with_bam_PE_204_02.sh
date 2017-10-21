#!/bin/bash

overlap_peakfi_with_bam_PE.pl \
/home/bay001/projects/codebase/merge_peaks/data/204_02_RBFOX2.merged.r2.bam \
/home/bay001/projects/codebase/merge_peaks/data/RBFOX2-204-INPUT_S2_R1.unassigned.adapterTrim.round2.rmRep.rmDup.sorted.r2.bam \
/home/bay001/projects/codebase/merge_peaks/data/204_02_RBFOX2.merged.r2.peaks.bed \
/home/bay001/projects/codebase/merge_peaks/data/rbfox2.txt.mapped_read_num \
/home/bay001/projects/codebase/merge_peaks/data/staged_outputs/204_02.RBFOX2.inputnorm.ericsversion.bed
