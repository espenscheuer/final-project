# Sets up neccesary libraries
library(shiny)
source('FinalProjectData.R')

#Sets up the UI
ui <- fluidPage(
  
  titlePanel("Understanding the World's Economy"),
  
  br(),
  
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
      tabPanel("Map of Poverty",
        sidebarLayout(
          sidebarPanel(
            radioButtons("dday", label = "Dollars per day",
                         c("1.09" = "1.09",
                           "3.20" = "3.20",
                           "5.50" = "5.50")),
            
            br(),
            
            selectInput('year', label = 'Year of data collection:', c('2015', '2014', 
                        '2013', '2012', '2011', '2010', '2009', '2008', '2007', 
                        '2006', '2005', '2004','2003', '2002', '2001', '2000',
                        '1999', '1998', '1997', '1996', '1995', '1994', '1993',
                        '1992', '1991', '1990', '1989', '1988', '1987', '1986',
                        '1985', '1984', '1983', '1982', '1981', '1980'))
            
          ),
          mainPanel(br(), p("This map shows the percentage of people in that country
                     who live on the selected amount per day in the selected
                     year."), plotOutput('PovMap', click = 'map_click'),
            textOutput('Country')
          )
        )         
      )
    )
)
shinyUI(ui)