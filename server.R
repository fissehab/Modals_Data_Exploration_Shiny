
library(data.table)
library(DT)
library(tidyverse)
library(plotly)



countries = fread("data/countries_region_income_group.csv")
wb = fread("data/world_bank_data.csv")

wb = as_data_frame(wb)
cols = 2:13  
wb[,cols] = apply(wb[,cols], 2, function(x) as.numeric(as.character(x)))



library(shiny)
library(DT)

countries$Flag = paste0('<img src ="',tolower(countries$Code),'.png"', ' alt="Flag not available"  height="30" width="40" ></img>')
  



shinyServer(function(input, output){
  

  output$select_x_axis <- renderUI({
    selectInput("Select_field_x_axis", "X-axis:",
                choices = names(wb)[!(names(wb) %in% c("Country Name", "Year", "Surface area (sq. km)" ))],
                selected = "Death rate, crude (per 1,000 people)"
                )
  })
  
  
  output$select_y_axis <- renderUI({
    selectInput("Select_field_y_axis", "Y-axis:",
                choices = names(wb)[!(names(wb) %in% c("Country Name", "Year", "Surface area (sq. km)" ))],
                selected = "Fertility rate, total (births per woman)"
    )
  })
  

  
  vals = reactiveValues()
  vals$Data = countries
  
  output$mytable <- DT::renderDataTable({
    
    DT::datatable(vals$Data, escape = FALSE, rownames = FALSE, options = list(
      pageLength = 10
    )) 
  })
  
  
  observeEvent(input$delete_row,{
    x = isolate(vals$Data)
    x = x[-input$mytable_rows_selected,]
    vals$Data = x
  })
  
  
  observeEvent(input$show_all,{
    vals$Data= countries
  })
  

selected_nations = reactive({
      x = isolate(vals$Data)
      x = x[input$mytable_rows_selected,]
      x$Country
})

selected_data = reactive({
  wb %>% filter(`Country Name` %in% selected_nations())
})


output$downloadData <- downloadHandler(
  filename = paste("Data_for_selected_countries",Sys.Date(), ".csv", sep=""),
  content = function(file) {
    write.csv(selected_data(), file)
  }
)


local_df = reactive({
  
  req(input$Select_field_x_axis)
  req(input$Select_field_y_axis)
  
  mydata = selected_data()
  df = data_frame(xaxis = mydata[[input$Select_field_x_axis]],
                    yaxis = mydata[[input$Select_field_y_axis]],
                    Population = mydata[["Population, total"]],
                    Country = mydata[["Country Name"]],
                    Year = mydata[["Year"]])
    df
  
})


output$plotly_animation = renderPlotly({

  plot_ly(data = local_df(),
    x = ~xaxis, 
    y = ~yaxis, 
    size = ~Population, 
    color = ~Country, 
    frame = ~Year, 
    text = ~Country, 
    hoverinfo = "text",
    type = 'scatter',
    mode = 'markers'
  ) %>% layout( xaxis = list( title = input$Select_field_x_axis), 
                       yaxis = list( title=input$Select_field_y_axis) ) %>%
    animation_opts(
      500, easing = "elastic", redraw = FALSE
    ) %>%
    animation_slider(
      currentvalue = list(prefix = "YEAR ", font = list(color="red"))
    )

 
})
})