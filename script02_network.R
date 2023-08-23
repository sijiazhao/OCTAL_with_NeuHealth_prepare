# install.packages(tidyverse)
library(tidyverse)
library(corrplot)
library(corrr)

windowsFonts(Times=windowsFont("corbel"))
# Set the path to the correct directory:
# setwd("E:/GitHub/Masud_OxfordCognition/Project03_Plasma_AD/OxCog_analysis_Plasma")

# library("parallel") # parallel computing
# library("coda")

# Read data:
d <- 
  read.csv(file = "E:/GitHub/Masud_OxfordCognition/OCTAL_with_NeuHealth_prepare/OCTAL_with_NeuHealth.csv")

d1 <- d[c("age","ace","OIS_DelayedObjectAccuracy","OIS_DelayedLocationError",
          "OMT_ProportionCorrect","OMT_AbsoluteError",
          "TMT_A","TMT_B","DSST_nCorrectResponse")]
x <- correlate(d1, use="complete.obs")
network_plot(x, min_cor=.1, curved=FALSE,colors = c("purple", "green"))
# network_plot(x, min_cor=.3, curved=FALSE,legend="range")

# d1 <- d[c("OIS_ImmediateObjectAccuracy","OIS_ImmediateLocationError","OIS_DelayedObjectAccuracy","OIS_DelayedLocationError",
#           "OMT_ProportionCorrect","OMT_AbsoluteError",
#           "REY_recall_score","REY_copy_score","CORSI_mean",
#           "TMT_A","TMT_B","DSST_nCorrectResponse",
#           "age","education","AMI_total","GDS_total")]
# x <- correlate(d1, use="pairwise.complete.obs")
# network_plot(x, min_cor=.3, curved=FALSE)

# corrplot(cor(d1, method = "spearman", use = "complete.obs"), method = "circle", type = "lower", bg="grey", sig.level = 0.05)


