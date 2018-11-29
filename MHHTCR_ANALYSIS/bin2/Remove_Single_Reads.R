library(data.table)
args <- commandArgs(trailingOnly = FALSE)

print(args[6])
print(args[7])

setwd(args[6])

FILE <- args[7]
#FILE <- "3_Nt-sequences.txt"
ALL <- read.delim(FILE,sep="\t", header = TRUE)

#Take everyline that includes "Productive" in the column "V.DOMAIN.Funtioniality"
PROD <- ALL[grepl("productive", ALL$Functionality),]
#Because unproductive includes "productive" in its name we have to now remove the "unproductive" sequences
PROD <- PROD[!grepl("unproductive", PROD$Functionality),]

#Extract all lines that include sequences that occur more than once.
DUP <- PROD[duplicated(PROD$CDR3.IMGT), ]
#This code would remove all duplicates and keep only unique reads:
UNIQ <- PROD[unique(PROD$CDR3.IMGT), ]

#This is to create a list with the numbers of Duplicate and Single reads
DUPLICATE_READS <- nrow(DUP)
SINGLE_READS <- nrow(UNIQ)
SAMPLE_NAME <- FILE
Summary <- cbind(SAMPLE_NAME, DUPLICATE_READS, SINGLE_READS)



#IMPORTANT: when writing for VDJ, "quote" has to be set on FALSE. Otherwise each column name will have quotation marks and will not be read by VDJ.
write.table(DUP, "DUP.txt", sep="\t", quote=FALSE, col.names=TRUE, row.names=FALSE)
write.table(Summary, "Numbers.txt", sep="\t", quote=FALSE, col.names=TRUE, row.names=FALSE)

