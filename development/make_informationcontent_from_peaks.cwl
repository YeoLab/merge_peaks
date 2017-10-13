#!/usr/bin/env cwltool

cwlVersion: v1.0

class: CommandLineTool

baseCommand: [make_informationcontent_from_peaks.pl]

inputs:
  inputFile:
    type: string
    inputBinding:
      position: 1
  clipReadNum:
    type: File
    inputBinding:
      position: 2
    label: "clip readnum file"
    doc: "clip readnum file"
  inputReadNum:
    type: File
    inputBinding:
      position: 3
    label: "input readnum file"
    doc: "input readnum file"
  entropyOutFile:
    type: string
    inputBinding:
      position: 4
  excessReadsOutFile:
    type: string
    inputBinding:
      position: 5
outputs:
  entropyOutFile:
    type: File
    outputBinding:
      glob: $(inputs.entropyOutFile)
  excessReadsOutFile:
    type: File
    outputBinding:
      glob: $(inputs.excessReadsOutFile)
