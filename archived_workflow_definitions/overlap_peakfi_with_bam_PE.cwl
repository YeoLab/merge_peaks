#!/usr/bin/env cwltool

cwlVersion: v1.0

class: CommandLineTool

baseCommand: [overlap_peakfi_with_bam_PE.pl]


arguments: [
  $(inputs.outputPrefix).$(inputs.inputNormSuffix).bed
  ]


inputs:

  # IP BAM file
  clipBamFile:
    type: File
    inputBinding:
      position: -5

  inputBamFile:
    type: File
    inputBinding:
      position: -4

  peakFile:
    type: File
    inputBinding:
      position: -3

  # mapped_read_num
  clipReadnum:
    type: File
    inputBinding:
      position: -2

  #mapped_read_num"
  inputReadnum:
    type: File
    inputBinding:
      position: -1


  outputPrefix:
    type: string

  inputNormSuffix:
    type: string
    default: "inputnormed"


outputs:

  inputNormedBed:
    type: File
    outputBinding:
      #glob: $(inputs.output)
      glob: $(inputs.outputPrefix).$(inputs.inputNormSuffix).bed

  inputNormedBedFull:
    type: File
    outputBinding:
      #glob: "$(inputs.output).full"
      glob: $(inputs.outputPrefix).$(inputs.inputNormSuffix).bed.full
