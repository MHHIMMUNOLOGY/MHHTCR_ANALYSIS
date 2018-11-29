#R script to get the number of overlapping clones
library(tcR)

#Set Working Directory so input files can be read
args <- commandArgs(trailingOnly = TRUE)

print(args[1])
print(args[2])
print(args[3])
print(args[4])

setwd(args[1])

FILENAME1 <- args[2]
FILENAME2 <- args[3]

FILE1 <- parse.vdjtools(FILENAME1)
FILE2 <- parse.vdjtools(FILENAME2)

#Make a function that will extract all rows with frequency >= 0.001
CUTOFF <- function(x){x[apply(x[2],1,function(row) {all(row >= 0.001)}),]}

FILE1_CUTOFF <- CUTOFF(FILE1)
FILE2_CUTOFF <- CUTOFF(FILE2)
# Make a list of all files that come from one experiment
Experiment <- list("1Input001" = FILE1_CUTOFF,"2InputALL" = FILE1, "3preDLI001" = FILE2_CUTOFF)
shared_clonotypes <- repOverlap(Experiment, 'exact', .norm = F, .verbose = F)

totalInputandcutpreDLI <- nrow(FILE1)+nrow(FILE2_CUTOFF)
cutInputandcutpreDLI <- nrow(FILE1_CUTOFF)+nrow(FILE2_CUTOFF)

percentfromCUTInput <- (shared_clonotypes[3,1]/cutInputandcutpreDLI)*100
percentfromTOTALInput <- (shared_clonotypes[3,2]/totalInputandcutpreDLI)*100

#Number of clonotypes in the 0.1%
NoOfClonotypesInCutInput <- nrow(FILE1_CUTOFF)
NoOfClonotypesInCutPreDLI <- nrow(FILE2_CUTOFF)

shared_clonotypes <- cbind(shared_clonotypes, totalInputandcutpreDLI, cutInputandcutpreDLI, percentfromTOTALInput, percentfromCUTInput, NoOfClonotypesInCutInput, NoOfClonotypesInCutPreDLI)

shared_clonotypes <- shared_clonotypes[-3,-c(1,2)]
shared_clonotypes[1,2] <- NA
shared_clonotypes[1,4] <- NA
shared_clonotypes[2,3] <- NA
shared_clonotypes[2,5] <- NA

write.table(shared_clonotypes, "FilterOverlap_NEW.txt")
