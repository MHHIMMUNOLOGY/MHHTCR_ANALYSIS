

#ggplot2 has problems installing because of dependencies. So for this I had to install all manually
#First it was scales. When I wanted to install scales, that had issues too. So instead I installed those first:
install.packages("Rcpp")
install.packages("colorspace")
#Then scales

install.packages("scales")
#Then everything ggplot2 was asking for

install.packages("lazyeval")
install.packages("plyr")
install.packages("rlang")
install.packages("tibble")
#Then ggplot2
install.packages("ggplot2")

#Then all the packages VDJtools needs
install.packages("ape")
install.packages("circlize")
install.packages("FField")
install.packages("ggplot2")
install.packages("ggplot")
install.packages("grid")
install.packages("gridExtra")
install.packages("MASS")
install.packages("plotrix")
install.packages("RColorBrewer")
install.packages("reshape")
install.packages("reshape2")
install.packages("scales")
install.packages("VennDiagram")
install.packages("tcR")