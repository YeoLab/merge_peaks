#!/usr/bin/env bash

export PATH="/home/bay001/projects/codebase/merge_peaks/bin:$PATH"

perl ~/projects/codebase/merge_peaks/bin/run_and_parse_IDR.pl \
/home/bay001/projects/codebase/merge_peaks/data/204_01.basedon_204_01.peaks.l2inputnormnew.bed.full.compressed2.bed.full.annotated_proxdist.entropy \
/home/bay001/projects/codebase/merge_peaks/data/204_02.basedon_204_02.peaks.l2inputnormnew.bed.full.compressed2.bed.full.annotated_proxdist.entropy \
/home/bay001/projects/codebase/merge_peaks/data/pipeline_outputs/run_and_parse_idr_output.out
