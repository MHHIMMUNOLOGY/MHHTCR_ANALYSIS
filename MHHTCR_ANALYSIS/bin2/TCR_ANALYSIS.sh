#!/bin/bash
# Make a mix of Shell and R script

############### Assign Variables #########################
figlet -c TcR HUMAN Analysis


# Experiment Name/Title
EXP=$1
# Directories $2 has to be the name of the sequencing run. $WD has to lead to the VDJ files.
WD=$HOME/sequencing/$2/IMGT/VDJRESULTS
VDJRESULTS=$WD
TCRRESULTS=$WD/`basename $EXP`_results
SCRIPTS=$HOME/bin2
VDJDIR=$HOME/sequencing/files_programs/vdjtools/vdjtools.jar
SPECIES=$3

# Files that are from one experiment (i.e Input, D4, D14, D21)
FILE1=$4
FILE2=$5
FILE3=$6
FILE4=$7
FILE5=$8
FILE6=$9
FILE7=${10}
FILE8=${11}
FILE9=${12}
FILE10=${13}
FILE11=${14}
FILE12=${15}
FILE13=${16}
FILE14=${17}
FILE15=${18}
FILE16=${19}
FILE17=${20}
FILE18=${21}
FILE19=${22}
FILE20=${23}
FILE21=${24}
FILE22=${25}
FILE23=${26}
FILE24=${27}
FILE25=${28}
FILE26=${29}
FILE27=${30}
FILE28=${31}
FILE29=${32}
FILE30=${33}

####################### Check before Script starts ######################
echo " "
echo "####### Please check if all the information is correct: #######"
echo " "
echo "----- Miseq Run:" $2
echo "----- Experiment Name:" $1
echo "----- VDJ Directory:" $WD
echo " "


if [[ "$PWD" != "$WD" ]]; then echo "----- YOU ARE NOT IN THE VDJRESULTS DIRECTORY. Please move to $WD <-- ********";
			echo "Type: cd $HOME/sequencing/FOLDERNAME/IMGT/VDJRESULTS"
			echo "Then use following Syntax when running the script:";
			echo "TCR_ANALYSIS.sh EXPERIMENTNAME FOLDERNAME MOUSE/HUMAN FILE1 FILE2 FILE3 etc..."; 
			echo "You can only choose one of two species and it has to be written in captial letters i.e HUMAN or MOUSE.";
			exit 1  ;fi
echo " "
if [[ "$4" ]]; then echo "----- Sample 1:" $4 ; else "----- No samples provided" $4 ;fi
if [[ "$5" ]]; then echo "----- Sample 2:" $5 ;fi
if [[ "$6" ]]; then echo "----- Sample 3:" $6 ; else "----- MIN. OF 3 SAMPLES REQUIRED!";fi
if [[ "$7" ]]; then echo "----- Sample 4:" $7 ;fi
if [[ "$8" ]]; then echo "----- Sample 5:" $8 ;fi
if [[ "$9" ]]; then echo "----- Sample 6:" $9 ;fi
if [[ "${10}" ]]; then echo "----- Sample 7:" ${10} ;fi
if [[ "${11}" ]]; then echo "----- Sample 8:" ${11} ;fi
if [[ "${12}" ]]; then echo "----- Sample 9:" ${12} ;fi
if [[ "${13}" ]]; then echo "----- Sample 10:" ${13} ;fi
if [[ "${14}" ]]; then echo "----- Sample 11:" ${14};fi
if [[ "${15}" ]]; then echo "----- Sample 12:" ${15} ;fi
if [[ "${16}" ]]; then echo "----- Sample 13:" ${16} ;fi
if [[ "${17}" ]]; then echo "----- Sample 14:" ${17} ;fi
if [[ "${18}" ]]; then echo "----- Sample 15:" ${18} ;fi
if [[ "${19}" ]]; then echo "----- Sample 16:" ${19} ;fi
if [[ "${20}" ]]; then echo "----- Sample 17:" ${20} ;fi
if [[ "${21}" ]]; then echo "----- Sample 18:" ${21} ;fi
if [[ "${22}" ]]; then echo "----- Sample 19:" ${22} ;fi
if [[ "${23}" ]]; then echo "----- Sample 20:" ${23} ;fi
if [[ "${24}" ]]; then echo "----- Sample 21:" ${24} ;fi
if [[ "${25}" ]]; then echo "----- Sample 22:" ${25} ;fi
if [[ "${26}" ]]; then echo "----- Sample 23:" ${26} ;fi
if [[ "${27}" ]]; then echo "----- Sample 24:" ${27} ;fi
if [[ "${28}" ]]; then echo "----- Sample 25:" ${28} ;fi
if [[ "${29}" ]]; then echo "----- Sample 26:" ${29} ;fi
if [[ "${30}" ]]; then echo "----- Sample 27:" ${30} ;fi
if [[ "${31}" ]]; then echo "----- Sample 28:" ${31} ;fi
if [[ "${32}" ]]; then echo "----- Sample 29:" ${32} ;fi
if [[ "${33}" ]]; then echo "----- Sample 30:" ${33} ;fi
echo "----- If you have more than 30 Samples please contact the author (solai.raha@gmail.com)"
echo " "
if [[ "$3" == "MOUSE" ]] || [[ "$3" == "HUMAN" ]]; then echo "You are now running this script to analyse " $SPECIES; echo "samples. Please provide ONLY " $SPECIES; echo "samples."; 
			else echo "YOU HAVE NOT CHOSEN A SPECIES. ARE THESE HUMAN OR MOUSE SAMPLES?"; 
				echo "Use following Syntax when running the script:";
				echo "TCR_ANALYSIS.sh EXPERIMENTNAME FOLDERNAME MOUSE/HUMAN FILE1 FILE2 FILE3 etc..."; 
				echo "You can only choose one of two species and it has to be written in captial letters i.e HUMAN or MOUSE."; exit 1 ;fi

