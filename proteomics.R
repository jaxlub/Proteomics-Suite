#!/usr/bin/Rscript
library("rbioapi")

args <- commandArgs(trailingOnly = TRUE)

#if (length(args) != 2) {
#  stop("Error: not 2 args provided")
#}

prot_accession <- args[1]
residue <- as.integer(args[2])

cd40 <- rba_uniprot_proteins(accession = prot_accession)
actual_sequence <- cd40[["sequence"]][["sequence"]]
start_pos <- residue - 7
stop_pos <- residue + 7 
substring(actual_sequence, start_pos, stop_pos)


