# create the server functions for the dashboard  
server <- function(input, output) { 
  
  
##---------------- DASHBORAD page -----------------##

  
  #creating the valueBoxOutput content
  output$value1 <- renderValueBox({
    valueBox(
      formatC(max(nrow(customers)), format="d", big.mark=',')
      ,paste('Total number of Customers')
      ,icon = icon("user",lib='glyphicon')
      ,color = "purple")
    
    
  })
  
  
  
  output$value2 <- renderValueBox({
    
    valueBox(
      formatC(total.revenue, format="d", big.mark=',')
      ,'Total Expected Revenue'
      ,icon = icon("gbp",lib='glyphicon')
      ,color = "green")
    
  })
  
  
  
  output$value3 <- renderValueBox({
    
    valueBox(
      formatC(top_product$Total, format="d", big.mark=',')
      ,paste('Top Product type/Revenue:',top_product$product)
      ,icon = icon("menu-hamburger",lib='glyphicon')
      ,color = "yellow")
    
  })
  
  #creating the plot/charts content
  
  
  output$PercntProd <- renderEcharts4r({
    e_charts() %>% 
      e_gauge(81, "PERCENT") 
  })
  output$PercntProd1 <- renderEcharts4r({
    e_charts() %>% 
      e_gauge(72, "PERCENT") 
  })
  output$PercntProd2 <- renderEcharts4r({
    e_charts() %>% 
      e_gauge(12, "PERCENT") 
  })
  
  output$GoalAch <- renderEcharts4r({
    e_charts() %>% 
      e_gauge(74, "PERCENT") %>% 
      e_title("GoalAch")
  })
  

  funnel <- data.frame(stage = c("View", "Click", "Purchase"), value = c(80, 30, 20))
  

  
  output$Funnel <- renderEcharts4r({
    funnel %>% 
      e_charts() %>% 
      e_funnel(value, stage) %>% 
      e_title("Funnel")
  })
  
  TOPcustomers<-customers %>%
    group_by(CustomerID,first_name, last_name) %>% 
    summarise(Total_spent=Total_spend) %>%
    arrange(Total_spent) %>%
    head(10) %>%
    mutate(Customer=paste(first_name,last_name))
  
  TOPcustomers<-TOPcustomers[c(5,4)]
  
  
  output$Top10Customr <- renderEcharts4r({
    
    TOPcustomers %>%
      e_charts(Customer) %>%
      e_bar(Total_spent) %>%
      e_flip_coords() %>% 
      e_legend(show = F) %>% 
      e_labels(fontSize = 9) %>%
      e_title("Top 10 Customers",  left = 'center') %>%
      e_y_axis(axisLabel = list(fontSize = 8,
                                formatter = htmlwidgets::JS("
                                                        function(params){return (params.split(' ').join('\\n'))}
                                                        ")
      )
      )
  })
  
  
  output$revenuebyPrd <- renderEcharts4r({
    My_df %>%
      e_charts(name)  %>% 
      e_pie(total, roseType = "radius",legend = FALSE, label = list(
        formatter = htmlwidgets::JS(
          "function(params){
      var vals = params.name.split(',')
      return(vals[0])}"))
      ) %>%
      e_legend(formatter = htmlwidgets::JS(
        "function(name){
      var vals = name.split(',')
      return(vals[0])}")) %>% 
      e_tooltip(formatter = htmlwidgets::JS("
                                        function(params){
                                        var vals = params.name.split(',')
                                        
                                        return('<strong>' + vals[0] + 
                                        '</strong><br />total: ' + params.value + 
                                        '<br />percent: ' +  vals[1])   }  "))
  })
  
  
  output$revenuebyRegion <- renderEcharts4r({
    My_df_2 %>%
      e_charts(name)  %>% 
      e_pie(total, radius = c("50%", "70%"), label = list(
        formatter = htmlwidgets::JS(
          "function(params){
      var vals = params.name.split(',')
      return(vals[0])}"))
      ) %>%
      e_legend(formatter = htmlwidgets::JS(
        "function(name){
      var vals = name.split(',')
      return(vals[0])}")) %>% 
      e_tooltip(formatter = htmlwidgets::JS("
                                        function(params){
                                        var vals = params.name.split(',')
                                        
                                        return('<strong>' + vals[0] + 
                                        '</strong><br />total: ' + params.value + 
                                        '<br />percent: ' +  vals[1])   }  "))
    
  })
  
  
  ##---------------- STATS page -----------------##
  
  
  
  # Create a subset data frame
  subset_data <- reactive({
    customers
    if (input$select_region == "All") {
      customers
    } else {
      customers[customers$Region == input$select_region,]
    }
  })
  
  output$Boxplot <- renderEcharts4r({
    subset_data() %>% 
      group_by(gender) %>% 
      e_charts() %>% 
      e_boxplot(Total_spend) %>%
      e_title(paste("Total spent by gender for",input$select_region,"region(s)"),  left = 'center')
      
  })
  
  output$Histo <- renderEcharts4r({
    subset_data() %>%
      e_charts() %>%
      e_histogram(Age) %>%
      e_density(Age, areaStyle = list(opacity = .4), smooth = TRUE, name = "density", y_index = 1) %>%
      e_tooltip(trigger = "axis") %>%
      e_title(paste("Age distribution for",input$select_region,"region(s)")) 
      

    
  })
  
  
 
  ##---------------- RAW DATA page -----------------##
  
  
  output$downloadCsv <- downloadHandler(
    filename = "customer_data.csv",
    content = function(file) {
      write.csv(customers, file)
    },
    contentType = "text/csv"
  )
  
  output$custom_data <- DT::renderDataTable(DT::datatable({
    data <- customers
    if (input$chan != "All") {
      data <- data[data$Channel == input$chan,]
    }
    if (input$reg != "All") {
      data <- data[data$Region == input$reg,]
    }
    data
  },  selection = 'single', extensions = 'Buttons',
  options = list(
    dom = 'Bfrtip',
    autoWidth = F,
    pageLength = 15,
    buttons = list(
      list(extend = 'excel', title = "Raw data in Excel format")) ,
    searching = TRUE,
    editable = TRUE,
    scrollX=T,
    scrollY=T
    ),
  rownames= FALSE))
  
}