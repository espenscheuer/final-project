library(shiny)
library(ggplot2)
library(ggthemes) 
library(tidyr)

source("spatial_utils.R")
source("FinalProjectData.R")

# Define a server function
server <- function(input, output) {
  
  # Code for making the first tab
  output$Map <- renderPlot(
    ggplot(data = map) +
      geom_map(map=map, aes(map_id=region, x = long, y = lat), fill = "white", color = "black") 
  )
  
  # Observes clicks and displays the country name longitude and latitude
  observeEvent(input$map_click, {
    name <- GetCountryAtPoint(input$map_click$x, input$map_click$y)
    name <<- name
    text <- reactive({
      if(input$World) {
        name <- ("World GDP")
      } else {
        name <- paste(name, "GDP")
      }
      if(input$Scale) {
        name <- paste(name, "(y scale set to World GDP)")
      }
      return(name)
    })
    
    output$Country <- renderText(text())
    
    plot.data <- reactive({
      data <- gdp2
      if(name == "Russia") {
        name = "Russian Federation"
      }
      if(name == "Egypt") {
        name = "Egypt, Arab Rep."
      }
      if(name == "Venezuela") {
        name = "Venezuela, RB"
      }
      if(name == "Republic of Congo") {
        name = "Congo, Rep."
      }
      if(name == "Democratic Republic of the Congo") {
        name = "Congo, Dem. Rep."
      }
      if(!input$World) {
        data <- filter(data, Name == name | Code == name)
      } else {
        data <- filter(data, Name == "World")
      }
      data$Year <- c(1961 : 2019)
      data$GDP <- as.numeric(data$GDP)
      return(data)
    })
    
    g <- reactive({
      g <- ggplot(data = plot.data()) +
        geom_line(mapping = aes(x = Year, y = GDP, group = 1, fill = Name), size = 1.5) +
        theme_stata()  
      if(input$Scale) {
        g <- g + scale_y_continuous(limits = c(0, 7.904521e+13))
      }
      return(g+ geom_smooth(aes(x = Year, y = GDP), method= "lm", formula = y ~ x))
    })
    
    output$Lines <- renderPlot(
      g()
    )
    # Code for making the second tab 
    
    # Code for making the third tab
    
  })
}

shinyServer(server)  # create the server