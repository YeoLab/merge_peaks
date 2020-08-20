#!/usr/bin/env cwltool

cwlVersion: v1.0

class: CommandLineTool

hints:
  - class: DockerRequirement
    dockerPull: brianyee/samtools:1.6
    
baseCommand: [samtools, view]

inputs:

  countFlag:
    type: boolean
    inputBinding:
      position: 1
      prefix: -c
    default: true
    label: "Print only the count"


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

stdout: $(inputs.bamFile.nameroot).readnum

outputs:

  readnum:
    type: File
    outputBinding:
      #glob: $(inputs.output)
      glob: $(inputs.bamFile.nameroot).readnum

doc: |
  returns the number of reads inside a *.readnum file
