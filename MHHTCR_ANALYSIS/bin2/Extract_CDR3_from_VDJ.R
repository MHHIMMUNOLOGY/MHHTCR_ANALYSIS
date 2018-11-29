#R script to get the CDR3 information
library(tcR)

#Set Working Directory so input files can be read -> THIS NEEDS TO BE Changed
args <- commandArgs(trailingOnly = TRUE)

print(args[1])
print(args[2])

setwd(args[1])

FILENAME1 <- args[2]

FILE1 <- parse.vdjtools(FILENAME1)

FILE1_CDR3 <- FILE1[,c(3,6)]

write.table(FILE1_CDR3, "tcR_CDR3_info", sep="\t", col.names=TRUE, row.names=FALSE)
