#!/usr/bin/env cwltool

cwlVersion: v1.0

class: CommandLineTool

baseCommand: [idr]

inputs:

  samples:
    type: File[]
    inputBinding:
      position: 1
      prefix: --samples
    label: "input"
    doc: "input BED file"
  inputFileType:
    type: string
    inputBinding:
      position: 2
      prefix: --input-file-type
    default: bed
  rank:
    type: int
    inputBinding:
      position: 3
      prefix: --rank
    default: 5
  peakMergeMethod:
    type: string
    inputBinding:
      position: 4
      prefix: --peak-merge-method
    default: max
  plot:
    type: boolean
    inputBinding:
      position: 5
      prefix: --plot
    default: true
  output:
    type: string
    inputBinding:
      position: 6
      prefix: -o

outputs:
  outputFile:
    type: File
    outputBinding:
      glob: $(inputs.output)
