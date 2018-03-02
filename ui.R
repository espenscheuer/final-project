# Sets up neccesary libraries
library(shiny)
source('FinalProjectData.R')

#Sets up the UI
ui <- fluidPage(
  
  titlePanel("Understanding the Worlds Economy"),
  
    tabsetPanel(type = "tabs",
      tabPanel("Viewing the World's GDP", 
        sidebarLayout(
          sidebarPanel(
             # Creates controls allowing user to choose types of info displayed
             checkboxInput('World',label = "World GDP",  value = FALSE),
             checkboxInput('Scale', label = "Scale to World", value = FALSE)
          ),
          mainPanel(
            plotOutput('Map', click = 'map_click'),
            textOutput('Country'),
            plotOutput('Lines')
          )
        )
      ),
      tabPanel("Map of Poverty"),
      tabPanel("Change of Wealth")
    )
)
shinyUI(ui)