if [[ "$PWD" == "$WD" ]]; then echo "----- You are currently in the VDJRESULTS folder. GOOD TO GO!"  ;fi

echo " "

read -p "Press Enter to Continue"

set | grep ^FILE[0-9]*= | cut -d"=" -f2 | sed '/^$/d' > $VDJRESULTS/META_FILENAME
sed -e 's/.txt//' $VDJRESULTS/META_FILENAME > $VDJRESULTS/META_SAMPLEID
paste $VDJRESULTS/META_FILENAME $VDJRESULTS/META_SAMPLEID > $VDJRESULTS/METADATA
echo -e "#file.name\tsample.id" | cat - $VDJRESULTS/METADATA > $VDJRESULTS/METADATA_HEAD


#############################################################################

#Start the R Script that does all the analysis with the tcR-Package
Rscript $HOME/bin2/tcR_SCRIPT.R $SPECIES $WD $FILE1 $FILE2 $FILE3 $FILE4 $FILE5 $FILE6 $FILE7 $FILE8 $FILE9 $FILE10 $FILE11 $FILE12 $FILE13 $FILE14 $FILE15 $FILE16 $FILE17 $FILE18 $FILE19 $FILE20 $FILE21 $FILE22 $FILE23 $FILE24 $FILE25 $FILE26 $FILE27 $FILE28 $FILE29 $FILE30

#read -p "pause"
# If there is no directory named X, then make it. If there is, don't do anything
if [ ! -d $TCRRESULTS ]; then mkdir -p $TCRRESULTS; fi;


#This is to put all Diversity Index Files in one file and have one empty line inbetween each Index
cat $WD/tcR_div_Chao.txt > $WD/tempfile
echo -e '\t' >> $WD/tempfile
cat $WD/tcR_div_EcoDiv*.txt >> $WD/tempfile
echo -e '\t' >> $WD/tempfile
cat $WD/tcR_div_Gini*.txt >> $WD/tempfile
echo -e '\t' >> $WD/tempfile
cat $WD/tcR_div_Inv*.txt >> $WD/tempfile
#This is needed because the Chao Index Header needs a Tab to display correctly
echo -e -n '\t' > $WD/tcR_Diversity_Analysis.txt
cat $WD/tempfile >> tcR_Diversity_Analysis.txt
rm $WD/tcR_div*
rm $WD/tempfile
mv $WD/tcR_* $TCRRESULTS



#Make a list of all files that are then compared with each other for VDJ pearson analysis
#The set command lists every variable from the environment, the grep command takes
#only those that have the string "FILE" and a number after it and the sed command
#removes "FILEx=" so we are left with the filename
set | grep 'FILE[0-9]' > $VDJRESULTS/ALLSAMPLES.txt
#the .* is the wildcard, any string between "FILE" and "=" fill match it. the "." before it
#makes it possible to use within the sed pattern


