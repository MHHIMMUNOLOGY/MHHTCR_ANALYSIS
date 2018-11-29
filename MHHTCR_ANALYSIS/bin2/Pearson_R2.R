#Pearson Correlation R script 1
library(plyr) #DO NOT LOAD dplyr WITH plyr

#Set Working Directory so input files can be read -> THIS NEEDS TO BE Changed
args <- commandArgs(trailingOnly = TRUE)

# IMPORTANT: Commandline inputs start with number 6 in R, meaning if we start the bashscript
# with 'script.sh input1 input2', input1 will be 6 and input2 will be 7 in the R script
print(args[1])
print(args[2])
print(args[3])
print(args[4])


setwd(args[1])

#Assign the file names
FILENAME1 <- args[2] #This should be PC_FILE1_FILE2_CLEAN
FILENAME2 <- args[3] #This should be the first sample
FILENAME3 <- args[4] # This should be the second sample
FILENAME4 <- args[5] # This should be the title of the pdf

#read table of appended file back in to R
PC_FILE1_FILE2 <- read.delim(FILENAME1, sep="\t", header = FALSE)


#calculate sums for each sample to use for freq. calculation
V2 <- sum(PC_FILE1_FILE2$V2)
V3 <- sum(PC_FILE1_FILE2$V3)

#calculate frequencies and add in as a new column
PC_FILE1_FILE2$V4 <- (100/V2)*PC_FILE1_FILE2$V2
PC_FILE1_FILE2$V5 <- (100/V3)*PC_FILE1_FILE2$V3

#calculate the Pearson Correlation
pearsoncor <- cor(PC_FILE1_FILE2$V4, PC_FILE1_FILE2$V5, method = c("pearson"))

#This will put the contents of FILENAME2 in between quotes ""
#FILENAME2 = paste("\"",FILENAME2,"\"",sep="")
#FILENAME3 = paste("\"",FILENAME3,"\"",sep="")

V4 <- as.data.frame(PC_FILE1_FILE2$V4)
colnames(V4)[which(names(V4) == "PC_FILE1_FILE2$V4")] <- FILENAME2

V5 <- as.data.frame(PC_FILE1_FILE2$V5)
colnames(V5)[which(names(V5) == "PC_FILE1_FILE2$V5")] <- FILENAME3

V45 <- cbind(V4, V5)

#use this to paste the TITLE of the graph, with the word "pearson"
#and the calculated pearson score
TITLE = paste(FILENAME4, "Pearson", pearsoncor, sep=" ")

library(ggplot2)
#Create the PLOT. All "theme()" commands are for the layout of the graph.
dp <- ggplot(V45, aes_string(x = colnames(V45)[1], y = colnames(V45)[2])) +
  geom_point(size=4) +
  ggtitle(TITLE) +
  theme(plot.title = element_text(color="black",
                                  face="bold", size = 32, hjust=0)) +
  theme(plot.background= element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())+
  theme(panel.background = element_blank())+
  theme(axis.line.x = element_line(color="black", size = 1),
        axis.line.y  = element_line(color="black", size = 1))+
  theme(axis.ticks  = element_line(color="black", size = 1))+
  theme(axis.ticks.length = unit(0.3,"cm"))+
  theme(axis.title = element_text(color="black", size=17, face="bold"))+
  theme(axis.text.x = element_text(color="black",size=14, face="bold"),
        axis.text.y = element_text(color="black",size=14, face="bold"))+
  scale_x_log10(breaks=c(.01, .1, 1, 10), limits = c(0.01, 10))+
  scale_y_log10(breaks=c(.01, .1, 1, 10),limits = c(0.01,  10))+
  geom_smooth(method=lm)

# dp <- ggplot(V45, aes_string(x = colnames(V45)[1], y = colnames(V45)[2])) +
#   geom_point(size=4) +
#   ggtitle(FILENAME4) +
#   theme(plot.title = element_text(family="Trebuchet MS", color="#666666", face="bold", size = 32, hjust=0)) +
#   scale_x_continuous(trans='log10') +
#   scale_y_continuous(trans='log10') +
#   geom_smooth(method=lm)



write.table(pearsoncor, "pearsoncor", sep="\t", col.names=FALSE, row.names=FALSE)
ggsave("plot.pdf", dp, useDingbats=FALSE, width=20, height=20)
