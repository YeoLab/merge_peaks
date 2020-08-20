#!/usr/bin/env cwltool

cwlVersion: v1.0

class: CommandLineTool

hints:
  - class: DockerRequirement
    dockerPull: brianyee/samtools:1.6
    
baseCommand:
  - samtools
  - merge

arguments:
  - $(inputs.rep1_bam.basename)_$(inputs.rep2_bam.basename).merged.bam

inputs:

  rep1_bam:
    type: File
    inputBinding:
      position: 2

  rep2_bam:
    type: File
    inputBinding:
      position: 3

outputs:

  merged_bam_file:
    type: File
    outputBinding:
      glob: $(inputs.rep1_bam.basename)_$(inputs.rep2_bam.basename).merged.bam

doc: |
  merges 2 bam files together