#!/bin/bash

# Jax Lubkowitz

# This script is used to format the data for the range_finder script
# This means one accessions and residue per line

file=$1
return_file=$2

while IFS= read -r line;
do
    line_number=$(echo "$line" | cut -f1 -d$'\t')
    checked=$(echo "$line" | cut -f2 -d$'\t')
    annotated_sequence=$(echo "$line" | cut -f3 -d$'\t')
    modifications=$(echo "$line" | cut -f4 -d$'\t')
    modification_pattern=$(echo "$line" | cut -f5 -d$'\t')
    sequence=$(echo "$line" | cut -f6 -d$'\t')
    master_protein_accessions=$(echo "$line" | cut -f7 -d$'\t')
    position=$(echo "$line" | cut -f8 -d$'\t')
    modifications_in_MP=$(echo "$line" | cut -f9 -d$'\t')
    abundance_ratio=$(echo "$line" | cut -f10 -d$'\t')
    abundance_ratioP=$(echo "$line" | cut -f11 -d$'\t')
    abundance_ratioAP=$(echo "$line" | cut -f12 -d$'\t')
    xcorr=$(echo "$line" | cut -f13 -d$'\t')
    #echo "$line_number\t$checked\t$annotated_sequence\t$modifications\t$modification_pattern\t$sequence\t$master_protein_accessions\t$position\t$modifications_in_MP\t$abundance_ratio\t$abundance_ratioP\t$abundance_ratioAP\t$xcorr"
    if [[ "$master_protein_accessions" != *";"* && "$modifications_in_MP" != *";"* ]]; then #normal data
        echo "$line" >> $return_file
    else
        doubleXcut=$(echo "$modifications_in_MP" | cut -f3 -d "o") #2x phosphoros residues
        if [[ "$master_protein_accessions" == *"; "* ]]; then
            # This means accessions has multiple proteins on 1 line 
            # Example: 
            # 42	FALSE	[K].TIGGGDDSFNTFFSETGAGK.[H]	1xTMT6plex [K20];1xTMT6plex [N-Term];1xPhospho [S14(99.4)]	*------------*-----*	DSFNTFFSETGAGKH	P68369; P68373	P68369 [41-60]; P68373 [41-60]	P68369 1xPhospho [S54(99.4)]; P68373 1xPhospho [S54(99.4)]	3.135	0.000794486	0.012687699	5.34

            # Add Original line
            data=$(echo $modifications_in_MP | cut -f1 -d "]")
            accession=$(echo "$data" | cut -f1 -d " ")
            position1=$(echo "$position" | cut -f1 -d";")
            position2=$(echo "$position" | cut -f2 -d";")
            echo "$line_number\t$checked\t$annotated_sequence\t$modifications\t$modification_pattern\t$sequence\t$accession\t$position1\t$data]\t$abundance_ratio\t$abundance_ratioP\t$abundance_ratioAP\t$xcorr" >> $return_file

            # make new line for next part
            data2=$(echo "$modifications_in_MP" | cut -d "]" -f2- | cut -c 3-)
            accession2=$(echo "$master_protein_accessions" | cut -f2- -d" ") 
            position2=$(echo "$position" | cut -f2 -d";" | cut -d" " -f2-)
            echo "$line_number\t$checked\t$annotated_sequence\t$modifications\t$modification_pattern\t$sequence\t$accession2\t$position2\t$data2\t$abundance_ratio\t$abundance_ratioP\t$abundance_ratioAP\t$xcorr" >> $return_file
            echo "Wrong Proteins: $master_protein_accessions"

        elif [[ "$doubleXcut" == *"); "*[0-9]* ]]; then
            # This means protein has multiple residues (in form "2xPhospho [S5553(100); S5555(100)]")
            # Example
            # 402	FALSE	[R].KGTGDCSDEEVDGK.[A]	1xCarbamidomethyl [C6];2xTMT6plex [K1; K14];1xTMT6plex [N-Term];2xPhospho [T3(100); S7(100)]	*-*--**------*		Q8VDD5	Q8VDD5 [1937-1950]	Q8VDD5 2xPhospho [T1939(100); S1943(100)]	1.839	0.027393294	0.071184451	3.93
            data1=$(echo "$doubleXcut" | cut -f1 -d ";")
            data2=$(echo "$doubleXcut" | cut -f2 -d ";" | cut -c 2-)
            accession=$(echo "$master_protein_accessions")
            echo "$line_number\t$checked\t$annotated_sequence\t$modifications\t$modification_pattern\t$sequence\t$master_protein_accessions\t$position\t$accession 1xPhospho$data1]\t$abundance_ratio\t$abundance_ratioP\t$abundance_ratioAP\t$xcorr" >> $return_file
            echo "$line_number\t$checked\t$annotated_sequence\t$modifications\t$modification_pattern\t$sequence\t$master_protein_accessions\t$position\t$accession 1xPhospho [$data2\t$abundance_ratio\t$abundance_ratioP\t$abundance_ratioAP\t$xcorr" >> $return_file
            echo "Multiple Residues for a Protein (2x): $doubleXcut"

        elif [[ "$doubleXcut" == *"];"* ]]; then 
            # This means a line has 1 protein but multiple 1x residues
            # Example
            # 81	FALSE	[K].ISMPDLHLK.[G]	1xTMT6plex [K9];1xTMT6plex [N-Term];1xPhospho [S2(100)]	**------*	NIKAPKISMPDLHLK	E9Q616	E9Q616 [1320-1328]; [2693-2701]; [3655-3663]; [3909-3917]	E9Q616 1xPhospho [S1321(100)]; 1xPhospho [S2694(100)]; 1xPhospho [S3656(100)]; 1xPhospho [S3910(100)]	2.754	0.008371841	0.03576279	3.68
            data1=$(echo "$modifications_in_MP" | cut -f1 -d ";")
            data2=$(echo "$modifications_in_MP" | cut -f2- -d ";")
            accession=$(echo "$master_protein_accessions")
            echo "$line_number\t$checked\t$annotated_sequence\t$modifications\t$modification_pattern\t$sequence\t$master_protein_accessions\t$position\t$data1\t$abundance_ratio\t$abundance_ratioP\t$abundance_ratioAP\t$xcorr" >> $return_file
            echo "$line_number\t$checked\t$annotated_sequence\t$modifications\t$modification_pattern\t$sequence\t$master_protein_accessions\t$position\t$accession$data2\t$abundance_ratio\t$abundance_ratioP\t$abundance_ratioAP\t$xcorr" >> $return_file
            echo "Multiple Residues for a Protein: $doubleXcut"

        else
            # This means line contains a semicolin that doesn't matter such as "; T/S" or the line is now a fixed line
            echo fixing...
            echo "$line" >> $return_file
        fi
    fi
done <$file



        





