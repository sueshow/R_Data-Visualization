

function(input, output){
  output$msg_menu <- renderMenu({
    dropdownMenu(type = "messages",
                 messageItem( from = "訊息來源",
                              message = "訊息內容")
    )
  })
  
  output$not_menu <- renderMenu({
    dropdownMenu(type = "notifications",
                 notificationItem( text = "通知通知",
                                   icon("users"))
    )
  })
  
  output$tsk_menu <- renderMenu({
    dropdownMenu(type = "tasks",
                 taskItem( value = 90, 
                           color = "green","工作進度")
    )
  })
  

  set.seed(122)
  histdata <- rnorm(500)
  
  output$plot1 <- renderPlot({
    data <- histdata[seq_len(input$slider)]
    hist(data)
  })
}