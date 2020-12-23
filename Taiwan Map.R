rm(list = ls())
#資料夾位置
setwd("D:/資料分析彙整/Project/2016 Taiwan Map")

install.packages("sp") 
install.packages("RColorBrewer") 
library(sp)
library(RColorBrewer)

#下載 Rtwmap 套件
install.packages("devtools")
library(devtools)
install_github("wush978/Rtwmap")
#library(Rtwmap)
#可使用RStudio執行

library(Rtwmap)
#1.https://github.com/wush978/Rtwmap下載ZIP
#2.解壓縮後，將資料夾放置R中的library裡，名稱改為"Rtwmap"
#3.只能在R上執行，無法使用RStudio執行


data(county2010)

#資料來源檔案名稱
filename <- "injurymap_T"
#資料格式：橫列為不同傷害縣市數據，直行為不同傷害類型的單年數據，
#資料內容第一欄為縣市的名稱，第一列為傷害類型的名稱，詳見 injurymap 範例
input.data.mx <- read.csv(paste("raw data/",filename,".csv",sep=""), header=TRUE)
population <- input.data.mx

#1.names of country2010 
taiwan <- c("臺東縣","花蓮縣","苗栗縣","雲林縣","高雄市","南投縣","嘉義縣","宜蘭縣","屏東縣","新北市","桃園縣","臺中市","臺北市","臺南市","金門縣","連江縣","澎湖縣","嘉義市","基隆市","彰化縣","新竹市","新竹縣")
county2010$county <- taiwan

rownames(population) <- as.character(population$X)

# k 為傷害類型的位置，從第2欄開始
k <- 2
  name.title <- colnames(population)[k]
  #name.title <- paste("2009-2011 ",colnames(population)[k],sep="")
  
  #min
  min.vt <- as.numeric(summary(population[,k]))[1]
  #Q1
  q1.vt <- as.numeric(summary(population[,k]))[2]

  #median
  q2.vt <- as.numeric(summary(population[,k]))[3]

  #Q3
  q3.vt <- as.numeric(summary(population[,k]))[5]

  #max
  max.vt <- as.numeric(summary(population[,k]))[6]
  
  number.vt <- population[as.character(county2010$county), k]
  
#2.Corresponding to number and color
  grouping.vt <- rep(NA,length(number.vt))
  grouping.vt[which(number.vt<=q1.vt)] <- 1
  grouping.vt[which(number.vt>q1.vt & number.vt<=q2.vt)] <- 2
  grouping.vt[which(number.vt>q2.vt & number.vt<=q3.vt)] <- 3
  grouping.vt[which(number.vt>q3.vt)] <- 4
  
  col <- brewer.pal(4,"Blues")
  
  county2010$grouping <- grouping.vt
  win.graph(width=20, height=25)
  jpeg(file=paste("output/injury map_",name.title,".jpeg",sep=""))
  spplot(county2010, "grouping", col.regions=col, colorkey=FALSE, main=name.title,xlim=c(118,124), ylim=c(21.6,26.3))
  #savePlot(filename=paste("output/injury map_",name.title,sep=""),type="wmf")
  dev.off()
