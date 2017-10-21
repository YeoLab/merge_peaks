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
  inputBamFile:
    type: File
    inputBinding:
      position: 2
    label: "INPUT BAM file"
    doc: "INPUT BAM file"
  peakFile:
    type: File
    inputBinding:
      position: 3
    label: "Peak file"
    doc: "Peak file"
  # mappedReadNumFile:
  #   type: File
  #   inputBinding:
  #     position: 4
  #   label: "mapped_read_num file"
  #   doc: "mapped_read_num file"
  exptReadNumFile:
    type: File
    inputBinding:
      position: 4
    label: "mapped_read_num"
    doc: "mapped_read_num"
  inputReadNumFile:
    type: File
    inputBinding:
      position: 5
    label: "mapped_read_num"
    doc: "mapped_read_num"
  output:
    type: string
    inputBinding:
      position: 6

outputs:
  outputFile:
    type: File
    outputBinding:
      glob: $(inputs.output)
  outputFullFile:
    type: File
    outputBinding:
      glob: "$(inputs.output).full"
