#!/usr/bin/env cwltool

cwlVersion: v1.0

class: CommandLineTool

hints:
  - class: DockerRequirement
    dockerPull: brianyee/merge_peaks:0.1.0

baseCommand: [ linescount.sh ]


inputs:

  textfile:
    type: File
    inputBinding:
      position: 1

stdout: $(inputs.textfile.basename).linescount

outputs:


  linescount:
    type: File
    outputBinding:
      glob: $(inputs.textfile.basename).linescount


