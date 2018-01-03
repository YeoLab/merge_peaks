#!/usr/bin/env cwltool


cwlVersion: v1.0
class: Workflow


requirements:
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement


inputs:

  bam_rep1:
    type: File
  bam_rep2:
    type: File
  bam_input:
    type: File


outputs:

  reproducing_peaks_count:
    type: File



steps:


  clipper_rep1:
    run: clipper.cwl
    in:
      bam: bam_rep1
    out:
      - output_bed


  clipper_rep2:
    run: clipper.cwl
    in:
      bam: bam_rep2
    out:
      - output_bed


  merge_peaks:

    run: wf_eclipidrmergepeaks.cwl
    in:
      rep1ClipBam: bam_rep1
      rep1InputBam: bam_input
      rep1PeaksBed: clipper_rep1/output_bed

      rep2ClipBam: bam_rep2
      rep2InputBam: bam_input
      rep2PeaksBed: clipper_rep1/output_bed
    out:
      - reproducing_peaks_count


