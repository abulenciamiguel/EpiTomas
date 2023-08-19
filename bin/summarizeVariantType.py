#!/usr/bin/env python

import argparse
import pandas as pd

def count_variant_types_in_interval(input_file, output_file, interval):
    # Load the input CSV file into a DataFrame
    df = pd.read_csv(input_file)

    # Define the range intervals
    intervals = list(range(0, max(df['Position']) + interval, interval))
    
    # Count the variant types within each interval
    counts = {interval: {variant_type: 0 for variant_type in df['Variant_Type'].unique()} for interval in intervals}
    
    for index, row in df.iterrows():
        position = row['Position']
        variant_type = row['Variant_Type']
        
        for i in range(len(intervals) - 1):
            if intervals[i] <= position < intervals[i + 1]:
                counts[intervals[i]][variant_type] += 1
                break
    
    # Convert the counts dictionary to a DataFrame
    result_df = pd.DataFrame(counts).T
    
    # Write the result DataFrame to the output CSV file
    result_df.to_csv(output_file)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Count variant types within specified range intervals")
    parser.add_argument("--input", required=True, help="Path to the input CSV file")
    parser.add_argument("--output", required=True, help="Path to the output CSV file")
    parser.add_argument("--interval", type=int, required=True, help="Interval size for counting")

    args = parser.parse_args()

    count_variant_types_in_interval(args.input, args.output, args.interval)
