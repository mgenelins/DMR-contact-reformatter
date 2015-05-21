#!/bin/bash
# Convert and make unique.
#  A quick and dirty script that makes the second column, the CALLSIGN column, unique
#   and re-sorts the ending by the FIRST COLUMN, putting it back into numerical order.
#  Matt Genelin - May 20, 2015
# This script needs an input.csv file from http://kd0wdq.com/getcsv.html
#
# Rev 0.1

# Remove the temp 'outputfile.txt' from the last run:
rm outputfile.txt

# The normal, given CSV file has this contents:
#  3127001,N0NMZ,Shep Shepardson,Roseville,Minnesota,United States, ,Portable
#  3127002,NH7CY,Jason Ballesteros,Saint Paul,Minnesota,United States,NH7CY,Portable
#  3127003,NH7CY,Jason Ballesteros,Saint Paul,Minnesota,United States,NH7CY,Demo


# The following 'for loop' changes the above input to this, and iterates through each "x" in the loop:
# Save the state of the current IFS in old IFS:
oldIFS=$IFS

IFS=$'\r\n' GLOBIGNORE='*'

fullfile=($(awk -f reformat_flip_first_two_columns.awk mn_hams_may_2015.csv))

for ((i=0; i<${#fullfile[@]}; i++)) 
do
echo -e "$i : ${fullfile[i]}"
currentcallsign=`echo ${fullfile[i]} | cut -d"," -f1`
echo -e "Working $i callsign of ${#fullfile[@]} : $currentcallsign \n"

 	current_i_callsign=`echo ${fullfile[i]} | cut -d"," -f1`
	current_i_ID=`echo ${fullfile[i]} | cut -d"," -f2`
	current_i_name=`echo ${fullfile[i]} | cut -d"," -f3`

 	# Put some duplicate checking in:
 	for ((j=i+1;j>i && j<${#fullfile[@]};j++))
 	do
		current_j_callsign=`echo ${fullfile[j]} | cut -d"," -f1`

#		echo -e " Comparing : $i : $current_i_callsign -- to -- $j : $current_j_callsign \n"

		# Check all callsigns FORWARD of the current 'i' for duplicates:
		if [[ $current_i_callsign == $current_j_callsign ]]
 		then
			echo -e "Duplicate found! Setting callsign $current_i_callsign -- to -- $current_i_callsign-$i\n"
			current_i_callsign="$current_i_callsign-$i"
			j=${#fullfile[@]}   # End the loop NOW.
		fi
	# sleep 1
	done
	# No dupes found, go ahead and write to the outputfile our current $i:
	echo -e "$current_i_callsign,$current_i_ID,$current_i_name" 
	echo -e "$current_i_callsign,$current_i_ID,$current_i_name" >> outputfile.txt
 									


done

# Now re-format the temp outputfile back to the ID,CALLSIGN,NAME format that our import program expects it in:
awk -f reformat_flip_first_two_columns.awk outputfile.txt |sort -k1 > outfinal.csv

# Place the IFS back to normal:
IFS=$oldIFS
