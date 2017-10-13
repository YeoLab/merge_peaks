#!/usr/bin/env cwltool

cwlVersion: v1.0

class: CommandLineTool

baseCommand: [overlap_peakfi_with_bam_PE.pl]

inputs:

  experimentBamFile:
    type: File
    inputBinding:
      position: 1
    label: "IP BAM file"
    doc: "IP BAM file"
    secondaryFiles:
      - .bai
  inputBamFile:
    type: File
    inputBinding:
      position: 2
    label: "INPUT BAM file"
    doc: "INPUT BAM file"
    secondaryFiles:
      - .bai
  peakFile:
    type: File
    inputBinding:
      position: 3
    label: "Peak file"
    doc: "Peak file"
  mappedReadNumFile:
    type: File
    inputBinding:
      position: 3
    label: "mapped_read_num file"
    doc: "mapped_read_num file"
  outputFile:
    type: string
    inputBinding:
      position: 4

outputs:
  output:
    type: File
    outputBinding:
      glob: $(inputs.outputFile)
