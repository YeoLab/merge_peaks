#!/usr/bin/env cwltool

cwlVersion: v1.0
class: Workflow

inputs:

  clipBamFile:
    type: File
  inputBamFile:
    type: File
  clipBedFile:
    type: File

  clipReadNum:
    type: string
  inputReadNum:
    type: string
  inputNormed:
    type: string
  compressed:
    type: string
  compressedFull:
    type: string
  entropyOutput:
    type: string
  entropyExcessReadsOutput:
    type: string

outputs:
  clipReadNumFile:
    type: File
    outputSource: calculate_clip_readnum/outputReadNumFile
  inputReadNumFile:
    type: File
    outputSource: calculate_input_readnum/outputReadNumFile
  inputNormOutputFile:
    type: File
    outputSource: input_norm/outputFile
  inputNormOutputFullFile:
    type: File
    outputSource: input_norm/outputFullFile
  compressPeaksOutputFile:
    type: File
    outputSource: compress_peaks_full/compressedOutputFile
  compressPeaksOutputFileFull:
    type: File
    outputSource: compress_peaks_full/compressedOutputFileFull
  entropyOutputFile:
    type: File
    outputSource: calculate_entropy/entropyOutFile
  entropyExcessReadsOutputFile:
    type: File
    outputSource: calculate_entropy/excessReadsOutFile
  entropyOutputBedFile:
    type: File
    outputSource: create_bed_from_entropy/outputBedFile

steps:
  calculate_clip_readnum:
    run: calculate_readnum.cwl
    in:
      bamFile: clipBamFile
      output: clipReadNum
    out:
      - outputReadNumFile
  calculate_input_readnum:
    run: calculate_readnum.cwl
    in:
      bamFile: inputBamFile
      output: inputReadNum
    out:
      - outputReadNumFile
  input_norm:
    run: overlap_peakfi_with_bam_PE.cwl
    in:
      experimentBamFile: clipBamFile
      inputBamFile: inputBamFile
      peakFile: clipBedFile
      exptReadNumFile: calculate_clip_readnum/outputReadNumFile
      inputReadNumFile: calculate_input_readnum/outputReadNumFile
      output: inputNormed
    out:
      - outputFile
      - outputFullFile
  compress_peaks_full:
    run: compress_l2foldenrpeakfi_for_replicate_overlapping_bedformat_outputfull.cwl
    in:
      inputFile: input_norm/outputFullFile
      compressedFile: compressed
      compressedFileFull: compressedFull
    out:
      - compressedOutputFile
      - compressedOutputFileFull

  calculate_entropy:
    run: make_informationcontent_from_peaks.cwl
    in:
      inputFile: compress_peaks_full/compressedOutputFileFull
      clipReadNum: calculate_clip_readnum/outputReadNumFile
      inputReadNum: calculate_input_readnum/outputReadNumFile
      entropyOutFileName: entropyOutput
      excessReadsOutFileName: entropyExcessReadsOutput
    out:
      - entropyOutFile
      - excessReadsOutFile

  create_bed_from_entropy:
    run: full_to_bed.cwl
    in:
      inputFile: calculate_entropy/entropyOutFile
    out:
      - outputBedFile