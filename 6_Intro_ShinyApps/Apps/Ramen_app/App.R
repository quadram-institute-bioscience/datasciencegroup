library(shiny)
library(tidyverse)

# load ramen Ratings dataset
ramen_ratings <- readr::read_csv("ramen_dataset.csv")

# get list of countries in dataset
country_list<- ramen_ratings %>% select(country) %>% unique()

# UI
ui <- fluidPage( 
  # ----------------------------------
  h1("Best Ramens in the world", align = "center"),
  p("Explore the best ramens in the world, recommended by the users themselves! In this tab, you can 
                select your favorite ramen style and the country of fabrication. The table below display the best three 
                ramens for this selection!"),
  HTML('<center><img src="1200px-Shoyu_Ramen.jpg" width="100%"></center>'),
  HTML('<br/>'),
  # ----------------------------------
  sidebarLayout(fluid=TRUE,
                sidebarPanel(
                  selectInput("style", label="Select the ramen style:",
                              c("Pack","Bowl","Cup" ),
                              selected = "Cup",
                              multiple= TRUE),
                  
                  selectInput("country", label="Select the country of fabrication:",
                              country_list, 
                              selected = "Japan",
                              multiple= FALSE),
                  
                  radioButtons("pType", label="Choose View:",
                               list("Barchart", "Boxplot"))
                  
                ),
                mainPanel(
                  h3(textOutput("toptitle"), align = "left"),
                  tableOutput("top3"),
                  conditionalPanel('input.pType=="Barchart"', plotOutput("barplot")),
                  conditionalPanel('input.pType=="Boxplot"',plotOutput("boxplot")),
                ), # end main panel
  ),
  # ----------------------------------
  includeHTML("footer.html"),
) # end NavPage panel


# ----------------------------------
# ----------------------------------
# ----------------------------------
# SERVER SIDE
# ----------------------------------
# ----------------------------------

server <- function(input, output) {
  
  # Title main area
  # ----------------------------------
  output$toptitle <- renderText({
    paste("Best ramens in ", input$country)
  })
  
  # ----------------------------------
  # Reactive elements
  display_dataset <- reactive({
    ramen_ratings %>% filter(style %in% input$style & country == input$country)
  })
  
  # ----------------------------------
  # Table output
  output$top3 <- renderTable({
    display_dataset() %>% arrange(desc(stars)) %>% slice(1:3) %>% select(-continent, -review_number)
  })
  
  # ----------------------------------
  # Plot outputs
  output$barplot <- renderPlot({  
    display_dataset() %>%  ggplot(aes(x=stars, fill=style)) +
      geom_histogram(color="black",binwidth = 1)+
      scale_x_continuous(breaks = c(0, 1, 2, 3, 4, 5), limits = c(-1,6))+
      ggtitle("Ramens Ratings") +
      ylab("Number of Ramens")+
      xlab("Average Ratings")+
      theme_minimal(base_size = 13)
  })
  
  output$boxplot <- renderPlot({  
    display_dataset() %>% ggplot(aes(x=style, y=stars, color=style)) +
      geom_boxplot() +
      ggtitle("Ramens Ratings") +
      ylab("Average Ratings") +
      xlab("Style of Ramen") +
      theme_minimal(base_size = 13)
  })
  
}

shinyApp(server = server, ui = ui)