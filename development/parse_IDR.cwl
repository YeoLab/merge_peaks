#!/usr/bin/env cwltool

cwlVersion: v1.0

class: CommandLineTool

baseCommand: [parse_IDR.pl]

inputs:

  inputFile:
    type: File
    inputBinding:
      position: 1
    label: "input file"
    doc: "input file"
  outputFile:
    type: File
    inputBinding:
      position: 2
  parsedFile:
    type: string
    inputBinding:
      position: 3
outputs:
  output:
    type: File
    outputBinding:
      glob: $(inputs.parsedFile)