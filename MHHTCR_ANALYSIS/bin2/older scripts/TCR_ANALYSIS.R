# Make a mix of Shell and R script

############### Assign Variables #########################

#Working Directory
WD=$1

# Files that are from one experiment (i.e Input, D4, D14, D21)
FILE1=$2
FILE2=$3
FILE3=$4
FILE4=$5
FILE5=$6

FILENAME1 = basename(FILE1)
FILENAME2 = basename(FILE2)
FILENAME3 = basename(FILE3)
FILENAME4 = basename(FILE4)
FILENAME5 = basename(FILE5)


#Start R

R
# TCR Analysis using VDJ Tools input in tcR Package in R
#load all libraries
library(tcR)

#Set Working Directory so input files can be read -> THIS NEEDS TO BE Changed
setwd(Sys.getenv("1"))

# Write output filenames
output <- paste(prefix = "cloneset-stats_", file, sep="")

# Read files
FILE1 <- parse.vdjtools(Sys.getenv("2"))
FILE2 <- parse.vdjtools(Sys.getenv("3"))
FILE3 <- parse.vdjtools(Sys.getenv("4"))
FILE4 <- parse.vdjtools(Sys.getenv("5"))
FILE5 <- parse.vdjtools(Sys.getenv("6"))

# Make a list of all files that come from one experiment
Experiment <- list(FILENAME1 = FILE1, FILENAME2 = FILE2, FILENAME3 = FILE3, FILENAME4 = FILE4, FILENAME5 = FILE5)

# Make a file with information about clonesets of all samples
cloneset_stats <- cloneset.stats(Experiment)

write.table(cloneset_stats, output)
