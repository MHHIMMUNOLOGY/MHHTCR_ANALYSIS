#Pearson Correlation Batch UNIX part

set -o xtrace
set -o errexit
set -o pipefail

############## DIRECTORY VARIABLES ##############

# Home for sequencing
HOMEDIR=$HOME/sequencing

# Folder of Miseq run -> $1 is the first string after bash script i.e typing 'PHB.sh $HOME/sequencing/miseq346'
# into the commandline will run the script and save $1 as the string '$HOME/sequencing/miseq346'.
# For this script always have a folder called "sequencing" in your home directory ($HOME/sequencing) and in there
# for each directory create a folder for every run (i.e miseq346). In the command line run script like 'script.sh miseq346'
SEQDIR=$HOMEDIR/$1

# Directory for IMGT
IMGTDIR=$SEQDIR/IMGT

# Folder with 3_Nt files
NTDIR=$IMGTDIR/3_Nt

PROD=$NTDIR/productive

# Directory of the vdj.jar file

VDJDIR=$HOMEDIR/files_programs/vdjtools/vdjtools.jar

# Directory of VDJ results

VDJRESULTS=$IMGTDIR/VDJRESULTS

# Directory of PHB productive files
PHB=$IMGTDIR/5_AA/productive

# Output Directory of Pearson Correlation

PEARSON=$VDJRESULTS/PEARSON
PEARSONCALC=$IMGTDIR/PEARSON


if [ ! -d $VDJRESULTS/PEARSON ]; then mkdir -p $VDJRESULTS/PEARSON; fi;


############## Make file with a list of all files from the folder ##############
ls $VDJRESULTS/MERGED_VDJTOOLS* | xargs -n 1 basename > $VDJRESULTS/FILELIST

#This will make every possible combination from each line of FILELIST
join  -12 -22 -o 1.1,2.1 -t '
' $VDJRESULTS/FILELIST $VDJRESULTS/FILELIST | sed 'N; s/\n/ /' > $VDJRESULTS/COMBINATION


#This will remove every line in which the same sample is next to its self (SF117 vs SF117 etc)
#because this stops the Rscript
Rscript $HOME/bin2/Pearson_R1.2.R $VDJRESULTS $VDJRESULTS/COMBINATION

#The file comes in a different format out of R with "" that need to be removed:
sed 's/"//' $VDJRESULTS/COMBINATION_CLEAN > $VDJRESULTS/COMBINATION_CLEAN2
sed 's/"//' $VDJRESULTS/COMBINATION_CLEAN2 > $VDJRESULTS/COMBINATION_CLEAN3
sed 's/"//' $VDJRESULTS/COMBINATION_CLEAN3 > $VDJRESULTS/COMBINATION_CLEAN4
sed 's/"//' $VDJRESULTS/COMBINATION_CLEAN4 > $VDJRESULTS/CLEANCOMBINATION


rm $VDJRESULTS/COMBINATION*
#This will save the line number in var
LN="$(wc -l $VDJRESULTS/CLEANCOMBINATION | cut -d " " -f 1)"

#This will output the file names line by line, so we can feed it to R line by line and
#compare always 2 files. R has to be started IN the LOOP

