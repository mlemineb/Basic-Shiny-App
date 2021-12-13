#Dashboard header carrying the title of the dashboard
header <- dashboardHeader(title = "Basic Dashboard",
                          dropdownMenu(type = "messages",
                                       messageItem(
                                         from = "Sales Dept",
                                         message = "Sales are steady this month."
                                       ),
                                       messageItem(
                                         from = "New User",
                                         message = "How do I register?",
                                         icon = icon("question"),
                                         time = "13:45"
                                       ),
                                       messageItem(
                                         from = "Support",
                                         message = "The new server is ready.",
                                         icon = icon("life-ring"),
                                         time = "2021-12-01"
                                       )
                          ),
                          dropdownMenu(type = "notifications",
                                       notificationItem(
                                         text = "5 new users today",
                                         icon("users")
                                       ),
                                       notificationItem(
                                         text = "12 items delivered",
                                         icon("truck"),
                                         status = "success"
                                       ),
                                       notificationItem(
                                         text = "Server load at 86%",
                                         icon = icon("exclamation-triangle"),
                                         status = "warning"
                                       )
                          ),
                          dropdownMenu(type = "tasks", badgeStatus = "success",
                                       taskItem(value = 90, color = "green",
                                                "Documentation"
                                       ),
                                       taskItem(value = 17, color = "aqua",
                                                "Project X"
                                       ),
                                       taskItem(value = 75, color = "yellow",
                                                "Server deployment"
                                       ),
                                       taskItem(value = 80, color = "red",
                                                "Overall project"
                                       )
                          )
                          
                          )  

#Sidebar content of the dashboard
sidebar <- dashboardSidebar(
  sidebarMenu(id = "sidebarmenu",
              HTML(paste0(
                "<br>",
                "<a href='https://www.shinyapps.io' target='_blank'><img style = 'display: block; margin-left: auto; margin-right: auto;' src='logo2.png' ></a>",
                "<br>"
              )),
    menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
    menuItem("Stats", tabName = "stats",icon = icon("stats",lib='glyphicon')),
    conditionalPanel(
      "input.sidebarmenu === 'stats'",
          selectInput("select_region", "Region", choices = region_choice,bookmarkButton(id = "bookmark1"))
          
      ),
    menuItem("Raw data", tabName = "rawdata", icon = icon("th-list",lib='glyphicon') ),
    HTML(paste0(
      "<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>",
      "<table style='margin-left:auto; margin-right:auto;'>",
      "<tr>",
      "<td style='padding: 5px;'><a href='https://twitter.com/m_lemine_b' target='_blank'><i class='fab fa-twitter fa-lg'style='color:#DDDDDD;'></i></a></td>",
      "<td style='padding: 5px;'><a href='https://www.linkedin.com/in/mohamed-lemine-beydia/' target='_blank'><i class='fab fa-linkedin fa-lg'style='color:#DDDDDD;'></i></a></td>",
      "</tr>",
      "</table>",
      "<br>"),
      HTML(paste0(
        "<script>",
        "var today = new Date();",
        "var yyyy = today.getFullYear();",
        "</script>",
        "<p style = 'text-align: center;'><small>&copy; - <a href='mailto:m.beydia@gmail.com'style='color:#DDDDDD'; target='_blank'>Mohamed Beydia</a> - <script>document.write(yyyy);</script></small></p>")
      ))
  )
)




body <- dashboardBody(
  tabItems(
    tabItem("dashboard",
            fluidRow(
              valueBoxOutput("value1")
              ,valueBoxOutput("value2")
              ,valueBoxOutput("value3")
            ),
            fluidRow(
              column(6,
              box(
                title = "products sold"
                ,status = "primary"
                ,solidHeader = TRUE 
                ,collapsible = TRUE 
                ,echarts4rOutput("PercntProd", height = "300px")
              )
              
              ,box(title = "Satisfied Customers"
                       ,status = "primary"
                       ,solidHeader = TRUE 
                       ,collapsible = TRUE 
                       ,echarts4rOutput("PercntProd1", height = "300px")
                     )
              
              , box(title = "Churn rate"
                       ,status = "primary"
                       ,solidHeader = TRUE 
                       ,collapsible = TRUE 
                       ,echarts4rOutput("PercntProd2", height = "300px")
                     )
              
              ,box(
                title = "Goal achivement"
                ,status = "primary"
                ,solidHeader = TRUE 
                ,collapsible = TRUE 
                ,echarts4rOutput("GoalAch", height = "300px")
              )) ,
              
              box(
                title = "Revenue per Product"
                ,status = "primary"
                ,solidHeader = TRUE 
                ,collapsible = TRUE 
                ,echarts4rOutput("revenuebyPrd", height = "300px")
              )
              
              ,box(
                title = "Revenue per Region "
                ,status = "primary"
                ,solidHeader = TRUE 
                ,collapsible = TRUE 
                ,echarts4rOutput("revenuebyRegion", height = "300px")
              )
              
            ),
            
            fluidRow(
              
              
              box(
                title = "Top 10 Customers"
                ,status = "primary"
                ,solidHeader = TRUE 
                ,collapsible = TRUE 
                ,echarts4rOutput("Top10Customr", height = "500px")
              ),
              
              box(
                title = "Funnel from mobile App"
                ,status = "primary"
                ,solidHeader = TRUE 
                ,collapsible = TRUE 
                ,echarts4rOutput("Funnel", height = "500px")
              )
              
            
              
            )
            
            
    ),
    tabItem("stats",  fluidRow(
      
      
      box(
        title = "Total spent by gender"
        ,status = "primary"
        ,solidHeader = TRUE 
        ,collapsible = TRUE 
        ,echarts4rOutput("Boxplot", height = "500px")
      ),
      box(
        title = "Customers'Age distribution"
        ,status = "primary"
        ,solidHeader = TRUE 
        ,collapsible = TRUE 
        ,echarts4rOutput("Histo", height = "500px")
      )
      )),
      
    tabItem("rawdata",
            
            fluidRow(column(4,selectInput("chan","Channel:",
                                         c("All",
                                           unique(as.character(customers$Channel))))
            ),
            column(4,selectInput("reg", "Region:",
                                    c("All",
                                      unique(as.character(customers$Region))))
            ),
            DT::dataTableOutput("custom_data")%>% withSpinner(color = "green")),
            downloadButton("downloadCsv", "Download as CSV")
    )
  )
)




#completing the ui part with dashboardPage
ui <- dashboardPage(title = 'My Basic Shiny Dashboard', header, sidebar, body, skin='red')