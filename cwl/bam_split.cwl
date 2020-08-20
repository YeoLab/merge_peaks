#!/usr/bin/env cwltool

cwlVersion: v1.0

class: CommandLineTool

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