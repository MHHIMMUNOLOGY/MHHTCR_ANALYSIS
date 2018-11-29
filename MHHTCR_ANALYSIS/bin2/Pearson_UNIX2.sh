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
ls $PEARSONCALC > $IMGTDIR/FILELIST

#This will make every possible combination from each line of FILELIST
join  -12 -22 -o 1.1,2.1 -t '
' $IMGTDIR/FILELIST $IMGTDIR/FILELIST | sed 'N; s/\n/ /' > $IMGTDIR/COMBINATION
cp $IMGTDIR/COMBINATION $PEARSONCALC

#This will remove every line in which the same sample is next to its self (SF117 vs SF117 etc)
#because this stops the Rscript
Rscript $HOME/bin2/Pearson_R1.2.R $PEARSONCALC $IMGTDIR/COMBINATION

#The file comes in a different format out of R with "" that need to be removed:
sed 's/"//' $PEARSONCALC/COMBINATION_CLEAN > $PEARSONCALC/COMBINATION_CLEAN2
sed 's/"//' $PEARSONCALC/COMBINATION_CLEAN2 > $PEARSONCALC/COMBINATION_CLEAN3
sed 's/"//' $PEARSONCALC/COMBINATION_CLEAN3 > $PEARSONCALC/COMBINATION_CLEAN4
sed 's/"//' $PEARSONCALC/COMBINATION_CLEAN4 > $PEARSONCALC/COMBINATION_CLEAN5

cp $PEARSONCALC/COMBINATION_CLEAN5 $IMGTDIR


rm $PEARSONCALC/COMBINATION*
#This will save the line number in var
LN="$(wc -l $IMGTDIR/COMBINATION_CLEAN5 | cut -d " " -f 1)"

#This will output the file names line by line, so we can feed it to R line by line and
#compare always 2 files. R has to be started IN the LOOP

for ((i=1;i<=${LN};i++));
do
  FILE="$(head -n $i "$IMGTDIR/COMBINATION_CLEAN5" | tail -n 1 | cut -f 1)";
  #the variable FILE is now one line of the file "COMBINATION_CLEAN5". Thus it can
  #be used to feed into the Rscript command with ${FILE}
  Rscript $HOME/bin2/Pearson_R1.R $PEARSONCALC ${FILE};

  #combine files 1,2 and 3 and write another R script to calc. the pearson score.
  cat $PEARSONCALC/1.txt > $PEARSONCALC/PC_FILE1_FILE2;
  cat $PEARSONCALC/2.txt >> $PEARSONCALC/PC_FILE1_FILE2;
  cat $PEARSONCALC/3.txt >> $PEARSONCALC/PC_FILE1_FILE2;
  #Remove every line in which "CDR3.IMGT" occurs, as that is not
  #a sequence but the header that ended up in there wrongly
  sed '/CDR3.IMGT/d' $PEARSONCALC/PC_FILE1_FILE2 > $PEARSONCALC/PC_FILE1_FILE2_CLEAN;

  #For the graph in Pearson_R2.R we need names for the axis, wich should be the file names
  #For this we echo out the names of the files, however need to clean the name as it
  #contains "CDR3_freq_Genesprodfolder_". For this we save the name
  echo ${FILE} > $PEARSONCALC/CLEANnames
  sed -i.bak 's/CDR3_freq_Genesprodfolder_//g' $PEARSONCALC/CLEANnames;
  sed -i.bak 's/.txz_5_AA-sequences.txt//g' $PEARSONCALC/CLEANnames;
  sed -i.bak 's/_5_AA-sequences.txt//g' $PEARSONCALC/CLEANnames;

  #This will be the variable that holds the names for the axis
  XYAXISNAMES=$(head $PEARSONCALC/CLEANnames)
  #this will be the name of the pdf file for the graph and also used as the title of the graph
  sed 's/[[:blank:]]\+/vs/g' $PEARSONCALC/CLEANnames > $PEARSONCALC/CLEANnames2
  PLOTFILENAMES=$(head $PEARSONCALC/CLEANnames2)

  Rscript $HOME/bin2/Pearson_R2.R $PEARSONCALC PC_FILE1_FILE2_CLEAN $XYAXISNAMES $PLOTFILENAMES;

  cp $PEARSONCALC/pearsoncor $PEARSON/pearsoncor;
  filename="$(echo $i)"_PC
  cat $PEARSON/pearsoncor > $PEARSON/$filename;
  mv $PEARSONCALC/plot.pdf $PEARSON/${PLOTFILENAMES}.pdf;


  #It is important these are removed within the loop, otherwise the "cat" command
  #will just append to the already existing file and all values will be wrong
  rm $PEARSONCALC/1.txt;
  rm $PEARSONCALC/2.txt;
  rm $PEARSONCALC/3.txt;
  rm $PEARSONCALC/PC_FILE1_FILE2;
  rm $PEARSONCALC/PC_FILE1_FILE2_CLEAN;
  rm $PEARSONCALC/pearsoncor;
  rm $PEARSONCALC/CLEANnames*
  #remove this if you want to keep the plot/graph
  rm $PEARSON/*.pdf
done

# Put all Pearson Correlation Scores into ONE file
cat $(ls -v $PEARSON/*_PC) > $PEARSON/PC_VALUES
cp $IMGTDIR/COMBINATION_CLEAN5 $PEARSON
rm $PEARSON/*_PC


#Run Rscript to combine the PC scores and the corresponding filenames
Rscript $HOME/bin2/Pearson_R3.R $PEARSON COMBINATION_CLEAN5 PC_VALUES

#Clean up file names inside the file
sed -i.bak 's/CDR3_freq_Genesprodfolder_//' $PEARSON/PearsonCorrelation
sed -i.bak 's/CDR3_freq_Genesprodfolder_//' $PEARSON/PearsonCorrelation
sed -i.bak 's/CDR3_freq_Genesprodfolder_//' $PEARSON/PearsonCorrelation
sed -i.bak 's/CDR3_freq_Genesprodfolder_//' $PEARSON/PearsonCorrelation

sed -i.bak 's/.txz_5_AA-sequences.txt//' $PEARSON/PearsonCorrelation
sed -i.bak 's/.txz_5_AA-sequences.txt//' $PEARSON/PearsonCorrelation

cat $PEARSON/PearsonCorrelation > $PEARSON/PearsonScore
rm $PEARSON/PearsonC*
rm $IMGTDIR/COMBINATION*
rm $IMGTDIR/FILELIST
rm $PEARSON/COMBINATION*
rm $PEARSON/PC_VALUES
rm $PEARSON/pearsoncor
rm -rf $PEARSONCALC
