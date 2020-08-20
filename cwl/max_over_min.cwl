#!/usr/bin/env cwltool

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

baseCommand: [ max_over_min.sh ]

inputs:

  count1:
    type: int
    inputBinding:
      position: 1

  count2:
    type: int
    inputBinding:
      position: 2

  output_file:
    type: string
    inputBinding:
      position: 3

outputs:

  ratio:
    type: File
    outputBinding:
      glob: $(inputs.output_file)

# expression: "${ return {'ratio': Math.max(inputs.count1, inputs.count2) / Math.min(inputs.count1, inputs.count2) }; }"

