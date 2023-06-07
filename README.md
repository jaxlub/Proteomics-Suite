# Proteomics Accession & Residue Scripts
6/1/2023 \
Jax Lubkowitz

### Suite Contents
> full_formatter.sh \
> formatting_file.sh \
> range_finder.sh \
> proteomics.R 
___
This suite finds the the 7 residues before and after given accessions and phosphosites of interest. The input data file must match the formatting guidelines below. The suite will then reformat all of the lines to one style. Full_formatter.sh reformats each line to match the "normal line format" (see Line Formats #4). Once formatted, the data is then pulled from the NCBI and recorded in the results file. The data from the uniProt database is also pulled. This suite does not modify the original data file but builds a new identical one with the new sequences. In addition to a results file, a formatted.txt file is produced (without the sequences). Ranges.txt captures the start and end phosphosites and their corresponding accession. Formatted.txt contains the initial data file (without sequences) formatted properly. This can be beneficial to ensure proper data is pulled. All other intermediate files are deleted. 
___
### Parameters
This program has 2 parameters that must be called on the command line.
1. The data file name
2. The desired name for the results \
Example:
```sh
sh formatting_file.sh data_file.txt result_file_name.txt
```
___
### Line Formats
Data lines can be formatted four ways. 
1. One line entry has multiple accessions and corresponding residues. 
    * Example: "P68369; P68373" are both present. 

    42	FALSE	[K].TIGGGDDSFNTFFSETGAGK.[H]	1xTMT6plex [K20];1xTMT6plex [N-Term];1xPhospho [S14(99.4)]	*------------*-----*	DSFNTFFSETGAGKH	<span style="background-color: yellow;">P68369; P68373</span>	P68369 [41-60]; P68373 [41-60]	P68369 1xPhospho [S54(99.4)]; P68373 1xPhospho [S54(99.4)]	3.135	0.000794486	0.012687699	5.34
2. One line entry has multiple residues for a single accession (2x residue form). 
    * Example: "2xPhospho [T3(100); S7(100)]" contains 2 residues. 

    402	FALSE	[R].KGTGDCSDEEVDGK.[A]	1xCarbamidomethyl [C6];2xTMT6plex [K1; K14];1xTMT6plex <span style="background-color: yellow;">[N-Term];2xPhospho [T3(100); S7(100)]</span>	*-*--**------*		Q8VDD5	Q8VDD5 [1937-1950]	Q8VDD5 2xPhospho [T1939(100); S1943(100)]	1.839	0.027393294	0.071184451	3.93
3. One line entry has multiple residues for a single accession (1x residue form).
    * Example: "1xPhospho [S1321(100)]; 1xPhospho [S2694(100)]" contains 2 residues. 

    81	FALSE	[K].ISMPDLHLK.[G]	1xTMT6plex [K9];1xTMT6plex [N-Term];1xPhospho [S2(100)]	**------*	NIKAPKISMPDLHLK	E9Q616	<span style="background-color: yellow;">E9Q616 [1320-1328]; [2693-2701]; [3655-3663]; [3909-3917]	E9Q616 1xPhospho [S1321(100)]; 1xPhospho [S2694(100)]; 1xPhospho [S3656(100)]; 1xPhospho [S3910(100)]</span>	2.754	0.008371841	0.03576279	3.68
4. One line entry has one accession and one residue (ie. normal line).
    * Example: Normal line 
    
    1   FALSE	[R].NQGGYGGSSSSSSYGSGR.[R]	1xTMT6plex [N-Term];1xPhospho [S8(99.1)]	*------*----------	NQGGYGGSSSSSSYG	P49312	P49312 [301-318]	P49312 1xPhospho [S308(99.1)]	24.736	0.045691427	0.098111569	4.04
___
### Assumptions
* Lines are formatted in one of the four styles fore mentioned.

* A line does not contain more than 15 residues or accessions. 

* Data file is a tab delimited text (.txt) formatted with columns (from left to right)  as Line number, Checked, Annotated Sequence	Modifications, Modification Pattern, Master Protein Accessions, Positions in Master Proteins, Modifications in Master Proteins, Abundance Ratio: (R) / (M), Abundance Ratio P-Value: (R) / (M), Abundance Ratio Adj. P-Value: (R) / (M), XCorr (by Search Engine): Sequest HT. 
    * Example: \
    1   FALSE	[K].RFSLFGK.[K]	1xTMT6plex [K7];1xTMT6plex [N-Term];1xPhospho [S3(100)]	*-*---*	KDKEKRFSLFGKKKX	Q62261	Q62261 [2355-2361]	Q62261 1xPhospho [S2357(100)]	8.53	0.004689615	0.027635769	3.01
