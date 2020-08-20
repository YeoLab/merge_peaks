#!/usr/bin/env cwltool

doc: |
  Converts a full file into a bed6 formatted file.

cwlVersion: v1.0

class: CommandLineTool

baseCommand: [full_to_bed.py]

inputs:

  full:
    type: File
    inputBinding:
      position: 1
      prefix: --input

arguments: [ "--output", $(inputs.full.nameroot).bed ]

outputs:

  bed:
    type: File
    outputBinding:
      glob: $(inputs.full.nameroot).bed