#!/usr/bin/env cwltool

cwlVersion: v1.0
class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: 1
    coresMax: 16
    ramMin: 16000

hints:
  - class: DockerRequirement
    dockerPull: brianyee/merge_peaks:0.0.6

baseCommand: [overlap_peakfi_with_bam.pl]

inputs:

  clipBamFile:
    type: File
    inputBinding:
      position: -5
    doc: "IP BAM file"
    
  inputBamFile:
    type: File
    inputBinding:
      position: -4

  peakFile:
    type: File
    inputBinding:
      position: -3

  clipReadnum:
    type: File
    inputBinding:
      position: -2

  inputReadnum:
    type: File
    inputBinding:
      position: -1

  outputFile:
    type: string
    default: ""
    inputBinding:
      position: 0
      valueFrom: |
        ${
          if (inputs.outputFile == "") {
            return inputs.peakFile.nameroot + ".normed.bed";
          }
          else {
            return inputs.outputFile;
          }
        }

outputs:

  inputNormedBed:
    type: File
    outputBinding:
      glob: |
        ${
          if (inputs.outputFile == "") {
            return inputs.peakFile.nameroot + ".normed.bed";
          }
          else {
            return inputs.outputFile;
          }
        }

  inputNormedBedFull:
    type: File
    outputBinding:
      glob: |
        ${
          if (inputs.outputFile == "") {
            return inputs.peakFile.nameroot + ".normed.bed.full";
          }
          else {
            return inputs.outputFile;
          }
        }

doc: |
  This tool wraps overlap_peakfi_with_bam.pl
    Usage: overlap_peakfi_with_bam.pl exptbamfile inputbamfile peakfile expt_readnum_file input_readnum_file 