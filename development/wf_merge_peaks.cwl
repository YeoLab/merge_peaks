#!/usr/bin/env cwltool

cwlVersion: v1.0
class: Workflow

requirements:
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement

inputs:

  rep1ClipBam:
    type: File
  rep1InputBam:
    type: File
  rep1PeaksBed:
    type: File

  # REP 1 INTERMEDIATES
  rep1clipReadNum:
    type: string
  rep1inputReadNum:
    type: string
  rep1inputNormed:
    type: string
  rep1compressed:
    type: string
  rep1compressedFull:
    type: string
  rep1entropyOutput:
    type: string
  rep1entropyExcessReadsOutput:
    type: string

  rep2ClipBam:
    type: File
  rep2InputBam:
    type: File
  rep2PeaksBed:
    type: File

  # REP 2 INTERMEDIATES
  rep2clipReadNum:
    type: string
  rep2inputReadNum:
    type: string
  rep2inputNormed:
    type: string
  rep2compressed:
    type: string
  rep2compressedFull:
    type: string
  rep2entropyOutput:
    type: string
  rep2entropyExcessReadsOutput:
    type: string

  # IDR OPTIONS
  idrInputFileType:
    type: string
  idrRank:
    type: int
  idrPeakMergeMethod:
    type: string
  idrPlot:
    type: boolean
  idrOutput:
    type: string

  # POST IDR PROCESSING
  idrOutputBed:
    type: string
  idrInputNormRep1Bed:
    type: string
  idrInputNormRep2Bed:
    type: string

  # MERGE PEAKS
  rep1ReproducingPeaksFullOutput:
    type: string
  rep2ReproducingPeaksFullOutput:
    type: string
  mergedPeakBed:
    type: string
  mergedPeakCustomBed:
    type: string

outputs:
  rep1ClipReadNumFile:
    type: File
    outputSource: rep1_input_norm_and_entropy/clipReadNumFile
  rep1InputReadNumFile:
    type: File
    outputSource: rep1_input_norm_and_entropy/inputReadNumFile
  rep1InputNormOutputFullFile:
    type: File
    outputSource: rep1_input_norm_and_entropy/inputNormOutputFullFile
  rep1CompressPeaksOutputFileFull:
    type: File
    outputSource: rep1_input_norm_and_entropy/compressPeaksOutputFileFull
  rep1EntropyOutputFile:
    type: File
    outputSource: rep1_input_norm_and_entropy/entropyOutputFile
  rep1EntropyExcessReadsOutputFile:
    type: File
    outputSource: rep1_input_norm_and_entropy/entropyExcessReadsOutputFile
  rep1EntropyOutputBedFile:
    type: File
    outputSource: rep1_input_norm_and_entropy/entropyOutputBedFile

  rep2ClipReadNumFile:
    type: File
    outputSource: rep2_input_norm_and_entropy/clipReadNumFile
  rep2InputReadNumFile:
    type: File
    outputSource: rep2_input_norm_and_entropy/inputReadNumFile
  rep2InputNormOutputFullFile:
    type: File
    outputSource: rep2_input_norm_and_entropy/inputNormOutputFullFile
  rep2CompressPeaksOutputFileFull:
    type: File
    outputSource: rep2_input_norm_and_entropy/compressPeaksOutputFileFull
  rep2EntropyOutputFile:
    type: File
    outputSource: rep2_input_norm_and_entropy/entropyOutputFile
  rep2EntropyExcessReadsOutputFile:
    type: File
    outputSource: rep2_input_norm_and_entropy/entropyExcessReadsOutputFile
  rep2EntropyOutputBedFile:
    type: File
    outputSource: rep2_input_norm_and_entropy/entropyOutputBedFile

  idrOutputFile:
    type: File
    outputSource: run_idr/outputFile

  idrOutputBedFile:
    type: File
    outputSource: create_bed_from_idr/outputFile

  idrOutputInputNormRep1File:
    type: File
    outputSource: rep1_input_norm_using_idr_peaks/outputFile

  idrOutputInputNormRep2File:
    type: File
    outputSource: rep2_input_norm_using_idr_peaks/outputFile

  idrOutputInputNormRep1FullFile:
    type: File
    outputSource: rep1_input_norm_using_idr_peaks/outputFullFile

  idrOutputInputNormRep2FullFile:
    type: File
    outputSource: rep2_input_norm_using_idr_peaks/outputFullFile

  rep1ReproducingPeaksFullOutputFile:
    type: File
    outputSource: get_reproducing_peaks/rep1FullOutFile

  rep2ReproducingPeaksFullOutputFile:
    type: File
    outputSource: get_reproducing_peaks/rep2FullOutFile

  mergedPeakBedFile:
    type: File
    outputSource: get_reproducing_peaks/bedOutFile

  mergedPeakCustomBedFile:
    type: File
    outputSource: get_reproducing_peaks/customBedOutputFile

