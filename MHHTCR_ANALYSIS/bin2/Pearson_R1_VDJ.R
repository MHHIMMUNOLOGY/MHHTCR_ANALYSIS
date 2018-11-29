#Pearson Correlation R script 1
library(plyr) #DO NOT LOAD dplyr WITH plyr
library(tcR)

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
FILE1 <- parse.vdjtools(FILENAME1)
FILE2 <- parse.vdjtools(FILENAME2)

#Swap the order of columns so the count is on the right side
FILE1 <- FILE1[,c(3,6)]
FILE2 <- FILE2[,c(3,6)]

#change column names to easier names
colnames(FILE1)[which(names(FILE1) == "CDR3.amino.acid.sequence")] <- "V2"
colnames(FILE1)[which(names(FILE1) == "Read.count")] <- "V1"
colnames(FILE2)[which(names(FILE2) == "CDR3.amino.acid.sequence")] <- "V2"
colnames(FILE2)[which(names(FILE2) == "Read.count")] <- "V1"

# This will put all overlapping sequences into OVERLAP, the count is V1.x= FILE1, V1.y= FILE2
OVERLAP <- merge(FILE1, FILE2, by="V2")

# This will extract only the sequence without count, so they can be used to extract only
# those sequences found in one dataset but not the other
FILE1V2 <- as.data.frame(FILE1$V2)
FILE2V2 <- as.data.frame(FILE2$V2)

#This will create a function that can be used to extract only those sequences
# found in one data frame but not the other
rows.in.a1.that.are.not.in.a2  <- function(x,y)
{
  a1.vec <- apply(x, 1, paste, collapse = "")
  a2.vec <- apply(y, 1, paste, collapse = "")
  a1.without.a2.rows <- x[!a1.vec %in% a2.vec,]
  return(a1.without.a2.rows)
}

# uses the function above
DIFF_FILE1_FILE2 <- as.data.frame(rows.in.a1.that.are.not.in.a2(FILE1V2, FILE2V2))
DIFF_FILE2_FILE1 <- as.data.frame(rows.in.a1.that.are.not.in.a2(FILE2V2, FILE1V2))

#Changes the column name to "V2" so that it can be compared to FILE1
colnames(DIFF_FILE1_FILE2)[which(names(DIFF_FILE1_FILE2) == "rows.in.a1.that.are.not.in.a2(FILE1V2, FILE2V2)")] <- "V2"
colnames(DIFF_FILE2_FILE1)[which(names(DIFF_FILE2_FILE1) == "rows.in.a1.that.are.not.in.a2(FILE2V2, FILE1V2)")] <- "V2"

# Adds a row with zeros so it can be compared to the FILE1
DIFF_FILE1_FILE2$Freq2 <- 0
DIFF_FILE2_FILE1$Freq2 <- 0

# Merges the DIFF_* with FILE1 or FILE2 (respectivly) so that
# that frequency information that was removed can be added again
DIFF_FILE1_FILE2 <- merge(DIFF_FILE1_FILE2, FILE1, by="V2")
DIFF_FILE2_FILE1 <- merge(DIFF_FILE2_FILE1, FILE2, by="V2")

# Swap columns for the first file, so that now all columns correspond and
# can be added to one another using "cat" in unix
DIFF_FILE1_FILE2 <- DIFF_FILE1_FILE2[,c(1,3,2)]

#Saves all files for further use with unix
write.table(DIFF_FILE1_FILE2, "1.txt", sep="\t", col.names=FALSE, row.names=FALSE)
write.table(DIFF_FILE2_FILE1, "2.txt", sep="\t", col.names=FALSE, row.names=FALSE)
write.table(OVERLAP, "3.txt", sep="\t", col.names=FALSE, row.names=FALSE)
