
library(shiny)
library(shinydashboard)
library(shinyBS)
library(DT)
library(plotly)

dashboardPage(dashboardHeader(disable = T),
              dashboardSidebar(disable = T),
              dashboardBody(
                fluidPage(
                  box(width=12,
                      h3(strong("Using Actions And Modals With DataTables For Data Exploration In Shiny "), style="text-align:center;color:#0000ff;font-size:150%"),
                      hr(),
                      helpText("You can select rows by clicking on them. After you select a couple of rows, you can open an animation modal window by clicking the compare button",
                               style="text-align:center"),
                      br(),
                      column(6,offset = 6,
                             
                             column(2, 
                                    actionButton("delete_row", "Hide", style="text-align:center;color:#cc3300; font-size:120%")),
                                    bsTooltip("delete_row", "Hides the selected row(s). To select any row, click on it.",
                                       "right", options = list(container = "body")),
                             
                             
                             column(2, 
                                    actionButton("compare", "Compare", style="text-align:center;color: #0000ff; font-size:120%")),
                                     bsTooltip("compare", "Shows an animation modal window on the selected countries. If a country does not show on the first page, you can search it in the search box.",
                                       "right", options = list(container = "body")),
                             column(2, 
                                    actionButton("show_all", "Show All", style="text-align:center;color:#996600; font-size:120%")),
                             bsTooltip("show_all", "Shows countries that were hidden",
                                       "right", options = list(container = "body"))), 
                      
                      column(12,DT::dataTableOutput("mytable")))
                ),
                br(),
               
                br(),
                
                bsModal("modalExample", strong("Comparison Of Selected Nations", style="color:#0000ff; font-size:120%"), "compare", size = "large",
                      
                      fluidRow(
                        helpText("You can select X-axis and Y-axis fields below. You can also download the data for the selected nations by clicking at the button at the bottom.",
                                 style="text-align:center"),
                        div(style="display: inline-block;vertical-align:top; width: 350px;", uiOutput('select_x_axis')),
                        div(style="display: inline-block;vertical-align:top; width: 350px;", uiOutput('select_y_axis'))
                        ),
                     
                      hr(),
                      br(),
                      
                      plotlyOutput("plotly_animation"),
                      br(),
                      hr(),
                      div(style="display: inline-block;vertical-align:top; width: 200px;", 
                          downloadButton('downloadData', 'Download Data', style="color:#0000ff; font-size:120%"),
                          bsTooltip("downloadData", "You can click this if you want to download the data for the selected nation(s).",
                                    "right", options = list(container = "body"))
                          ))
                        
                )
              )
