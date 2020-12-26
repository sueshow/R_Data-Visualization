#################### Taiwan Map ####################
rm(list = ls())
#資料夾位置
path <- setwd("D:/資料分析彙整/Project/2016 Taiwan Map")

#install.packages("sp") 
#install.packages("RColorBrewer") 
#install.packages("rjson")
#install.packages("rstan")
library(sp)
library(RColorBrewer)
#library(rjson)
library(jsonlite)
library(rstan)

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

map_nm <- "county2010"
result <- fromJSON( paste(path, "/map/", map_nm, ".json", sep="") )
#result_data_frame <- as.data.frame(result)
head(result)

data <- readRDS( file=paste0(path, "/raw data/", map_nm, ".rda") )



data(county2010)

#資料來源檔案名稱
filename <- "injurymap_T"
#資料格式：橫列為不同傷害縣市數據，直行為不同傷害類型的單年數據，
#資料內容第一欄為縣市的名稱，第一列為傷害類型的名稱，詳見 injurymap 範例
input.data.mx <- read.csv(paste(path, "/raw data/", filename, ".csv", sep=""), header=TRUE)
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
  grouping.vt[ which(number.vt<=q1.vt) ] <- 1
  grouping.vt[ which(number.vt>q1.vt & number.vt<=q2.vt) ] <- 2
  grouping.vt[ which(number.vt>q2.vt & number.vt<=q3.vt) ] <- 3
  grouping.vt[ which(number.vt>q3.vt) ] <- 4
  
  col <- brewer.pal(4,"Blues")
  
  county2010$grouping <- grouping.vt
  #方法一(wmf)
  win.graph(width=20, height=25)
  spplot(county2010, "grouping", col.regions=col, colorkey=FALSE, main=name.title, xlim=c(118,124), ylim=c(21.6,26.3))
  savePlot( filename=paste("output/injury map_", name.title,sep=""), type="wmf" )
  dev.off()
  #方法二(jpeg)
  win.graph(width=20, height=25)
  dev.copy(jpeg, paste("./output/injury map_", name.title, ".jpeg", sep=""))
  spplot(county2010, "grouping", col.regions=col, colorkey=list(space="left", height=0.4), main=name.title, xlim=c(118,124), ylim=c(21.6,26.3))
  dev.off()

  
#################### Spplot Example ####################
require(raster)
require(sp)
require(lattice)
library(grid)
  
north <- list("SpatialPolygonsRescale", layout.north.arrow(type=1), offset=c(0.95,0.85), scale=0.1)
scale <- list("SpatialPolygonsRescale", layout.scale.bar(),
                offset=c(0.55, 0.03), scale=0.4, fill=c("transparent","black"))
txt1 <- list("sp.text", c(0.55, 0.08), "0")
txt2 <- list("sp.text", c(0.75, 0.08), "0.2")
txt3 <- list("sp.text", c(0.95, 0.08), "0.4")
raster_layout <- list(north, scale, txt1, txt2, txt3)
cuts <- c(110, 120, 130, 140, 150, 160, 170, 180, 190, 200)
spplot(raster(volcano), scales=list(draw=T), at=cuts, col.regions=palette(gray(seq(0,0.9,len=9))), sp.layout=raster_layout, add=T)  
grid.text("XXX (m)", x=unit(0.95, "npc"), y=unit(0.50, "npc"), rot=-90)
  