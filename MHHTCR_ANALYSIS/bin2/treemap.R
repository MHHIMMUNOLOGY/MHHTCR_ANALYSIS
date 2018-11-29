library(tcR)
library(treemap)

setwd("~/sequencing/TEST/IMGT/VDJRESULTS")

#Read in the VDJTOOLS files using tcRs command
FILE1 <- parse.vdjtools("DOWNSAMPLE_.VDJTOOLS_.Treg_001.fastq_MIXCR_IMGT.txt")
FILE2 <- parse.vdjtools("DOWNSAMPLE_.VDJTOOLS_.Treg_001.fastq_MIXCR_IMGT.txt")
FILE3 <- parse.vdjtools("DOWNSAMPLE_.VDJTOOLS_.Treg_001G.fastq_MIXCR_IMGT.txt")

#Create a data.frame out of the columns you want to create a treemap from. You need FREQUENCY and CDR3 amino acid Region (Or V region or what ever other region)
FILE1_DF <- data.frame(FILE1$Read.proportion, FILE1$CDR3.amino.acid.sequence)
FILE2_DF <- data.frame(FILE2$Read.proportion, FILE2$CDR3.amino.acid.sequence)
FILE3_DF <- data.frame(FILE3$Read.proportion, FILE3$CDR3.amino.acid.sequence)

#Next you can create a treemap using the treemap package. Index variable is the column with the name you want to use for each rectangle. In our case it is the CDR3
#sequence. VSIZE is the variable that will determine how big the rectangles will be. This is our CDR3 frequency. This takes a long time to generate if you have
#many sequences, so just wait.

FILE1_TREEMAP <- treemap(FILE1_DF, index = "FILE1.CDR3.amino.acid.sequence", vSize = "FILE1.Read.proportion")
FILE2_TREEMAP <- treemap(FILE2_DF, index = "FILE2.CDR3.amino.acid.sequence", vSize = "FILE2.Read.proportion")
FILE3_TREEMAP <- treemap(FILE3_DF, index = "FILE3.CDR3.amino.acid.sequence", vSize = "FILE3.Read.proportion")

#To change color etc of the treemaps please see the manual here:

?treemap

#You can see the many options that you can play around with. 
#In the manual "dtf" just stands for dataframe and is "FILEX_DF" in our case. 