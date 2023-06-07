#!/bin/bash

# unformatted file is input on command line
data=$1
# name of results file is second command line input
result_file=$2

# data file is  formatted
# each iteration makes one correction to each line per pass
# this opperates on the assumption that there is not more then 15 residues on one line
for f in {1..15}
do
    sh full_formatter.sh $data test$f.txt
    data=test$f.txt
done 
# store formatted file
cat test$f.txt >> formatted.txt
# delete intermediate files 
for f in {1..15}
do
    rm test$f.txt
done 

# run script to find 15 AA seqeunces of NCBI Database and put in results
sh range_finder.sh formatted.txt NCBI_seq.txt

# run script to find 15 AA seqeunces of UniPort Database and put in results
sh uniProt_seq.sh NCBI_seq.txt $result_file 
