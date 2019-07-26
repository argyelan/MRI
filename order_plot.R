FDRandComp <- function()
{
#**************************************#
# Script to reorder the data and plot its correlation with the first 30 sets #
#**************************************#
library(ggplot2)

setwd("/nethome/rkim/Script/")

source("FD_calc.R")
source("data_creation.R") #Only run if you dont have the csv files created, otherwise run only lower half of "Pairwise_correlation.R"

ord <- order(FD) #Take the ascending order of FD and apply it to the data file
dataFD <- dataFile[ord]
randOrd <- sample(ord) #Apply a random order to the data file
dataRand <- dataFile[randOrd]

tempCorr <- cor(dataFD)
tempCorr <- tempCorr[upper.tri(tempCorr)]
newFD <- matrix(0, nrow = NROW(tempCorr), ncol = (NROW(dataFile) - 99)) #2 matrices to hold the 495 correlations to be created
newRand <- matrix(0, nrow = NROW(tempCorr), ncol = (NROW(dataFile) - 99))
FDwindow <- 100
for (i in c(1:(nrow(dataFD) - FDwindow + 1))) #Create 495 pairwise correlations of the data sets with windows of 100 time steps
{
  FD_corr <- cor(dataFD[c(i:(i + FDwindow - 1))]) #Find the pairwise correlation of data
  Rand_corr <- cor(dataRand[c(i:(i + FDwindow - 1))])
  FDPair <- FD_corr[upper.tri(FD_corr)]
  RandPair <- Rand_corr[upper.tri(Rand_corr)]
  newFD[,i] <- FDPair
  newRand[,i] <- RandPair
}

FDavg30 <- matrix(rowMeans(newFD[, 1:30])) #Take the average of the first 30 correlations
Rand_avg30 <- matrix(rowMeans(newRand[, 1:30]))

FDplotCorr <- matrix(0, nrow = (ncol(newFD) - 30), ncol = 1)
RandplotCorr <- matrix(0, nrow = (ncol(newRand) - 30), ncol = 1)
for (i in 31:ncol(newFD))     #Calculate pairwise correlations between the average of the first 30 and the next correlation of the data
{
  temp <- cbind(FDavg30, newFD[,i])
  compareAvg <- cor(temp)
  compareAvg <- compareAvg[upper.tri(compareAvg)]
  FDplotCorr[i - 30,1] <- compareAvg
  temp <- cbind(Rand_avg30, newRand[,i])
  compareAvg <- cor(temp)
  compareAvg <- compareAvg[upper.tri(compareAvg)]
  RandplotCorr[i - 30,1] <- compareAvg
}
FDplotCorr <- data.frame(FDplotCorr)
RandplotCorr <- data.frame(RandplotCorr)

timeSteps <- c(1:nrow(FDplotCorr))  
ggplot() +                          #Plot the Data
  geom_line(data = FDplotCorr, aes(x = timeSteps, y = FDplotCorr, color = "FD Order")) +
  geom_line(data = RandplotCorr, aes(x= timeSteps, y = RandplotCorr, color = "Random Order")) +
  xlab('Time Steps') +
  ylab('Pairwise Correlation') +
  labs(color = "Data Sets")
}

