#R Script to determine total Numbers
library(plyr) #DO NOT LOAD dplyr WITH plyr

#Set Working Directory so input files can be read -> THIS NEEDS TO BE Changed
args <- commandArgs(trailingOnly = TRUE)

# IMPORTANT: Commandline inputs start with number 6 in R, meaning if we start the bashscript
# with 'script.sh input1 input2', input1 will be 6 and input2 will be 7 in the R script
print(args[1])
print(args[2])


setwd(args[1])

#Assign the file names
FILENAME1 <- args[2]
FILENAME2 <- args[3]

#Read Productive and Unproductive file list with Sequence Numbers
Productive <- read.delim(FILENAME1, sep=" ", header = FALSE)
UNproductive <- read.delim(FILENAME2, sep=" ", header = FALSE)

#Remove the sample names from one of the lists so it can be added to the next one
#without having 2 columns full of sample names
UNproductive$V2 <- NULL
#put all samplenames and numbers into one data.frame
Summary <- cbind(Productive, UNproductive)
#swap the column order so the names are on the left and numbers on the right
Summary <- Summary[,c(2,3,1)]

#change the column names
colnames(Summary)[which(names(Summary) == "V2")] <- "Sample"
colnames(Summary)[which(names(Summary) == "V1.1")] <- "Productive"
colnames(Summary)[which(names(Summary) == "V1")] <- "Unproductive"

#calculate some totals and percentages and add them as new columns
Summary$Total <- Summary$Productive+Summary$Unproductive
Summary$PercentUNProductive <- (100/Summary$Total)*Summary$Unproductive
Summary$PercentProductive <- (100/Summary$Total)*Summary$Productive

#save it as a file
write.table(Summary, "Numbers.txt", sep="\t", col.names=TRUE, row.names=FALSE)
