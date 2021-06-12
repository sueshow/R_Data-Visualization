library(ggplot2)
library(plyr)
library(tidyverse)				  


#################### ErrorBar ####################
plotData <- tribble( ~level, ~mean, ~cil, ~ciu,
                          1, 38.72, 38.1, 39.34,
                          2, 45.23, 41.6, 48.82,
                          3, 51.75, 48.7, 54.75,
                          4, 61.66, 61.1, 62.20
                   )
#法一
image <- ggplot( plotData, aes(x=level, y=mean) ) +
         geom_errorbar( mapping=aes(x=level, ymin=cil, ymax=ciu) ) +
         geom_point( mapping=aes(x=level, y=mean) )
image


#法二
plotData %>% 
  ggplot() + 
  geom_point( aes(x=level, y=mean) ) +
  geom_errorbar( aes(x=level, ymin=cil, ymax=ciu) )



#################### Histogram ####################
#法一
# fake data
prediction_1 = 0.469
prediction_3 <- data.frame( prediction_3=rnorm(1000, 4, 3) )  
prediction_2b <- data.frame( prediction=rnorm(10000, 8, 3) )

ggplot( prediction_3 ) +
  geom_histogram( aes(x=prediction_3), binwidth = 0.01 )
ggplot(prediction_2b) +
  geom_histogram( aes(x=prediction), binwidth = 0.01 )

dats <- rbind( data.frame(pred=prediction_3$prediction_3, var = 'prediction_3'),
              data.frame(pred=prediction_2b$pred, var = 'prediction_2b') )
# here the plot
ggplot( dats, aes(pred, fill=var) ) + 
  geom_histogram( alpha = 0.5, position = "identity", bins = 75 ) +
  geom_vline( xintercept=prediction_1 )


#法二
prediction_3$prediction_no <- '3'
prediction_2b$prediction_no <- '2b'
colnames(prediction_3) <- c('prediction', 'prediction_no')
colnames(prediction_2b) <- c('prediction', 'prediction_no')
prediction.table <- rbind( prediction_2b, prediction_3 )

p <- ggplot(prediction.table)
p + geom_histogram( aes(x=prediction, fill=prediction_no), binwidth=0.01, alpha=0.7 )
p + geom_histogram( aes(x=prediction, fill=prediction_no), binwidth=0.01, alpha=0.7 ) + 
    scale_fill_manual( values=c('red', 'blue') ) # use your own instead of default colors
p + geom_histogram( aes(x=prediction, fill=prediction_no), binwidth=0.01, alpha=0.7 ) + 
    scale_fill_manual( values=c('red', 'blue') ) + 
    geom_vline( xintercept=prediction_1 ) 
# p + geom_text(aes(0.5,prediction_1,label = 0.469, vjust = 1)) 
# I suggest to move any static assignments out of the aes() call!
# assuming that prediction_1 is a single value you can do
p + geom_text( x=0.5, y=prediction_1, label=0.469, vjust=1 )



#################### Bar ####################
#範例一
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


#範例二
df <- data.frame( x=factor(c(TRUE,TRUE,TRUE,TRUE,TRUE,FALSE,FALSE,FALSE)) )

dfTab <- as.data.frame( table(df) )
colnames(dfTab)[1] <- "x"
dfTab$lab <- as.character( 100 * dfTab$Freq / sum(dfTab$Freq) )
dfTab$lab <- paste( dfTab$Freq, paste("(",dfTab$lab,"%)", sep=""), sep=" " )
ggplot(df) + geom_bar( aes(x, fill=x) ) + 
  geom_text( data=dfTab, aes(x=x, y=Freq, label=lab), vjust=0 )

dfl <- ddply( df, .(x), summarize, y=length(x) )
str( dfl )
ggplot( dfl, aes(x, y=y, fill=x) ) + 
  geom_bar( stat="identity" ) +
  geom_text( aes(label=y), vjust=0 )

ggplot( data=df, aes(x=x) ) +
  geom_bar( stat="count" ) + 
  stat_count( geom="text", colour="white", size=3.5,
              aes(label=..count..), position=position_stack(vjust=0.5) )

# 參考資料
# https://beta.rstudioconnect.com/content/3279/ggplot_tutorial.html
