#!/usr/bin/env cwltool

cwlVersion: v1.0

class: CommandLineTool

baseCommand: [samtools, view]

inputs:

  printMatchingReadCount:
    type: boolean
    inputBinding:
      position: 1
      prefix: -c
    label: "print only the count of matching records"
    doc: "print only the count of matching records"
    default: true
  excludeFlags:
    type: int
    inputBinding:
      position: 2
      prefix: -F
    default: 4
  bamFile:
    type: File
    inputBinding:
      position: 3
    label: "BAM file"
    doc: "BAM file"
  outputFile:
    type: string
    inputBinding:
      position: 4
      prefix: -o

outputs:
  output:
    type: File
    outputBinding:
      glob: $(inputs.outputFile)
