#!/usr/bin/env cwltool

cwlVersion: v1.0
class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: 1
    ramMin: 16000

hints:
  - class: DockerRequirement
    dockerPull: brianyee/merge_peaks:0.1.0

baseCommand: [make_informationcontent_from_peaks.pl]

inputs:

  compressed_bed_full:
    type: File
    inputBinding:
      position: 1

  clip_read_num:
    type: File
    inputBinding:
      position: 2
    doc: "A file containing a single number corresponding to the number of mapped reads (-cF 4) in CLIP"
    
  input_read_num:
    type: File
    inputBinding:
      position: 3
    doc: "A file containing a single number corresponding to the number of mapped reads (-cF 4) in INPUT"
    
  output_file:
    type: string
    default: ""
    inputBinding:
      position: 4
      valueFrom: |
        ${
          if (inputs.output_file == "") {
            return inputs.compressed_bed_full.nameroot + ".entropy.full";
          }
          else {
            return inputs.output_file;
          }
        }

  output_excess_reads:
    type: string
    default: ""
    inputBinding:
      position: 5
      valueFrom: |
        ${
          if (inputs.output_excess_reads == "") {
            return inputs.compressed_bed_full.nameroot + ".entropy.excessreads";
          }
          else {
            return inputs.output_excess_reads;
          }
        }

outputs:

  entropy_full:
    type: File
    outputBinding:
      glob: |
        ${
          if (inputs.output_file == "") {
            return inputs.compressed_bed_full.nameroot + ".entropy.full";
          }
          else {
            return inputs.output_file;
          }
        }

  entropy_excess_reads:
    type: File
    outputBinding:
      glob: |
        ${
          if (inputs.output_excess_reads == "") {
            return inputs.compressed_bed_full.nameroot + ".entropy.excessreads";
          }
          else {
            return inputs.output_excess_reads;
          }
        }