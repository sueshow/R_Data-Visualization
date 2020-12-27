# R_Data-Visualization

## library
```
library(ggplot2)
library(plyr)
library(tidyverse)
```
<br>

## ErrorBar
```
plotData <- tribble( ~level, ~mean, ~cil, ~ciu,
                          1, 38.72, 38.1, 39.34,
                          2, 45.23, 41.6, 48.82,
                          3, 51.75, 48.7, 54.75,
                          4, 61.66, 61.1, 62.20
                   )

plotData %>% 
  ggplot() + 
  geom_point( aes(x=level, y=mean) ) +
  geom_errorbar( aes(x=level, ymin=cil, ymax=ciu) )
```
![ggplot_errorbar](https://github.com/sueshow/R_Data-Visualization/blob/main/picture/ggplot_errorbar.jpeg)
<br>

## Bar
* 探索類別
* 已經統計過的資訊，繪製長條圖就必須要指定一個參數 `stat="identity"`
```
TFMqe <- data.frame( stringsAsFactors= FALSE,
                     Group = c("Non-Fertile Chip",
                               "Non-Fertile Chip","Fertile Chip","Fertile Chip",
                               "Non-Fertile Chip","Fertile Chip","Non-Fertile Chip",
                               "Non-Fertile Chip","Fertile Chip","Non-Fertile Chip"),
                     NTopQualityEmbryos = c("Yes","Yes","Yes","Yes",
                                            "Yes","No","Yes","Yes","No","No")
)

ggplot( TFMqe, aes(x=NTopQualityEmbryos,
                   y=stat(count/sum(count)),
                   fill=Group) ) +
  geom_bar( position=position_dodge2()) +
  geom_text( aes(label=scales::percent(stat(count/sum(count)), 
             accuracy = 0.01)),
             position = position_dodge2(.9),
             vjust = 1.6,
             color = "white",
             size = 3.5,
             stat = "count" ) +
  scale_y_continuous( label=scales::label_percent() ) +
  labs( x="NTopQualityEmbryos",
        y="Percentatges",
        fill="Group" ) +
  theme_minimal() +
  theme( legend.position = "bottom" )
```
![ggplot_bar](https://github.com/sueshow/R_Data-Visualization/blob/main/picture/ggplot_bar.jpeg)
<br>

## box
* 探索不同類別與數值分佈的關係
```
geom_boxplot()
```
<br>

## Histogram
* 探索數值分佈
```
prediction_1 = 0.469
prediction_3 <- data.frame( prediction_3=rnorm(1000, 4, 3) )  
prediction_2b <- data.frame( prediction=rnorm(10000, 8, 3) )

ggplot( prediction_3 ) +
  geom_histogram( aes(x=prediction_3), binwidth = 0.01 )
ggplot(prediction_2b) +
  geom_histogram( aes(x=prediction), binwidth = 0.01 )

dats <- rbind( data.frame(pred=prediction_3$prediction_3, var = 'prediction_3'),
              data.frame(pred=prediction_2b$pred, var = 'prediction_2b') )

ggplot( dats, aes(pred, fill=var) ) + 
  geom_histogram( alpha = 0.5, position = "identity", bins = 75 ) +
  geom_vline( xintercept=prediction_1 )
```
![ggplot_histogram](https://github.com/sueshow/R_Data-Visualization/blob/main/picture/ggplot_histogram.jpeg)
<br>

## point
* 探索兩個數值的關係
```
geom_point()
```
<br>

## line
* 探索數值與日期 (時間) 的關係
```
geom_line()
```
<br>

## curve
```
stat_function(fun, geom = "line")
```
<br>

## Map
### Sp
```
require(raster)
require(sp)
require(lattice)
require(grid)

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
```
![Map](https://github.com/sueshow/R_Data-Visualization/blob/main/output/spplot_example.jpeg)
<br>

### Taiwan
```
#(NOT RUN)
spplot(county2010, "grouping", col.regions=col, 
         colorkey=list(at=seq(0, 4, 1), labels=as.character(c( "0", "1", "2", "3", "4" )), 
                       col=col, space="left", height=0.4), 
         main=name.title, xlim=c(118,124), ylim=c(21.6,26.3))
```
![Taiwan Map](https://github.com/sueshow/R_Data-Visualization/blob/main/output/injury%20map_A.jpeg)
<br>

## Dashboard
### 簡介
* Shiny 主要特色：將資料分析結果轉換成互動式的網頁應用程式
* 使用者介面 (User Interface)：通常會使用 `dashboardPage()` 函數建構，而非常見的 `fluidPage()` 函數
  * 儀表板標頭 (header)：`dashboardHeader()`，不需要也可關掉 `disable=TRUE`
    * 標題：`title`
    * 訊息選單：`messageItem()`
    * 通知選單：`notificationItem()`
    * 工作選單：`taskItem()`
    * 若想在後端修改選單元件，則需使用 `dropdownMenuOutput()` 設定輸出元件，並在伺服器端程式用 `renderMenu()` 作動態設定
  * 側邊選單 (sidebar)：`dashboardSidebar()`
    * 每個選單 `sidebarMenu()` 中可有多個選項 `meunItem()`
    * 在選項中除可在第一個參數設定選項名稱外，也必須用 `tabName` 參數設定選項ID，以及 `icon` 參數加上圖示
  * 主頁面 (body)：`dashboardBody()`，不需要也可關掉 `disable=TRUE`
    * 使用 `tabItems()` 來排版
    * 在 `tabItems()` 中可用多個 `tabItem()` 來對應側邊欄位的每個選項，對應方式為設定相同的 `tabName`
    * 在 `tabItems()` 中，再使用列 `fluidRow` 和欄位 `column` 或資訊區塊 `box` 的方式將圖表排版
* 伺服器端程式 (Server Instruction)
  * 資料呈現方式：
    * 數字與文字：`renderText()`
    * 表格：`renderTable()`，DT套件支援互動式表格
    * 圖片：`renderPlot()`
    * 地圖：`ggmap` 套件或 `leaflet` 套件支援互動式地圖
* 重要議題：
  * 快速將資料載入：考慮批次方式，先作預處理，降低資料量，以加快資料存取速度

<br>

## 更多參考資訊
![更多參考資訊](https://github.com/sueshow/R_Data-Visualization/blob/main/picture/ggplot.png)
<br>

## 參考資料
* [ggplot2](https://beta.rstudioconnect.com/content/3279/ggplot_tutorial.html)
* [shinydashboard](https://rstudio.github.io/shinydashboard/)
* [shiny from Rstudio](https://shiny.rstudio.com/gallery/)