for ((i=1;i<=${LN};i++));
do
  FILE="$(head -n $i "$VDJRESULTS/CLEANCOMBINATION" | tail -n 1 | cut -f 1)";
  #the variable FILE is now one line of the file "CLEANCOMBINATION". Thus it can
  #be used to feed into the Rscript command with ${FILE}
  Rscript $HOME/bin2/Pearson_R1_VDJ_Vgene.R $VDJRESULTS ${FILE};

  #combine files 1,2 and 3 and write another R script to calc. the pearson score.
  cat $VDJRESULTS/1.txt > $VDJRESULTS/PC_FILE1_FILE2;
  cat $VDJRESULTS/2.txt >> $VDJRESULTS/PC_FILE1_FILE2;
  cat $VDJRESULTS/3.txt >> $VDJRESULTS/PC_FILE1_FILE2;
  #Remove every line in which "CDR3.IMGT" occurs, as that is not
  #a sequence but the header that ended up in there wrongly
  sed '/CDR3.IMGT/d' $VDJRESULTS/PC_FILE1_FILE2 > $VDJRESULTS/PC_FILE1_FILE2_CLEAN;

  #For the graph in Pearson_R2.R we need names for the axis, wich should be the file names
  #For this we echo out the names of the files, however need to clean the name as it
  #contains "CDR3_freq_Genesprodfolder_". For this we save the name
  echo ${FILE} > $VDJRESULTS/CLEANnames
  sed -i.bak 's/CDR3_freq_Genesprodfolder_//g' $VDJRESULTS/CLEANnames;
  sed -i.bak 's/.txz_5_AA-sequences.txt//g' $VDJRESULTS/CLEANnames;
  sed -i.bak 's/_5_AA-sequences.txt//g' $VDJRESULTS/CLEANnames;

  #This will be the variable that holds the names for the axis
  XYAXISNAMES=$(head $VDJRESULTS/CLEANnames)
  #this will be the name of the pdf file for the graph and also used as the title of the graph
  sed 's/[[:blank:]]\+/vs/g' $VDJRESULTS/CLEANnames > $VDJRESULTS/CLEANnames2
  PLOTFILENAMES=$(head $VDJRESULTS/CLEANnames2)

  Rscript $HOME/bin2/Pearson_R2.R $VDJRESULTS PC_FILE1_FILE2_CLEAN $XYAXISNAMES $PLOTFILENAMES;

  cp $VDJRESULTS/pearsoncor $PEARSON/pearsoncor;
  filename="$(echo $i)"_PC
  cat $PEARSON/pearsoncor > $PEARSON/$filename;
  mv $VDJRESULTS/plot.pdf $PEARSON/${PLOTFILENAMES}.pdf;


  #It is important these are removed within the loop, otherwise the "cat" command
  #will just append to the already existing file and all values will be wrong
  rm $VDJRESULTS/1.txt;
  rm $VDJRESULTS/2.txt;
  rm $VDJRESULTS/3.txt;
  rm $VDJRESULTS/PC_FILE1_FILE2;
  rm $VDJRESULTS/PC_FILE1_FILE2_CLEAN;
  rm $VDJRESULTS/pearsoncor;
  rm $VDJRESULTS/CLEANnames*
  #remove this if you want to keep the plot/graph
  rm $PEARSON/*.pdf
done

# Put all Pearson Correlation Scores into ONE file
cat $(ls -v $PEARSON/*_PC) > $PEARSON/PC_VALUES
cp $VDJRESULTS/CLEANCOMBINATION $PEARSON
rm $PEARSON/*_PC


#Run Rscript to combine the PC scores and the corresponding filenames
Rscript $HOME/bin2/Pearson_R3_Vgene.R $PEARSON CLEANCOMBINATION PC_VALUES

#Clean up file names inside the file
sed -i.bak 's/CDR3_freq_Genesprodfolder_//' $PEARSON/PearsonCorrelation_Vgene
sed -i.bak 's/CDR3_freq_Genesprodfolder_//' $PEARSON/PearsonCorrelation_Vgene
sed -i.bak 's/CDR3_freq_Genesprodfolder_//' $PEARSON/PearsonCorrelation_Vgene
sed -i.bak 's/CDR3_freq_Genesprodfolder_//' $PEARSON/PearsonCorrelation_Vgene

sed -i.bak 's/.txz_5_AA-sequences.txt//' $PEARSON/PearsonCorrelation_Vgene
sed -i.bak 's/.txz_5_AA-sequences.txt//' $PEARSON/PearsonCorrelation_Vgene

cat $PEARSON/PearsonCorrelation_Vgene > $PEARSON/PearsonScore_Vgene
rm $PEARSON/PearsonC*
rm $VDJRESULTS/COMBINATION*
rm $VDJRESULTS/FILELIST
rm $PEARSON/COMBINATION*
rm $PEARSON/PC_VALUES
rm $PEARSON/pearsoncor
rm -rf $PEARSONCALC
rm $PEARSON/CLEANCOMBINATION
rm $PEARSON/PC_*
rm $PEARSON/pearsoncor
