#!/usr/bin/env cwltool

cwlVersion: v1.0

class: CommandLineTool

baseCommand: [parse_idr_peaks.pl]

inputs:

  idrFile:
    type: File
    inputBinding:
      position: 1
    label: "IDR File"
    doc: "IDR File"
  entropyFile1:
    type: File
    inputBinding:
      position: 2
    label: "entropy file 1"
    doc: "entropy file 1"
  entropyFile2:
    type: File
    inputBinding:
      position: 3
    label: "entropy file 2"
    doc: "entropy file 2"
  output:
    type: string
    inputBinding:
      position: 4
    label: "output file"
    doc: "output file"

outputs:
  outputFile:
    type: File
    outputBinding:
      glob: $(inputs.output)
