library(shiny)
library(ggplot2)
library(ggthemes) 
library(tidyr)
library(maps)

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
      return(g)
    })
    
    output$Lines <- renderPlot(
      g()
    )
    
    # Code for making the second tab 
    
    cut.groups <- reactive({
      amount <- input$dday
      year <- paste0("X", input$year)
      if (amount == "1.09") {
        data.file <- one.world.merge
      } else if (amount == "3.20") {
        data.file <- three.world.merge
      } else {
        data.file <- five.world.merge
      }
      data <- data.file %>%
        select(c("lat", "long", "group", "region","Name", "Code", "Year", "dollars.day")) %>% 
        filter("Year" == year) %>% 
        na.exclude(data.file) 
      data$dollars.day <- cut(data$dollars.day, breaks = c(0, 3, 5, 10, 20, 50))
      return(data)
    })
    
    output$PovMap <- renderPlot({
      map <- ggplot() +
        geom_polygon(data = one.world.merge, aes(#map_id=region, 
          x = long, y = lat, group = groupfill = dollars.day),
                     colour = "black") + 
        scale_fill_brewer(palette = "Greens")
      
      return(map)
    })
    
    
    #map <- ggplot() + 
     # geom_polygon(data = cut.groups(), aes(x = long, y = lat, group = group,
      #                                      fill = EN.ATM.CO2E.KT), colour = 'black') +
      #scale_fill_brewer(palette = "Purples")
    
    # Code for making the third tab
    
  })
}

shinyServer(server)  # create the server