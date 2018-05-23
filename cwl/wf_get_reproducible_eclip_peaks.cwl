#!/usr/bin/env cwltool

doc: |
  The main workflow that produces two reproducible peaks via IDR given
  two eCLIP samples (1 input, 1 IP each).

cwlVersion: v1.0
class: Workflow


requirements:
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement


inputs:

  rep1_clip_bam_file:
    type: File
  rep1_input_bam_file:
    type: File
  rep1_peaks_bed_file:
    type: File

  rep2_clip_bam_file:
    type: File
  rep2_input_bam_file:
    type: File
  rep2_peaks_bed_file:
    type: File

  # FINAL OUTPUTS
  merged_peaks_bed:
    type: string
  merged_peaks_custombed:
    type: string

  #
  # outputPrefixRep1:
  #   type: string
  #   default: "01"
  # outputPrefixRep2:
  #   type: string
  #   default: "02"

  #
  # inputNormSuffixRep1:
  #   type: string
  #   default: "idrpeaks_inputnormed_01"
  # inputNormSuffixRep2:
  #   type: string
  #   default: "idrpeaks_inputnormed_02"

  #
  # idrOutputFilename:
  #   type: string
  #   default: "01v02.idr.out"
  # idrOutputBedFilename:
  #   type: string
  #   default: "01v02.idr.out.bed"

  # POST IDR PROCESSING
  # idrInputNormRep1BedFilename:
  #   type: string
  #   default: "01v02.IDR.out.idrpeaks_inputnormed.01.bed"
  # idrInputNormRep2BedFilename:
  #   type: string
  #   default: "01v02.IDR.out.idrpeaks_inputnormed.02.bed"

  # MERGE PEAKS
  # rep1ReproducingPeaksFullOutputFilename:
  #   type: string
  #   default: "01v02.IDR.out.0102merged.01.full"
  # rep2ReproducingPeaksFullOutputFilename:
  #   type: string
  #   default: "01v02.IDR.out.0102merged.02.full"




outputs:


  rep1_clip_read_num:
    type: File
    outputSource: rep1_input_norm_and_entropy/clip_read_num
  rep1_input_read_num:
    type: File
    outputSource: rep1_input_norm_and_entropy/input_read_num


  rep1_input_normed_bed:
    type: File
    outputSource: rep1_input_norm_and_entropy/input_normed_bed
  rep1_input_normed_full:
    type: File
    outputSource: rep1_input_norm_and_entropy/input_normed_full


  rep1_entropy_full:
    type: File
    outputSource: rep1_input_norm_and_entropy/entropy_full
  rep1_entropy_excess_reads:
    type: File
    outputSource: rep1_input_norm_and_entropy/entropy_excess_reads
  rep1_entropy_bed:
    type: File
    outputSource: rep1_input_norm_and_entropy/entropy_bed


  rep2_clip_read_num:
    type: File
    outputSource: rep2_input_norm_and_entropy/clip_read_num
  rep2_input_read_num:
    type: File
    outputSource: rep2_input_norm_and_entropy/input_read_num


  rep2_input_normed_bed:
    type: File
    outputSource: rep2_input_norm_and_entropy/input_normed_bed
  rep2_input_normed_full:
    type: File
    outputSource: rep2_input_norm_and_entropy/input_normed_full


  rep2_entropy_full:
    type: File
    outputSource: rep2_input_norm_and_entropy/entropy_full
  rep2_entropy_excess_reads:
    type: File
    outputSource: rep2_input_norm_and_entropy/entropy_excess_reads
  rep2_entropy_bed:
    type: File
    outputSource: rep2_input_norm_and_entropy/entropy_bed


  idr_output:
    type: File
    outputSource: idr/output

  idr_output_bed:
    type: File
    outputSource: create_bed_from_idr/output


  rep1_idr_output_input_normed_bed:
    type: File
    outputSource: rep1_input_norm_using_idr_peaks/inputNormedBed
  rep2_idr_output_input_normed_bed:
    type: File
    outputSource: rep2_input_norm_using_idr_peaks/inputNormedBed


  rep1_idr_output_input_normed_full:
    type: File
    outputSource: rep1_input_norm_using_idr_peaks/inputNormedBedFull
  rep2_idr_output_input_normed_full:
    type: File
    outputSource: rep2_input_norm_using_idr_peaks/inputNormedBedFull


  rep1_reproducing_peaks_full:
    type: File
    outputSource: get_reproducing_peaks/rep1_full_output_file
  rep2_reproducing_peaks_full:
    type: File
    outputSource: get_reproducing_peaks/rep2_full_output_file


  merged_peaks_bed_file:
    type: File
    outputSource: get_reproducing_peaks/output_bed_file
  merged_peaks_custombed_file:
    type: File
    outputSource: get_reproducing_peaks/output_custombed_file
  reproducing_peaks_count:
     type: int
     outputSource: reproducible_peaks_file_to_int/output


