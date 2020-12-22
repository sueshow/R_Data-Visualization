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

## Histogram
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
    * 在選項中除可在第一個參數設定選項名稱外，也必須用 tabName 參數設定選項ID，以及 `icon` 參數加上圖示
  * 主頁面 (body)：`dashboardBody()`，不需要也可關掉 `disable=TRUE`
    * 使用 `tabItems()` 來排版
    * 在 `tabItems()` 中可用多個 `tabItem()` 來對應側邊欄位的每個選項，對應方式為設定相同的 tabName
    * 在 `tabItems()` 中，再使用列 `fluidRow` 和欄位 `column` 或資訊區塊 `box` 的方式將圖表排版
* 伺服器端程式 (Server Instruction)

* 重要議題：
  * 快速將資料載入：考慮批次方式，先作預處理，降低資料量，以加快資料存取速度
* 資料呈現方式：
  * 數字與文字：`renderText()`
  * 表格：`renderTable()`，DT套件支援互動式表格
  * 圖片：`renderPlot()`
  * 地圖：`ggmap` 套件或 `leaflet` 套件支援互動式地圖
<br>

## 更多參考資訊
![更多參考資訊](https://github.com/sueshow/R_Data-Visualization/blob/main/picture/ggplot.png)
<br>

## 參考資料
* ![ggplot2](https://beta.rstudioconnect.com/content/3279/ggplot_tutorial.html)
* ![shinydashboard](https://rstudio.github.io/shinydashboard/)
