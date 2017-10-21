#!/usr/bin/env cwltool

cwlVersion: v1.0

class: CommandLineTool

baseCommand: [make_informationcontent_from_peaks.pl]

inputs:
  inputFile:
    type: File
    inputBinding:
      position: 1
  clipReadNum:
    type: File
    inputBinding:
      position: 2
    label: "clip readnum number FILE"
    doc: "clip readnum number FILE"
  inputReadNum:
    type: File
    inputBinding:
      position: 3
    label: "input readnum number FILE"
    doc: "input readnum number FILE"
  entropyOutFileName:
    type: string
    inputBinding:
      position: 4
  excessReadsOutFileName:
    type: string
    inputBinding:
      position: 5
outputs:
  entropyOutFile:
    type: File
    outputBinding:
      glob: $(inputs.entropyOutFileName)
  excessReadsOutFile:
    type: File
    outputBinding:
      glob: $(inputs.excessReadsOutFileName)
