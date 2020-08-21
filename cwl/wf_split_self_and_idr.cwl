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
  
  ## DEBUG ##
  
  rep1_clip_read_num:
    type: File
    outputSource: step_reproducible_peaks_num/rep1_clip_read_num
  rep2_clip_read_num:
    type: File
    outputSource: step_reproducible_peaks_num/rep2_clip_read_num
  rep1_input_read_num:
    type: File
    outputSource: step_reproducible_peaks_num/rep1_input_read_num
  rep2_input_read_num:
    type: File
    outputSource: step_reproducible_peaks_num/rep2_input_read_num
  merged_peaks_bed_file:
    type: File
    outputSource: step_reproducible_peaks_num/merged_peaks_bed_file
  
steps:


  step_bam_split:
    run: bam_split.cwl
    in:
      bam: clip_bam
    out:
      - split1
      - split2

  index_split1:
    run: samtools-index.cwl
    in:
      alignments: step_bam_split/split1
    out: [alignments_with_index]
  
  index_split2:
    run: samtools-index.cwl
    in:
      alignments: step_bam_split/split2
    out: [alignments_with_index]
    
  step_clipper_split1:
    run: clipper.cwl
    in:
      bam: index_split1/alignments_with_index
      species: species
    out:
      - output_tsv
      - output_bed
      - output_pickle
    
  step_clipper_split2:
    run: clipper.cwl
    in:
      bam: index_split2/alignments_with_index
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
      - rep1_clip_read_num # DEBUG
      - rep1_input_read_num # DEBUG
      - rep2_clip_read_num # DEBUG
      - rep2_input_read_num # DEBUG
      - merged_peaks_bed_file # DEBUG  