#!/bin/bash


# This script combines an OTU file with sequencing data and a taxonomic file into one, complete file to prep for statistical analysis. This script should be used only if your taxonomic file does not have 7 complete taxon columns ("Kingdom   Phylum  Class   Order   Family  Genus   Species") and if there are empty values in columns.

# To use the script, enter the following command prompt: " sh damfish_script_filler.sh $1 $2 $3 " with $1 being the title of the OTU file (without an ending such as .tsv) and $2 should be the title of the taxonomy file (not including the ending such as .tsv). $3 will be the title you wish the output file to be named (without the ending such as .tsv).
 
# This script will output a file called "$3.tsv", with $3 being the third variable entered in the command prompt, which should be the title you want to give the complete file.


#The following portion of the script takes the taxonomic file from the user, and creates a new file with the taxon breakdown in separate columns and with "unassigned" filled in for empty spaces.


# Extracts the column containing the taxon information into the file extracted_taxon_$2.tsv.

awk '{ print $1 }' $2.tsv > first_column_$2.tsv

awk '{ print $2 }' $2.tsv > extracted_taxon_$2.tsv


# Replaces a semi-colon with a tab to create more columns to fill the taxon breakdown needed and creates a file called taxon_breakdown_$2.tsv.

sed 's/;/\t/g' extracted_taxon_$2.tsv > taxon_breakdown_$2.tsv

echo "The code is running..."


# Creates a while loop that reads through the lines of the file.

while IRS= read -r line

do

 # Counts the number of columns in each line.

 columns=`echo $line | wc -w`

 # Creates a for loop that reads through the number of columns.

 for i in $columns

  do

  # Creates a variable called "add" that finds the number of columns that needs to be added for each line of the file.

  x=7

  add=$(( x - i ))

  # Creates an if loop that adds the correct number of columns needed for each line and replaces empty spaces with "unassigned". A file called filled_columns_$2.tsv is formed.

  if [ $add -eq 0 ]

  then

   echo "$line" >> filled_columns_$2.tsv

  elif [ $add -eq 1 ]

  then

   echo "$line   unassigned" >> filled_columns_$2.tsv

  elif [ $add -eq 2 ]

  then

   echo "$line    unassigned      unassigned" >> filled_columns_$2.tsv

  elif [ $add -eq 3 ]

  then

   echo "$line    unassigned      unassigned      unassigned" >> filled_columns_$2.tsv

  elif [ $add -eq 4 ]

  then

   echo "$line    unassigned      unassigned      unassigned      unassigned" >> filled_columns_$2.tsv

  elif [ $add -eq 5 ]

  then

   echo "$line    unassigned      unassigned      unassigned      unassigned	unassigned" >> filled_columns_$2.tsv

  elif [ $add -eq 6 ]

  then

   echo "$line    unassigned      unassigned      unassigned      unassigned	unassigned	unassigned" >> filled_columns_$2.tsv

  elif [ $add -eq 7 ]

  then

   echo "unassigned       unassigned      unassigned      unassigned	unassigned	unassigned	unassigned" >> filled_columns_$2.tsv

  else

   echo "This line is empty."

  fi

 done

done < taxon_breakdown_$2.tsv


# Takes the data from the filled_columns_$2.tsv.

tail -n+2 filled_columns_$2.tsv > filled_data_$2.tsv


# Creates a new header for the data and forms a new file called filled_header_$2.tsv

echo "Kingdom   Phylum  Class   Order   Family  Genus   Species" > filled_header_$2.tsv


# Adds the header and the data into a new, final file called complete_$2.tsv

cat filled_header_$2.tsv filled_data_$2.tsv > taxon_$2.tsv


# Adds the taxon columns with the feature ID column into a file called complete_taxon_$2.tsv.

paste first_column_$2.tsv taxon_$2.tsv > complete_taxon_$2.tsv

echo "Taxonomic file is filled..."


# Removes all the files that are no longer needed.

echo "Removing unnecessary files..."

rm first_column_$2.tsv

rm extracted_taxon_$2.tsv

rm taxon_breakdown_$2.tsv

rm filled_columns_$2.tsv

rm filled_data_$2.tsv

rm filled_header_$2.tsv

rm taxon_$2.tsv


# The following replaces the ";" delimiter with a tab for the OTU file and outputs it to a file called $1_tab.tsv

sed 's/;/\t/g' $1.tsv > $1_tab.tsv

echo "Processing the OTU file..."


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

grep '#' complete_taxon_$2.tsv > $2_header.tsv

echo "Processing the taxonomic file..."


# The following takes the taxonomies from the complete taxonomic file and adds it into a separate file called $2_data.tsv.

tail -n+2 complete_taxon_$2.tsv > $2_data.tsv


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

# rm $2_tab.tsv

rm $2_header.tsv

rm $2_data.tsv

rm $2_sorted_data.tsv

rm $2_sorted.tsv


echo "The files are ready! :)"
