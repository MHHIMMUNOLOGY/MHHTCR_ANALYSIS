#Shannon Index Analysis Using Vegan

library(vegan)

args <- commandArgs(trailingOnly = TRUE)

print(args[1])
setwd(args[1])

fileNames<- Sys.glob("SHANNON*.txt")
for (fileName in fileNames) {
sample <-read.table(fileName, head=F, sep=" ")
sample.trans<-t(sample)
sh<-diversity(sample.trans)
write.table(sh, file=fileName)
sh2 <- read.table(fileName)
row.names(sh2) <-fileName
write.table(sh2, file=fileName)
}
