library(shiny)
library(tidyverse)

# ----------------------------------
# ----------------------------------
# ----------------------------------
# UI
# ----------------------------------
# ----------------------------------
# ----------------------------------

ui <- fluidPage(
  headerPanel('Iris dataset'),
  sidebarPanel(
    selectInput('spec', 'Iris species', 
                c("Setosa" = "setosa",
                  "Versicolor" = "versicolor",
                  "Virginica" = "virginica"),
                multiple= TRUE,
                selected = "setosa"),
  ),
  mainPanel(
    plotOutput('plot_iris')
  )
)


# ----------------------------------
# ----------------------------------
# ----------------------------------
# SERVER SIDE
# ----------------------------------
# ----------------------------------

server <- function(input, output) {
  
  output$plot_iris <- renderPlot({
    iris_plot <- iris %>% filter(Species %in% input$spec)
    iris_plot %>% ggplot(aes(x=Petal.Length, Petal.Width, color=Species)) + 
            geom_point()+
            ggtitle("Edgar Anderson's Iris Data") +
            ylab("petal length")+
            xlab("petal width")+
            theme_minimal(base_size = 13)
  })
  
}


# ----------------------------------
# ----------------------------------
# ----------------------------------
# App declaration
# ----------------------------------
# ----------------------------------
shinyApp(ui = ui, server = server)