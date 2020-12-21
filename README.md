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
<img src="https://github.com/sueshow/R_Data-Visualization/blob/main/picture/ggplot_bar.jpeg" width=800>
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
<img src="https://github.com/sueshow/R_Data-Visualization/blob/main/picture/ggplot_bar.jpeg" width=800>
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
<img src="https://github.com/sueshow/R_Data-Visualization/blob/main/picture/ggplot_histogram.jpeg" width=800>
<br>

## 更多參考資訊
![更多參考資訊](https://github.com/sueshow/R_Data-Visualization/blob/main/picture/ggplot.png)
<br>

## 參考資料
* https://beta.rstudioconnect.com/content/3279/ggplot_tutorial.html
