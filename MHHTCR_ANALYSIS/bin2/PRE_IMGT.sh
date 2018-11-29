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

# Folder for fastq files
QDIR=$SEQDIR/fastq

# Folder for FASTA files
FASTADIR=$SEQDIR/FASTA

# Folder with Joined FASTA files
JDIR=$SEQDIR/JOINED

# Folder with pairing software tool pear
PEAR=$HOME/PEAR/pear

############## Prepare all MiSeq FASTQ files for IMGT Upload ##############

# Extract all .gz files

for GUNZIPFILE in $SEQDIR/*.gz;
do
  gunzip -d $GUNZIPFILE
done

# If there is no directory named X, then make it. If there is, don't do anything
if [ ! -d $QDIR ]; then mkdir -p $QDIR; fi;

# If there is no directory named X, then make it. If there is, don't do anything
if [ ! -d $FASTADIR ]; then mkdir -p $FASTADIR; fi;

# Take files out of the individual fastq-folders and moves them into the directory 'fastq'
mv $SEQDIR/*.fastq $QDIR
rmdir $QDIR/.itmsp
