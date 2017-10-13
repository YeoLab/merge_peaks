#!/usr/bin/env cwltool

cwlVersion: v1.0

class: CommandLineTool

baseCommand: [input_norm.py]

inputs:

  peaks:
    type: File
    inputBinding:
      position: 1
      prefix: --peaks
  ipBam:
    type: File
    inputBinding:
      position: 2
      prefix: --ip_bam
    secondaryFiles:
      - .bai
  inputBam:
    type: File
    inputBinding:
      position: 3
      prefix: --input_bam
    secondaryFiles:
      - .bai
  out:
    type: string
    inputBinding:
      position: 4
      prefix: --out
  outFull:
    type: string
    inputBinding:
      position: 5
      prefix: --out_full
outputs:
  output:
    type: File[]
    outputBinding:
      glob: $(inputs.out.nameroot)*
  outputFull:
    type: File[]
    outputBinding:
      glob: $(inputs.outFull.nameroot)*