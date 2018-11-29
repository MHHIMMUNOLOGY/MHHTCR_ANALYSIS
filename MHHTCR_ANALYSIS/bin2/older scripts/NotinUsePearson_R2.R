#Pearson Correlation R script 1
library(plyr) #DO NOT LOAD dplyr WITH plyr

#Set Working Directory so input files can be read -> THIS NEEDS TO BE Changed
args <- commandArgs(trailingOnly = TRUE)

# IMPORTANT: Commandline inputs start with number 6 in R, meaning if we start the bashscript
# with 'script.sh input1 input2', input1 will be 6 and input2 will be 7 in the R script
print(args[1])
print(args[2])
print(args[3])

setwd(args[1])

#Assign the file names
FILENAME1 <- args[2]
FILENAME2 <- args[3]
FILENAME3 <- args[3]

#Read files into R

DIFF_FILE1_FILE2 <- read.delim(FILENAME1, sep="\t", header = FALSE)
DIFF_FILE2_FILE1 <- read.delim(FILENAME2, sep="\t", header = FALSE)
OVERLAP <- read.delim(FILENAME3, sep="\t", header = FALSE)

DIFF_FILE1_FILE2$Freq2 <- 0
DIFF_FILE2_FILE1$Freq2 <- 0

DIFF_FILE2_FILE1 <- DIFF_FILE2_FILE1[,c(1,3,2)]

write.table(DIFF_FILE1_FILE2, "1.txt", sep="\t", col.names=FALSE, row.names=FALSE)
write.table(DIFF_FILE2_FILE1, "2.txt", sep="\t", col.names=FALSE, row.names=FALSE)
write.table(OVERLAP, "3.txt", sep="\t", col.names=FALSE, row.names=FALSE)
