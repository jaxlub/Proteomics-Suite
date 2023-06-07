#!/bin/bash

# Finding Protein Accessions residue ranges and extracting sequence from NCBI database
#Jax Lubkowitz

#sh -c "$(curl -fsSL https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/install-edirect.sh)"

file=$1
return_file=$2
echo "Master_Protein_Accessions Residue	Start(-7) End(+7)" >> ranges.txt
echo "line_number\tchecked\tannotated_sequence\tmodifications\tmodification_pattern\tNCBI_found_sequence\tUP_found_sequence\tmaster_protein_accessions\tposition\tmodifications_in_MP\tabundance_ratio\tabundance_ratioP\tabundance_ratioAP\txcorr" >> $return_file
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

    # extract residue number
    residue=$(echo "$modifications_in_MP" | cut -d "[" -f2 | cut -d "(" -f1 | cut -d "S" -f2 | cut -d "T" -f2 | cut -d "Q" -f2)

    # make sure actual data is present (some accessions have no associated data)
    if [[ $residue =~ ^[0-9]+$ ]]; then        
    
        start=$((residue - 8))
        # extract master protein accessions
        accessions=$(echo $master_protein_accessions)  
        # ensure start is not negative
        if [[ $start -lt 0 ]]; then
            start=0
        fi 
        stop=$((residue + 6))

        protein=$(echo protein)
        cmd=$(echo "esearch -db $protein -query "$accessions" | efetch -format fasta -chr_start $start -chr_stop $stop")
        NCBI_found_sequence=$(echo $cmd | bash | awk 'NR==2') 

        cmd2=$(echo "Rscript proteomics.R "$master_protein_accessions" $residue" )
        UP_found_sequence=$(echo $cmd2 | bash | cut -f2 -d'"')


        echo "$line_number\t$checked\t$annotated_sequence\t$modifications\t$modification_pattern\t$NCBI_found_sequence\t$UP_found_sequence\t$master_protein_accessions\t$position\t$modifications_in_MP\t$abundance_ratio\t$abundance_ratioP\t$abundance_ratioAP\t$xcorr" >> $return_file 
        echo "$accessions\t$sequence\t$residue\t$start\t$stop"
        echo "$accessions\t$residue\t$start\t$stop" >> ranges.txt
    else
        echo "$line_number\t$checked\t$annotated_sequence\t$modifications\t$modification_pattern\t\t\t$master_protein_accessions\t$position\t$modifications_in_MP\t$abundance_ratio\t$abundance_ratioP\t$abundance_ratioAP\t$xcorr" >> $return_file 
        echo "$accessions" >> ranges.txt
    fi
done <$file