steps:



  rep1_input_norm_and_entropy:
    run: wf_input_norm_and_entropy.cwl
    in:
      clip_bam_file: rep1_clip_bam_file
      input_bam_file: rep1_input_bam_file
      peak_file: rep1_peaks_bed_file
      # outputPrefix: outputPrefixRep1
      # inputNormSuffix: inputNormSuffixRep1

    out:
      - clip_read_num
      - input_read_num

      - input_normed_bed
      - input_normed_full

      - compressed_bed
      - compressed_full

      - entropy_full
      - entropy_excess_reads
      - entropy_bed

  rep2_input_norm_and_entropy:
    run: wf_input_norm_and_entropy.cwl
    in:
      clip_bam_file: rep2_clip_bam_file
      input_bam_file: rep2_input_bam_file
      peak_file: rep2_peaks_bed_file
      # outputPrefix: outputPrefixRep2
      # inputNormSuffix: inputNormSuffixRep2

    out:
      - clip_read_num
      - input_read_num

      - input_normed_bed
      - input_normed_full

      - compressed_bed
      - compressed_full

      - entropy_full
      - entropy_excess_reads
      - entropy_bed

  idr:
    run: idr.cwl
    in:
      samples: [
        rep1_input_norm_and_entropy/entropy_bed,
        rep2_input_norm_and_entropy/entropy_bed
      ]
      inputFileType:
        default: "bed"
      rank:
        default: 5
      peakMergeMethod:
        default: "max"
      plot:
        default: true

      outputFilename:
        default: "01v02.idr.out"

    out:
      - output

  create_bed_from_idr:
    run: parse_idr_peaks.cwl
    in:
      idrFile: idr/output
      entropyFile1: rep1_input_norm_and_entropy/entropy_full
      entropyFile2: rep2_input_norm_and_entropy/entropy_full

      outputFilename:
        default: "01v02.idr.out.bed"
    out:
      - output

  rep1_input_norm_using_idr_peaks:
    run: overlap_peakfi_with_bam.cwl
    in:
      clipBamFile: rep1_clip_bam_file
      inputBamFile: rep1_input_bam_file

      peakFile: create_bed_from_idr/output

      clipReadnum: rep1_input_norm_and_entropy/clip_read_num
      inputReadnum: rep1_input_norm_and_entropy/input_read_num

      # outputPrefix: idrInputNormRep1BedFilename
      # inputNormSuffix: inputNormSuffixRep1

    out:
      - inputNormedBed
      - inputNormedBedFull

  rep2_input_norm_using_idr_peaks:
    run: overlap_peakfi_with_bam.cwl
    in:
      clipBamFile: rep2_clip_bam_file
      inputBamFile: rep2_input_bam_file

      peakFile: create_bed_from_idr/output

      clipReadnum: rep2_input_norm_and_entropy/clip_read_num
      inputReadnum: rep2_input_norm_and_entropy/input_read_num

      # outputPrefix: idrInputNormRep2BedFilename
      # inputNormSuffix: inputNormSuffixRep2


    out:
      - inputNormedBed
      - inputNormedBedFull


  get_reproducing_peaks:
    run: get_reproducing_peaks.cwl
    in:
      rep1_full_in: rep1_input_norm_using_idr_peaks/inputNormedBedFull
      rep2_full_in: rep2_input_norm_using_idr_peaks/inputNormedBedFull

      rep1_full_output:
        default: "01v02.IDR.out.0102merged.01.full"
      rep2_full_output:
        default: "01v02.IDR.out.0102merged.02.full"

      rep1_entropy_file: rep1_input_norm_and_entropy/entropy_full
      rep2_entropy_file: rep2_input_norm_and_entropy/entropy_full

      idr_file: idr/output


      output_bed: merged_peaks_bed
      output_custombed: merged_peaks_custombed

    out:
      - rep1_full_output_file
      - rep2_full_output_file
      - output_bed_file
      - output_custombed_file


  count_reproducing_peaks:
      run: linescount.cwl
      in:
        textfile: get_reproducing_peaks/output_bed_file
      out:
        - linescount

  reproducible_peaks_file_to_int:
    run: file2int.cwl
    in:
      file: count_reproducing_peaks/linescount
    out:
      - output