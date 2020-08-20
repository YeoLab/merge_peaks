#!/usr/bin/env cwltool

doc: |
  Returns string expression based on file contents.

cwlVersion: v1.0

class: ExpressionTool

requirements:
  - class: InlineJavascriptRequirement

inputs:
  file:
    type: File
    inputBinding:
      loadContents: true

outputs:
  output:
    type: int

expression: "${return {'output':parseInt(inputs.file.contents)}; }"

