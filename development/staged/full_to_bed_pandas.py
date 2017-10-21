#!/usr/bin/env python

"""
basic module to use as an example.
"""
import argparse
import pandas as pd
import os

def get_strand_info_from_region(row):
    return row[3].split(':')[2]

def round_entropy_score(row):
    return float("{0:.10f}".format(row[12]))

def round_fold_change(row):
    return float("{0:.15f}".format(row[11]))

def to_bed(df):
    df['strand'] = df.apply(get_strand_info_from_region, axis=1)
    df['foldchange'] = df.apply(round_fold_change, axis=1)
    df['entropy'] = df.apply(round_entropy_score, axis=1)
    return df[[0, 1, 2, 'foldchange', 'entropy', 'strand']]

def full_to_bed(input_file, output_file, fold_change_filter):
    """
    Turns a *.full file into a BED file with: 
    - l2fc now equal to the 'name' (col 4)
    - entropy now equal to the 'score' (col 5)
    """
    df = pd.read_table(input_file, names=range(16))
    df = df[df[11] > fold_change_filter]

    bed = to_bed(df)
    bed.to_csv(output_file, sep='\t', index=False, header=False)

def main():
    """
    Turns a *.full file into a BED file with: 
    - l2fc now equal to the 'name' (col 4)
    - entropy now equal to the 'score' (col 5)
    """
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--input",
        required=True,
    )
    parser.add_argument(
        "--output",
        required=True,
    )
    parser.add_argument(
        "--fold_change_filter",
        required=False,
        default=0,
        help='pre-filter peaks that are enriched over input (default: 0)'
    )
    args = parser.parse_args()

    input_file = args.input
    output_file = args.output
    fold_change_filter = args.fold_change_filter

    full_to_bed(
        input_file, output_file, fold_change_filter
    )

if __name__ == "__main__":
    main()
