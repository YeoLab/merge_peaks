#!/usr/bin/env cwltool

doc: |
  This workflow returns the reproducible number of split peaks given a single
  bam file and its size-matched input pair. This workflow splits the bam file
  first, but does not do anything to the input.

cwlVersion: v1.0
class: Workflow


requirements:
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement


inputs:

  clip_bam:
    type: File
  input_bam:
    type: File
  species:
    type: string

  merged_peaks_bed:
    type: string
  merged_peaks_custombed:
    type: string

outputs:

  reproducing_peaks_count:
    type: int
    outputSource: step_reproducible_peaks_num/reproducing_peaks_count

steps:


  step_bam_split:
    run: bam_split.cwl
    in:
      bam: clip_bam
    out:
      - split1
      - split2

  step_clipper_split1:
    run: clipper.cwl
    in:
      bam: step_bam_split/split1
      species: species
    out:
      - output_tsv
      - output_bed
      - output_pickle

  step_clipper_split2:
    run: clipper.cwl
    in:
      bam: step_bam_split/split2
      species: species
    out:
      - output_tsv
      - output_bed
      - output_pickle

  step_reproducible_peaks_num:
    run: wf_get_reproducible_eclip_peaks.cwl
    in:
      rep1_clip_bam_file: step_bam_split/split1
      rep2_clip_bam_file: step_bam_split/split2
      rep1_input_bam_file: input_bam
      rep2_input_bam_file: input_bam
      rep1_peaks_bed_file: step_clipper_split1/output_bed
      rep2_peaks_bed_file: step_clipper_split2/output_bed

      merged_peaks_bed: merged_peaks_bed
      merged_peaks_custombed: merged_peaks_custombed
    out:
      - reproducing_peaks_count



doc: |
  Randomly splits a bam file and calls CLIPPER on each split.
  Then, this workflow uses the split bam files and their corresponding
  CLIPPER peaks and returns the number of reproducible peaks between the
  two splits. Input bam files are not being split here.