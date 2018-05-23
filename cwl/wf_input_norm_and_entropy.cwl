#!/usr/bin/env cwltool

doc: |
  This workflow normalizes clip aligned reads against a size-matched input
  sample. Then, an entropy score is calculated for each peak found.

cwlVersion: v1.0
class: Workflow


inputs:

  clip_bam_file:
    type: File

  input_bam_file:
    type: File

  peak_file:
    type: File


outputs:


  clip_read_num:
    type: File
    outputSource: calculate_clip_readnum/readnum
  input_read_num:
    type: File
    outputSource: calculate_input_readnum/readnum


  input_normed_bed:
    type: File
    outputSource: input_norm/inputNormedBed
  input_normed_full:
    type: File
    outputSource: input_norm/inputNormedBedFull


  compressed_bed:
    type: File
    outputSource: compress_peaks/output_bed
  compressed_full:
    type: File
    outputSource: compress_peaks/output_full


  entropy_full:
    type: File
    outputSource: make_informationcontent_from_peaks/entropy_full
  entropy_excess_reads:
    type: File
    outputSource: make_informationcontent_from_peaks/entropy_excess_reads


  entropy_bed:
    type: File
    outputSource: create_entropybed_from_entropyfull/bed


steps:

  calculate_clip_readnum:
    run: calculate_readnum.cwl
    in:
      bamFile: clip_bam_file
    out:
      - readnum

  calculate_input_readnum:
    run: calculate_readnum.cwl
    in:
      bamFile: input_bam_file
    out:
      - readnum


  input_norm:
    run: overlap_peakfi_with_bam.cwl
    in:
      clipBamFile: clip_bam_file
      inputBamFile: input_bam_file
      peakFile: peak_file
      clipReadnum: calculate_clip_readnum/readnum
      inputReadnum: calculate_input_readnum/readnum

    out:
      - inputNormedBed
      - inputNormedBedFull

  compress_peaks:
    run: compress_l2foldenrpeakfi_for_replicate_overlapping_bedformat_outputfull.cwl
    in:
      input_full: input_norm/inputNormedBedFull

    out:
      - output_bed
      - output_full

  make_informationcontent_from_peaks:
    run: make_informationcontent_from_peaks.cwl
    in:
      compressed_bed_full: compress_peaks/output_full
      clip_read_num: calculate_clip_readnum/readnum
      input_read_num: calculate_input_readnum/readnum

    out:

      # ATTENTION! THIS IS WHATIS USED BY THE MAIN WORKFLOW !
      - entropy_full

      # NOT SURE IF THIS IS BEING USED FOR ANYTHING
      - entropy_excess_reads


  # ATTENTION! THIS IS NOT USED BY THE MAIN WORKFLOW !!!
  create_entropybed_from_entropyfull:
    run: full_to_bed.cwl
    in:
      full: make_informationcontent_from_peaks/entropy_full
    out:
      - bed

