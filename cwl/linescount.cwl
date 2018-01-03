#!/usr/bin/env cwltool

cwlVersion: v1.0

class: CommandLineTool


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


