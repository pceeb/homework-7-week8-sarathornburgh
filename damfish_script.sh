#!/bin/bash


# This script combines an OTU file with sequencing data and a taxonomic file into one, complete file to prep for statistical analysis.
 
# To use the script, enter the following command prompt " sh damfish_script.sh $1 $2 $3 " with $1 being the title of the OTU file (without an ending such as .tsv) and $2 should be the title of the taxonomy file (not including the ending such as .tsv). $3 will be the title you wish the output file to be named (without the ending such as .tsv).

# This script will output a file called "$3.tsv", with $3 being the third variable entered in the command prompt, which should be the title you want to give the complete file.



# The following replaces the ";" delimiter with a tab for the OTU file and outputs it to a file called $1_tab.tsv

sed 's/;/\t/g' $1.tsv > $1_tab.tsv

sed 's/;/\t/g' $2.tsv > $2_tab.tsv

echo "Processing the OTU  and taxonomic files..."


# The following takes the header from the OTU file with sequencing data and adds it into a separate file called $1_header.tsv.

grep '#' $1_tab.tsv > $1_header.tsv


# The following takes the data from the OTU file with sequencing data and adds it into a separate file called $1_data.tsv.

tail -n+2 $1_tab.tsv > $1_data.tsv


# The following sorts the data from the OTU file alphabetically by the first column (which should contain the ID names), and adds it to a separate file called $1_sorted_data.tsv.

sort -k1 $1_data.tsv > $1_sorted_data.tsv


# The following adds both the header and the sorted data into a new file called $1_sorted.tsv. 

cat $1_header.tsv $1_sorted_data.tsv > $1_sorted.tsv

echo "OTU file is ready..."


# The following takes the header from the taxonomic file and adds it into a separate file called $2_header.tsv.

grep '#' $2_tab.tsv > $2_header.tsv

echo "Processing the taxonomic file..."


# The following takes the taxonomies from the complete taxonomic file and adds it into a separate file called $2_data.tsv.

tail -n+2 $2.tsv > $2_data.tsv


# The following sorts the taxonomies from the taxonomic file alphabetically by the first column (which should contain the ID names), and adds it to a separate file called $2_sorted_data.tsv

sort -k1 $2_data.tsv > $2_sorted_data.tsv


# The following adds both the header and the sorted data into a new file called $2_sorted.tsv.

cat $2_header.tsv $2_sorted_data.tsv > $2_sorted.tsv

echo "Taxonomic file is ready..."


# The following adds both the OTU file with sequencing data and the taxonomic file together into a file called combined_$1_$2.tsv.

paste $2_sorted.tsv $1_sorted.tsv > $3.tsv

echo "The OTU file and taxonomic file has been merged..."


# The following removes all the files made while running the script.

echo "Removing unnecessary files..."

rm $1_tab.tsv

rm $1_header.tsv

rm $1_data.tsv

rm $1_sorted_data.tsv

rm $1_sorted.tsv

rm $2_tab.tsv

rm $2_header.tsv

rm $2_data.tsv

rm $2_sorted_data.tsv

rm $2_sorted.tsv


echo "The files are ready! :)"
