#!/usr/bin/env python

import argparse
import csv

def extract_info_columns(vcf_file, csv_file):
    with open(vcf_file, 'r') as vcf:
        with open(csv_file, 'w', newline='') as csv_out:
            vcf_reader = csv.reader(vcf, delimiter='\t')
            csv_writer = csv.writer(csv_out)

            csv_writer.writerow(['Position', 'Variant_Type', 'Effect_Type_Region', 'Effect_Impact'])  # Write header

            for line in vcf_reader:
                if not line[0].startswith('#'):  # Skip header lines
                    pos = line[1]
                    info = line[7]
                    info_dict = dict(item.split('=') for item in info.split(';'))
                    vcf_type = info_dict.get('TYPE', '')
                    vcf_ann = info_dict.get('ANN', '')
                    ann_parts = vcf_ann.split('|')
                    if len(ann_parts) >= 3:
                        csv_writer.writerow([pos, vcf_type, ann_parts[1], ann_parts[2]])

    print(f"Extracted TYPE and ANN fields from '{vcf_file}' to '{csv_file}'")

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Extract TYPE and ANN fields from VCF INFO and write to CSV')
    parser.add_argument('--vcf', required=True, help='Input VCF file')
    parser.add_argument('--csv', required=True, help='Output CSV file')

    args = parser.parse_args()
    extract_info_columns(args.vcf, args.csv)

