# merge_peaks
Pipeline for using IDR to produce a set of peaks given two replicate eCLIP peaks

# Requires:

- perl=5.10.1 (untested with 5.22 but should work although not guaranteed to be identical to ENCODE outputs)
    - Statistics::Basic
    - Statistics::Distributions
    - Statistics::R
- IDR=2.0.2
- python=3.4.5
- cwl=1.0

# Rough outline of methods:
- Normalize CLIP BAM over Input for each replicate (overlap_peakfi_with_bam_PE.cwl)
- Peak compression/merging on input-normalized peaks for each replicate (compress_l2foldenrpeakfi_for_replicate_overlapping_bedformat_outputfull.cwl)
- Entropy calculation on CLIP and INPUT read probabilities within each peak for each replicate (make_informationcontent_from_peaks.cwl)
- Reformat *.full files into *.bed files for each replicate (full_to_bed.cwl)
- Run IDR on peaks ranked by entropy (idr.cwl)
- Separate merged IDR peaks based on original replicate peak positions (parse_idr_peaks.cwl)
- Normalize CLIP BAM over Input using new IDR peak positions (overlap_peakfi_with_bam_PE.cwl)
- Re-merge peaks (get_reproducing_peaks.cwl)