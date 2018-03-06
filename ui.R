# Sets up neccesary libraries
library(shiny)
source('FinalProjectData.R')
library(shinythemes)
#Sets up the UI
ui <- fluidPage(
  
  theme = shinytheme("superhero"),
  
  titlePanel("Understanding the Worlds Economy"),
  
    tabsetPanel(type = "tabs",
      tabPanel("Viewing the World's GDP", 
        sidebarLayout(
          sidebarPanel(
             # Creates controls allowing user to choose types of info displayed
             checkboxInput('World',label = "World Stats",  value = FALSE),
             checkboxInput('Scale', label = "Scale to World", value = FALSE),
             selectInput('Indicator', label = "Choose Indicator to Compare",
               choices = list("Female Employment (percent)" = "female_employment", "Male Life Expentency (years)" = "life_exp_male",
                 "Miltary Expenditure (% gov expenditure)" = "miltary_expend",
                 "Refugee Population (# of refugees in Other Countries)" = "refugee_pop", "Gender Equality in School (Gender Parity Index)" = "school_enroll")),
             textOutput('ind'),
             plotOutput('Ind_Line')
          ),
          mainPanel(
            plotOutput('Map', click = 'map_click'),
            textOutput('Country'),
            plotOutput('Lines')
          )
        )
      ),
      tabPanel("Map of Poverty")
    )
)
shinyUI(ui)