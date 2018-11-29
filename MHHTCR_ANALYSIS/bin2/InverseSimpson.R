# TCR Analysis using VDJ Tools input in tcR Package in R
#load all libraries
library(tcR)

#Set Working Directory so input files can be read -> THIS NEEDS TO BE Changed
args <- commandArgs(trailingOnly = FALSE)
# IMPORTANT: Commandline inputs start with number 6 in R, meaning if we start the bashscript
# with 'script.sh input1 input2', input1 will be 6 and input2 will be 7 in the R script
print(args[6])
print(args[7])
print(args[8])
print(args[9])
print(args[10])
print(args[11])
print(args[12])
print(args[13])
print(args[14])
print(args[15])
print(args[16])
print(args[17])
print(args[18])
print(args[19])
print(args[20])
print(args[21])
print(args[22])
print(args[23])
print(args[24])
print(args[25])
print(args[26])
print(args[27])
print(args[28])
print(args[29])
print(args[30])
print(args[31])
print(args[32])
print(args[33])
print(args[34])
print(args[35])

setwd(args[6])

#getwd()

FILENAME1 <- args[7]
FILENAME2 <- args[8]
FILENAME3 <- args[9]
FILENAME4 <- args[10]
FILENAME5 <- args[11]
FILENAME6 <- args[12]
FILENAME7 <- args[13]
FILENAME8 <- args[14]
FILENAME9 <- args[15]
FILENAME10 <- args[16]
FILENAME11 <- args[17]
FILENAME12 <- args[18]
FILENAME13 <- args[19]
FILENAME14 <- args[20]
FILENAME15 <- args[21]
FILENAME16 <- args[22]
FILENAME17 <- args[23]
FILENAME18 <- args[24]
FILENAME19 <- args[25]
FILENAME20 <- args[26]
FILENAME21 <- args[27]
FILENAME22 <- args[28]
FILENAME23 <- args[29]
FILENAME24 <- args[30]
FILENAME25 <- args[31]
FILENAME26 <- args[32]
FILENAME27 <- args[33]
FILENAME28 <- args[34]


#Do Dialog Boxes that ask for Input for later

#SampleNumber <-readline("How many samples do you have?")
# Write output filenames
#output <- paste(prefix = "cloneset-stats_", args[8], sep="")

# Read files #What to change before each run: Line 42 and line 48 (everyhwere the FILE variable is used)
FILE1 <- parse.vdjtools(FILENAME1)
FILE2 <- parse.vdjtools(FILENAME2)
FILE3 <- parse.vdjtools(FILENAME3)
FILE4 <- parse.vdjtools(FILENAME4)
FILE5 <- parse.vdjtools(FILENAME5)
FILE6 <- parse.vdjtools(FILENAME6)
FILE7 <- parse.vdjtools(FILENAME7)
 FILE8 <- parse.vdjtools(FILENAME8)
 #FILE9 <- parse.vdjtools(FILENAME9)
 #FILE10 <- parse.vdjtools(FILENAME10)
# FILE11 <- parse.vdjtools(FILENAME11)
# FILE12 <- parse.vdjtools(FILENAME12)
# FILE4 <- parse.vdjtools(FILENAME13)
# FILE5 <- parse.vdjtools(FILENAME14)
# FILE6 <- parse.vdjtools(FILENAME15)
# FILE7 <- parse.vdjtools(FILENAME16)
# FILE8 <- parse.vdjtools(FILENAME17)
# FILE9 <- parse.vdjtools(FILENAME18)
# FILE10 <- parse.vdjtools(FILENAME19)
# FILE11 <- parse.vdjtools(FILENAME20)
# FILE12 <- parse.vdjtools(FILENAME21)
# FILE22 <- parse.vdjtools(FILENAME22)
# FILE23 <- parse.vdjtools(FILENAME23)
# FILE24 <- parse.vdjtools(FILENAME24)
# FILE25 <- parse.vdjtools(FILENAME25)
# FILE26 <- parse.vdjtools(FILENAME26)
# FILE27 <- parse.vdjtools(FILENAME27)
# FILE28 <- parse.vdjtools(FILENAME28)

# Make a list of all files that come from one experiment
Experiment <- list("1530_439__"=FILE1, "1534_173_"=FILE2,"1537_gamma_" =FILE3, "1538_"=FILE4, "1540_gamma"=FILE5, "1553_gamma"=FILE6,
"1563_gamma"=FILE7, "1564_gamma_"=FILE8)


############ Diversity Index Analysis ############
repDiversity(Experiment, 'inv.simp', 'read.prop')
InvSimpson <- as.data.frame(sapply(Experiment, function (x) inverse.simpson(x$Read.proportion)))
colnames(InvSimpson)[1] <- "Inverse Simpson Index"
write.table(InvSimpson, "tcR_div_InvSimpson.txt", sep="\t", col.names=TRUE, row.names=TRUE)