steps:
  rep1_input_norm_and_entropy:
    run: wf_compressed_entropy.cwl
    in:
      clipBamFile: rep1ClipBam
      inputBamFile: rep1InputBam
      clipBedFile: rep1PeaksBed

      clipReadNum: rep1clipReadNum
      inputReadNum: rep1inputReadNum
      inputNormed: rep1inputNormed
      compressed: rep1compressed
      compressedFull: rep1compressedFull
      entropyOutput: rep1entropyOutput
      entropyExcessReadsOutput: rep1entropyExcessReadsOutput
    out:
      - clipReadNumFile
      - inputReadNumFile
      - inputNormOutputFile
      - inputNormOutputFullFile
      - compressPeaksOutputFile
      - compressPeaksOutputFileFull
      - entropyOutputFile
      - entropyExcessReadsOutputFile
      - entropyOutputBedFile

  rep2_input_norm_and_entropy:
    run: wf_compressed_entropy.cwl
    in:
      clipBamFile: rep2ClipBam
      inputBamFile: rep2InputBam
      clipBedFile: rep2PeaksBed

      clipReadNum: rep2clipReadNum
      inputReadNum: rep2inputReadNum
      inputNormed: rep2inputNormed
      compressed: rep2compressed
      compressedFull: rep2compressedFull
      entropyOutput: rep2entropyOutput
      entropyExcessReadsOutput: rep2entropyExcessReadsOutput
    out:
      - clipReadNumFile
      - inputReadNumFile
      - inputNormOutputFile
      - inputNormOutputFullFile
      - compressPeaksOutputFile
      - compressPeaksOutputFileFull
      - entropyOutputFile
      - entropyExcessReadsOutputFile
      - entropyOutputBedFile

  run_idr:
    run: idr.cwl
    in:
      samples: [rep1_input_norm_and_entropy/entropyOutputBedFile, rep2_input_norm_and_entropy/entropyOutputBedFile]
      inputFileType: idrInputFileType
      rank: idrRank
      peakMergeMethod: idrPeakMergeMethod
      plot: idrPlot
      output: idrOutput
    out:
      - outputFile

  create_bed_from_idr:
    run: parse_idr_peaks.cwl
    in:
      idrFile: run_idr/outputFile
      entropyFile1: rep1_input_norm_and_entropy/entropyOutputFile
      entropyFile2: rep2_input_norm_and_entropy/entropyOutputFile
      output: idrOutputBed
    out:
      - outputFile

  rep1_input_norm_using_idr_peaks:
    run: overlap_peakfi_with_bam_PE.cwl
    in:
      experimentBamFile: rep1ClipBam
      inputBamFile: rep1InputBam
      peakFile: create_bed_from_idr/outputFile
      exptReadNumFile: rep1_input_norm_and_entropy/clipReadNumFile
      inputReadNumFile: rep1_input_norm_and_entropy/inputReadNumFile
      output: idrInputNormRep1Bed
    out:
      - outputFile
      - outputFullFile
  rep2_input_norm_using_idr_peaks:
    run: overlap_peakfi_with_bam_PE.cwl
    in:
      experimentBamFile: rep2ClipBam
      inputBamFile: rep2InputBam
      peakFile: create_bed_from_idr/outputFile
      exptReadNumFile: rep2_input_norm_and_entropy/clipReadNumFile
      inputReadNumFile: rep2_input_norm_and_entropy/inputReadNumFile
      output: idrInputNormRep2Bed
    out:
      - outputFile
      - outputFullFile

  get_reproducing_peaks:
    run: get_reproducing_peaks.cwl
    in:
      rep1FullInFile: rep1_input_norm_using_idr_peaks/outputFullFile
      rep2FullInFile: rep2_input_norm_using_idr_peaks/outputFullFile
      rep1FullOut: rep1ReproducingPeaksFullOutput
      rep2FullOut: rep2ReproducingPeaksFullOutput
      bedOut: mergedPeakBed
      customBedOutput: mergedPeakCustomBed
      rep1EntropyFile: rep1_input_norm_and_entropy/entropyOutputFile
      rep2EntropyFile: rep2_input_norm_and_entropy/entropyOutputFile
      idrFile: run_idr/outputFile
    out:
      - rep1FullOutFile
      - rep2FullOutFile
      - bedOutFile
      - customBedOutputFile