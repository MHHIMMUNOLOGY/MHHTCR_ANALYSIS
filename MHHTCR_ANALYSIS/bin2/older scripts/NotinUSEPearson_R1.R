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

#Read files into R
FILE1 <- read.delim(FILENAME1)
FILE2 <- read.delim(FILENAME2)

#Cut the CDR3 column
FILE1_CDR3 <- FILE1[15]
FILE2_CDR3 <- FILE2[15]

#Count duplicates (function from plyr package)
FILE1_COUNT <- count(FILE1_CDR3)
FILE2_COUNT <- count(FILE2_CDR3)

#merge 2 datasets to get overlap
OVERLAP <- merge(FILE1_COUNT, FILE2_COUNT, by="CDR3.IMGT")

#write function that compares 2 data sets and prints only the ones that are found in one data set
#that DO NOT overlap
rows.in.a1.that.are.not.in.a2  <- function(x,y)
{
  a1.vec <- apply(x, 1, paste, collapse = "")
  a2.vec <- apply(y, 1, paste, collapse = "")
  a1.without.a2.rows <- x[!a1.vec %in% a2.vec,]
  return(a1.without.a2.rows)
}

#Use the function just written
DIFF_FILE1_FILE2 <- count(rows.in.a1.that.are.not.in.a2(FILE1_CDR3, FILE2_CDR3))
DIFF_FILE2_FILE1 <- count(rows.in.a1.that.are.not.in.a2(FILE2_CDR3, FILE1_CDR3))

#Add a second column filled with zeros to each sample
DIFF_FILE1_FILE2$Freq2 <- 0
DIFF_FILE2_FILE1$Freq2 <- 0

#Change order of column for one sample, so that it corresponds when appending
DIFF_FILE2_FILE1 <- DIFF_FILE2_FILE1[,c(1,3,2)]

#write files to append using unix code
write.table(DIFF_FILE1_FILE2, "1.txt", sep="\t", col.names=FALSE, row.names=FALSE)
write.table(DIFF_FILE2_FILE1, "2.txt", sep="\t", col.names=FALSE, row.names=FALSE)
write.table(OVERLAP, "3.txt", sep="\t", col.names=FALSE, row.names=FALSE)

#Now use another UNIX script to combine all the files, and then another R script
#to continue calculating the Pearson Correlation
