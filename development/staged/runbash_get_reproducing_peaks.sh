#!/bin/bash

perl /home/bay001/projects/codebase/merge_peaks/development/staged/get_reproducing_peaks.pl \
/home/bay001/projects/codebase/merge_peaks/development/staged/204.01v02.IDR.out \
/home/bay001/projects/codebase/merge_peaks/data/reference_outputs/204_01.basedon_204_01.peaks.l2inputnormnew.bed.full.compressed2.bed.full.annotated_proxdist.entropy \
/home/bay001/projects/codebase/merge_peaks/data/reference_outputs/204_02.basedon_204_02.peaks.l2inputnormnew.bed.full.compressed2.bed.full.annotated_proxdist.entropy \
/home/bay001/projects/codebase/merge_peaks/data/204_01_RBFOX2.merged.r2.bam \
/home/bay001/projects/codebase/merge_peaks/data/204_02_RBFOX2.merged.r2.bam \
/home/bay001/projects/codebase/merge_peaks/data/RBFOX2-204-INPUT_S2_R1.unassigned.adapterTrim.round2.rmRep.rmDup.sorted.r2.bam \
/home/bay001/projects/codebase/merge_peaks/data/RBFOX2-204-INPUT_S2_R1.unassigned.adapterTrim.round2.rmRep.rmDup.sorted.r2.bam \
/home/bay001/projects/codebase/merge_peaks/data/rbfox2.txt.mapped_read_num \
/home/bay001/projects/codebase/merge_peaks/data/current_get_reproducing_peaks_outputprefix