sed -i.bak 's/.*=//' $VDJRESULTS/ALLSAMPLES.txt
sed -i.bak '/^\s*$/d' $VDJRESULTS/ALLSAMPLES.txt



# #This will transpose the file
#awk '{OFS=RS;$1=$1}1' $VDJRESULTS/ALLSAMPLES.txt > ALLSAMPLES2.txt

#This will compare every sample/filename with every possible combination of samples
awk  '{ a[$0] } END {for (i in a){for (j in a){if (i != j)  print (i "," j)}}}' $VDJRESULTS/ALLSAMPLES.txt > $VDJRESULTS/ALLSAMPLES2.txt
sed -i.bak 's/,/\t/g' $VDJRESULTS/ALLSAMPLES2.txt

#This will remove every line in which the same sample is next to its self (SF117 vs SF117 etc)
#because this can cause problems later when using VDJ (errors)
Rscript $HOME/bin2/Pearson_R1.2.R $VDJRESULTS ALLSAMPLES2.txt

sed -i.bak 's/"//' $VDJRESULTS/COMBINATION_CLEAN
sed -i.bak 's/"//' $VDJRESULTS/COMBINATION_CLEAN
sed -i.bak 's/"//' $VDJRESULTS/COMBINATION_CLEAN
sed -i.bak 's/"//' $VDJRESULTS/COMBINATION_CLEAN

#This will save the line number in var
LN="$(wc -l $VDJRESULTS/COMBINATION_CLEAN | cut -d " " -f 1)"

for ((i=1;i<=${LN};i++))
do
  FILE="$(head -n $i "$VDJRESULTS/COMBINATION_CLEAN" | tail -n 1 | cut -f 1)"
  bash $SCRIPTS/VDJ_Pearson.sh $2 ${EXP}_results ${FILE}
done


java -jar $VDJDIR JoinSamples -p -m $VDJRESULTS/METADATA_HEAD $VDJRESULTS/tcR_VennDiagramm_
mv $WD/tcR_* $TCRRESULTS


