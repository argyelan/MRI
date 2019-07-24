setwd("/nethome/rkim/Script/")

source("MRI_script.R")
source("Pairwise_correlation.R") #Only run if you dont have the csv files created, otherwise run only lower half of "Pairwise_correlation.R"

ord <- order(FD)
dataFD <- dataFile[ord]
randOrd <- sample(ord)
dataRand <- dataFile[randOrd]

tempCorr <- cor(dataFD)
tempCorr <- tempCorr[upper.tri(tempCorr)]
newFD <- matrix(0, nrow = NROW(tempCorr), ncol = (NROW(dataFile) - 99))
newRand <- matrix(0, nrow = NROW(tempCorr), ncol = (NROW(dataFile) - 99))
FDwindow <- 100
for (i in c(1:(nrow(dataFD) - FDwindow + 1)))
{
  FD_corr <- cor(dataFD[c(i:(i + FDwindow - 1))]) #Find the pairwise correlation of data
  Rand_corr <- cor(dataRand[c(i:(i + FDwindow - 1))])
  FDPair <- FD_corr[upper.tri(FD_corr)]
  RandPair <- Rand_corr[upper.tri(Rand_corr)]
  newFD[,i] <- FDPair
  newRand[,i] <- RandPair
}

FDavg30 <- matrix(rowMeans(newFD[, 1:30]))
Rand_avg30 <- matrix(rowMeans(newRand[, 1:30]))

FDplotCorr <- matrix(0, nrow = (ncol(newFD) - 30), ncol = 1)
RandplotCorr <- matrix(0, nrow = (ncol(newRand) - 30), ncol = 1)
for (i in 31:ncol(newFD))
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

frames <- c(1:nrow(FDplotCorr))
plot(frames, FDplotCorr, type = "n", xlab = "Frames", ylab = "FD (mm)")
lines(frames, FDplotCorr, col = "red")
lines(frames, RandplotCorr, col = "blue")
