library(shiny)
library(ggplot2)
library(ggthemes) 
library(tidyr)
library(maps)
library(dplyr)
library(rsconnect)
library(mapdata)
library(RColorBrewer)

source("spatial_utils.R")
source("FinalProjectData.R")

# Define a server function
server <- function(input, output) {
  
  # Code for making the first tab
  output$Map <- renderPlot(
    ggplot(data = map) +
      geom_map(map=map, aes(map_id=region, x = long, y = lat), fill = "white",
               color = "black") 
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
    
  })
    
    # Code for making the second tab 
    
    cut.groups <- reactive({
      amount <- input$dday
      year <- paste0("X", input$year)
      if (amount == "1.09") {
        dday.data.file <- one.world.merge
      } else if (amount == "3.20") {
        dday.data.file <- three.world.merge
      } else {
        dday.data.file <- five.world.merge
      }
      dday.data <- dday.data.file %>%
        select(c("lat", "long", "group", "region","Name", "Code", "Year", "dollars.day")) %>% 
        filter(Year == year) %>% 
        na.exclude(dollars.day) 
        #data <- cut(dday.data$dollars.day, breaks = c(0, 3, 5, 10, 20, 50), 
                    #labels = c())
        #dday.data$dollars.day = as.numeric(dday.data$dollars.day)
      return(dday.data)
    })
    
    output$PovMap <- renderPlot({
      ggplot() +
        geom_map(data = map, map=map, aes(map_id=region, x = long, y = lat),
                 color = "black")  +
        geom_map(data = cut.groups(), map = map, aes(map_id = region, 
          x = long, y = lat, group = group, fill = dollars.day), color = "black")# + 
        #scale_fill_brewer(palette = "Greens")
      
    })
    
    get.country.name <- reactive({
      if (amount == "1.09") {
        dday.data.file <- one.world.merge
      } else if (amount == "3.20") {
        dday.data.file <- three.world.merge
      } else {
        dday.data.file <- five.world.merge
      }
      dday.data <- dday.data.file %>%
        filter(Year == year)
      
      
    })
   # observeEvent(input$plot_click, {
     output$selected <- renderText({ 
       amount <- input$dday
       year <- paste0("X", input$year)
       if (amount == "1.09") {
         dday.data.file <- one.world.merge
       } else if (amount == "3.20") {
         dday.data.file <- three.world.merge
       } else {
         dday.data.file <- five.world.merge
       }
       dday.data <- dday.data.file %>%
         filter(Year == year)
      # Use `nearPoints()` to get selected rows in the `mpg` data set near to the 
      # click location
      selected <- nearPoints(dday.data, input$plot_click)
      
      # Store `unique()` values from the `class` feature of the selected rows in 
      # the `selected.class` reactiveValue
      #dday.data$selected.class <- unique(selected$class)
      country.name <- unique(selected$Name)
      country.percentage <- unique(selected$dollars.day)
      
   # })
     })
     
     observeEvent(input$map_click, {
       name <- GetCountryAtPoint(input$map_click$x, input$map_click$y)
       amount <- input$dday
       year <- paste0("X", input$year)
       if (amount == "1.09") {
         dday.data.file <- one.world.merge
       } else if (amount == "3.20") {
         dday.data.file <- three.world.merge
       } else {
         dday.data.file <- five.world.merge
       }
       dday.data <- dday.data.file %>%
         filter(Year == year) %>% 
         filter(Name == name) %>% 
         top_n(1)
       sentence <- paste("In", name, dday.data$dollars.day, "% of the population
                         live on $", amount, "per day")
       output$CountryName <- renderText(sentence)
     })
}

shinyServer(server)  # create the server