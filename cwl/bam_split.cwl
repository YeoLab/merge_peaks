#!/usr/bin/env cwltool

doc: |
  Runs a wrapper script that randomly splits a BAM file, without replacement.
  
cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InitialWorkDirRequirement
    listing:
      - $(inputs.bam)
      
hints:
  - class: DockerRequirement
    dockerPull: brianyee/merge_peaks:0.0.6
    
baseCommand:
  - bam_split.sh

arguments:
  - $(inputs.bam.nameroot).split1.bam
  - $(inputs.bam.nameroot).split2.bam

inputs:

  bam:
    type: File
    inputBinding:
      position: -1

outputs:

  split1:
    type: File
    outputBinding:
      glob: $(inputs.bam.nameroot).split1.bam

  split2:
    type: File
    outputBinding:
      glob: $(inputs.bam.nameroot).split2.bam