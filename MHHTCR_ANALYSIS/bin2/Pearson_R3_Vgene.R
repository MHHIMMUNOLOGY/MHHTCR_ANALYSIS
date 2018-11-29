#R script to bind together the pearson Correlation scores
library(plyr) #DO NOT LOAD dplyr WITH plyr

#Set Working Directory so input files can be read -> THIS NEEDS TO BE Changed
args <- commandArgs(trailingOnly = TRUE)

print(args[1])
print(args[2])
print(args[3])

setwd(args[1])

#Assign the file names
FILENAME1 <- args[2]
FILENAME2 <- args[3]

FILE1 <- read.table(FILENAME1)
FILE2 <- read.table(FILENAME2)

FILE1_2 <- cbind(FILE1, FILE2)

write.table(FILE1_2, "PearsonCorrelation_Vgene", sep="\t", col.names=FALSE, row.names=FALSE)
