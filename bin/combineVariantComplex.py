#!/usr/bin/env python

import sys
import pandas as pd

def combine_selected_columns(csv_files):
    # Initialize an empty DataFrame to store combined data
    combined_data = pd.DataFrame()

    # Loop through each CSV file
    for csv_file in csv_files:
        # Read the CSV file
        df = pd.read_csv(csv_file)
        
        # Extract the "complex" and the first column
        selected_column = df['complex']
        first_column = df.iloc[:, 0]  # Assuming the first column is the index column
        
        # Create a DataFrame with both columns
        combined_df = pd.DataFrame({'PositionInterval': first_column, csv_file: selected_column})
        
        # Merge the combined DataFrame with the main combined_data DataFrame
        if combined_data.empty:
            combined_data = combined_df
        else:
            combined_data = pd.merge(combined_data, combined_df, on='PositionInterval', how='outer')

    # Save the combined data to a new CSV file
    combined_data.to_csv('combinedType_Complex.csv', index=False)

    print("Combined data saved to 'combinedType_Complex.csv'")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python script_name.py file1.csv file2.csv ...")
    else:
        input_csv_files = sys.argv[1:]
        combine_selected_columns(input_csv_files)
