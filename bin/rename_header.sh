#!/bin/bash

sed -i "s/^.*>.*$/>${1}/" 02_snippy/${1}.consensus.fa