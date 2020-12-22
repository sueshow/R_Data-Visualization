

dashboardPage(
  dashboardHeader(title="My First Dashboard",
                  dropdownMenuOutput("msg_menu"),
                  dropdownMenuOutput("not_menu"),
                  dropdownMenuOutput("tsk_menu")
  ),
  ## Sidebar content
  dashboardSidebar(
    sidebarMenu(                                 # 選單
      menuItem("選項名稱1", 
               tabName = "id_1", 
               icon = icon("dashboard")),        # 選項1
      menuItem("選項名稱2", 
               tabName = "id_2", 
               icon = icon("th"))                # 選項2
    )
  ),
  ## Body content
  dashboardBody(
    tabItems( 
      # First tab content
      tabItem(tabName = "id_1",                  # 對應選項1
              fluidRow( 
                box(
                  title = "Controls",
                  sliderInput("slider", "Number of observations:", 1, 100, 50)
                ),
                box(plotOutput("plot1", height = 250))
              ),
              fluidRow(box("Row 2"))
      ),
      # Second tab content
      tabItem(tabName = "id_2",                  # 對應選項2
              infoBox("重要資訊! Info", 50, icon = icon("credit-card")),
              valueBox("重要資訊! Value", 60, icon = icon("thumbs-up")) 
      )  
    )
  )
)