#!/usr/bin/env cwltool

cwlVersion: v1.0

class: CommandLineTool

baseCommand: [full_to_bed.py]

inputs:

  inputFile:
    type: File
    inputBinding:
      position: 1
      prefix: --input
    label: "input file"
    doc: "input file"

arguments: [
  "--output", $(inputs.inputFile.basename).bed
]

outputs:
  outputBedFile:
    type: File
    outputBinding:
      glob: $(inputs.inputFile.basename).bed