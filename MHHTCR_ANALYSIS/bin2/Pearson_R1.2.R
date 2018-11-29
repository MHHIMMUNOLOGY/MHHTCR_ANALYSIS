# R script to remove all lines of the file "COMBINATION" that are identical in column 1 and 2
# This is required to run the script, as the pearson Correlation is not calc. when it
# calculates identical files

library(plyr) #DO NOT LOAD dplyr WITH plyr

#Set Working Directory so input files can be read -> THIS NEEDS TO BE Changed
args <- commandArgs(trailingOnly = TRUE)

print(args[1])
print(args[2])

setwd(args[1])

#Assign the file names
FILENAME1 <- args[2]

#read table of appended file back in to R
COMBINATION <- read.table(FILENAME1)

COMBINATION <- COMBINATION[COMBINATION$V1 != COMBINATION$V2,]

write.table(COMBINATION, "COMBINATION_CLEAN", sep=" ", col.names=FALSE, row.names=FALSE)
