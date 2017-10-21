#!/usr/bin/env cwltool

cwlVersion: v1.0

class: CommandLineTool

baseCommand: [samtools, view]

inputs:

  countFlag:
    type: boolean
    inputBinding:
      position: 1
      prefix: -c
    default: true
    label: "Print only the count"
    doc: "Print only the count"

  readFlag:
    type: int
    inputBinding:
      position: 2
      prefix: -F
    default: 4
    label: "Flag to count only the mapped reads"

  bamFile:
    type: File
    inputBinding:
      position: 3
    label: "BAM file"
    doc: "BAM file"

  mappedReadNumFile:
    type: string
    inputBinding:
      position: 4
    label: "mapped readnum file"
    doc: "mapped readnum file"

outputs:
  outputReadNumFile:
    type: File
    outputBinding:
      glob: $(inputs.mappedReadNumFile)