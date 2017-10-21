#!/usr/bin/env cwltool

cwlVersion: v1.0

class: CommandLineTool

baseCommand: [get_reproducing_peaks.pl]

inputs:
  rep1FullInFile:
    type: File
    inputBinding:
      position: 1
    label: "rep1 full out after idr (.01.bed.full or rep1.bed.full)"
    doc: "rep1 full out after idr (.01.bed.full or rep1.bed.full)"
  rep2FullInFile:
    type: File
    inputBinding:
      position: 2
    label: "rep1 full out after idr (.02.bed.full or rep2.bed.full)"
    doc: "rep1 full out after idr (.02.bed.full or rep2.bed.full)"
  rep1FullOut:
    type: string
    inputBinding:
      position: 3
    label: "rep1 full out after this step"
    doc: "rep1 full out after this step"
  rep2FullOut:
    type: string
    inputBinding:
      position: 4
    label: "rep2 full out after this step"
    doc: "rep2 full out after this step"
  bedOut:
    type: string
    inputBinding:
      position: 5
    label: "final reproduced peaks?"
    doc: "final reproduced peaks?"
  customBedOutput:
    type: string
    inputBinding:
      position: 6

  rep1EntropyFile:
    type: File
    inputBinding:
      position: 7
    label: "entropy file 1"
    doc: "entropy file 1"
  rep2EntropyFile:
    type: File
    inputBinding:
      position: 8
    label: "entropy file 2"
    doc: "entropy file 2"
  idrFile:
    type: File
    inputBinding:
      position: 9
    label: "IDR File"
    doc: "IDR File"

outputs:
  rep1FullOutFile:
    type: File
    outputBinding:
      glob: $(inputs.rep1FullOut)
  rep2FullOutFile:
    type: File
    outputBinding:
      glob: $(inputs.rep2FullOut)
  bedOutFile:
    type: File
    outputBinding:
      glob: $(inputs.bedOut)
  customBedOutputFile:
    type: File
    outputBinding:
      glob: $(inputs.customBedOutput)

