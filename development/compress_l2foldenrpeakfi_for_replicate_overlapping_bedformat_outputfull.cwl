#!/usr/bin/env cwltool

cwlVersion: v1.0

class: CommandLineTool

baseCommand: [compress_l2foldenrpeakfi_for_replicate_overlapping_bedformat_outputfull.pl]

inputs:
  inputFile:
    type: File
    inputBinding:
      position: 1
  compressedFile:
    type: string
    inputBinding:
      position: 2
    label: "Compressed peak file"
    doc: "Compressed peak file"
  compressedFileFull:
    type: string
    inputBinding:
      position: 3
    label: "Compressed peak file"
    doc: "Compressed peak file"
outputs:
  compressedOutputFile:
    type: File
    outputBinding:
      glob: $(inputs.compressedFile)
  compressedOutputFileFull:
    type: File
    outputBinding:
      glob: $(inputs.compressedFileFull)