#continue with VDJ analysis
#This will run the VDJ_ANALYSIS.sh script IF the variable/filename has been provided
if [[ -z "$4" ]]; then echo "All samples have been processed" ; else $(bash $SCRIPTS/VDJ_ANALYSIS.sh $2 $FILE1 `basename $EXP`_results);fi
if [[ -z "$5" ]]; then echo "All samples have been processed" ; else $(bash $SCRIPTS/VDJ_ANALYSIS.sh $2 $FILE2 `basename $EXP`_results);fi
if [[ -z "$6" ]]; then echo "All samples have been processed" ; else $(bash $SCRIPTS/VDJ_ANALYSIS.sh $2 $FILE3 `basename $EXP`_results);fi
if [[ -z "$7" ]]; then echo "All samples have been processed" ; else $(bash $SCRIPTS/VDJ_ANALYSIS.sh $2 $FILE4 `basename $EXP`_results);fi
if [[ -z "$8" ]]; then echo "All samples have been processed" ; else $(bash $SCRIPTS/VDJ_ANALYSIS.sh $2 $FILE5 `basename $EXP`_results);fi
if [[ -z "$9" ]]; then echo "All samples have been processed" ; else $(bash $SCRIPTS/VDJ_ANALYSIS.sh $2 $FILE6 `basename $EXP`_results);fi
if [[ -z "${10}" ]]; then echo "All samples have been processed" ; else $(bash $SCRIPTS/VDJ_ANALYSIS.sh $2 $FILE7 `basename $EXP`_results);fi
if [[ -z "${11}" ]]; then echo "All samples have been processed" ; else $(bash $SCRIPTS/VDJ_ANALYSIS.sh $2 $FILE8 `basename $EXP`_results);fi
if [[ -z "${12}" ]]; then echo "All samples have been processed" ; else $(bash $SCRIPTS/VDJ_ANALYSIS.sh $2 $FILE9 `basename $EXP`_results);fi
if [[ -z "${13}" ]]; then echo "All samples have been processed" ; else $(bash $SCRIPTS/VDJ_ANALYSIS.sh $2 $FILE10 `basename $EXP`_results);fi
if [[ -z "${14}" ]]; then echo "All samples have been processed" ; else $(bash $SCRIPTS/VDJ_ANALYSIS.sh $2 $FILE11 `basename $EXP`_results);fi
if [[ -z "${15}" ]]; then echo "All samples have been processed" ; else $(bash $SCRIPTS/VDJ_ANALYSIS.sh $2 $FILE12 `basename $EXP`_results);fi
if [[ -z "${16}" ]]; then echo "All samples have been processed" ; else $(bash $SCRIPTS/VDJ_ANALYSIS.sh $2 $FILE13 `basename $EXP`_results);fi
if [[ -z "${17}" ]]; then echo "All samples have been processed" ; else $(bash $SCRIPTS/VDJ_ANALYSIS.sh $2 $FILE14 `basename $EXP`_results);fi
if [[ -z "${18}" ]]; then echo "All samples have been processed" ; else $(bash $SCRIPTS/VDJ_ANALYSIS.sh $2 $FILE15 `basename $EXP`_results);fi
if [[ -z "${19}" ]]; then echo "All samples have been processed" ; else $(bash $SCRIPTS/VDJ_ANALYSIS.sh $2 $FILE16 `basename $EXP`_results);fi
if [[ -z "${20}" ]]; then echo "All samples have been processed" ; else $(bash $SCRIPTS/VDJ_ANALYSIS.sh $2 $FILE17 `basename $EXP`_results);fi
if [[ -z "${21}" ]]; then echo "All samples have been processed" ; else $(bash $SCRIPTS/VDJ_ANALYSIS.sh $2 $FILE18 `basename $EXP`_results);fi
if [[ -z "${22}" ]]; then echo "All samples have been processed" ; else $(bash $SCRIPTS/VDJ_ANALYSIS.sh $2 $FILE19 `basename $EXP`_results);fi
if [[ -z "${23}" ]]; then echo "All samples have been processed" ; else $(bash $SCRIPTS/VDJ_ANALYSIS.sh $2 $FILE20 `basename $EXP`_results);fi
if [[ -z "${24}" ]]; then echo "All samples have been processed" ; else $(bash $SCRIPTS/VDJ_ANALYSIS.sh $2 $FILE21 `basename $EXP`_results);fi
if [[ -z "${25}" ]]; then echo "All samples have been processed" ; else $(bash $SCRIPTS/VDJ_ANALYSIS.sh $2 $FILE22 `basename $EXP`_results);fi
if [[ -z "${26}" ]]; then echo "All samples have been processed" ; else $(bash $SCRIPTS/VDJ_ANALYSIS.sh $2 $FILE23 `basename $EXP`_results);fi
if [[ -z "${27}" ]]; then echo "All samples have been processed" ; else $(bash $SCRIPTS/VDJ_ANALYSIS.sh $2 $FILE24 `basename $EXP`_results);fi
if [[ -z "${28}" ]]; then echo "All samples have been processed" ; else $(bash $SCRIPTS/VDJ_ANALYSIS.sh $2 $FILE25 `basename $EXP`_results);fi
if [[ -z "${29}" ]]; then echo "All samples have been processed" ; else $(bash $SCRIPTS/VDJ_ANALYSIS.sh $2 $FILE26 `basename $EXP`_results);fi
if [[ -z "${30}" ]]; then echo "All samples have been processed" ; else $(bash $SCRIPTS/VDJ_ANALYSIS.sh $2 $FILE27 `basename $EXP`_results);fi
if [[ -z "${31}" ]]; then echo "All samples have been processed" ; else $(bash $SCRIPTS/VDJ_ANALYSIS.sh $2 $FILE28 `basename $EXP`_results);fi
if [[ -z "${32}" ]]; then echo "All samples have been processed" ; else $(bash $SCRIPTS/VDJ_ANALYSIS.sh $2 $FILE29 `basename $EXP`_results);fi
if [[ -z "${33}" ]]; then echo "All samples have been processed" ; else $(bash $SCRIPTS/VDJ_ANALYSIS.sh $2 $FILE30 `basename $EXP`_results);fi


rm $VDJRESULTS/ALLSAMPLES*
rm $VDJRESULTS/COMBINATION*
rm $VDJRESULTS/META*
rm $VDJRESULTS/Rplots.pdf
rm $VDJRESULTS/intersect_pair_area.r
rm $VDJRESULTS/fancy_spectratype.r
rm $VDJRESULTS/intersect_pair_scatter.r
rm $VDJRESULTS/join_venn.r
rm $VDJRESULTS/quantile_stats.r
rm $VDJRESULTS/vj_pairing_plot.r

rename 's/.txt//g' $TCRRESULTS/FIGURES/*.pdf

figlet -c 100% Complete
