#!/usr/bin/env cwltool

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: brianyee/merge_peaks:0.0.6
    
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
