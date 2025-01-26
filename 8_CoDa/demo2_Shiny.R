library(shiny)
library(tidyverse)
library(GGally)
library(patchwork)

ui <- fluidPage(
  titlePanel("Exploring Spurious Correlations in Compositional Data"),
  
  sidebarLayout(
    sidebarPanel(
      # Parameters for data generation
      numericInput("n_samples", 
                   "Number of samples:", 
                   value = 100, 
                   min = 30, 
                   max = 500),
      
      # Correlation strength controls
      sliderInput("cor_strength1", 
                  "Correlation strength (Taxa1 → Taxa3):",
                  min = 0, 
                  max = 1, 
                  value = 0.5,
                  step = 0.1),
      
      sliderInput("cor_strength2", 
                  "Correlation strength (Taxa2 → Taxa4):",
                  min = 0, 
                  max = 1, 
                  value = 0,
                  step = 0.1),
      
      # Base abundance controls
      sliderInput("lambda1", 
                  "Base abundance Taxa1:",
                  min = 100, 
                  max = 2000, 
                  value = 1000),
      
      sliderInput("lambda2", 
                  "Base abundance Taxa2:",
                  min = 100, 
                  max = 2000, 
                  value = 800),
      
      sliderInput("lambda3", 
                  "Base abundance Taxa3:",
                  min = 100, 
                  max = 2000, 
                  value = 500),
      
      sliderInput("lambda4", 
                  "Base abundance Taxa4:",
                  min = 100, 
                  max = 2000, 
                  value = 1200),
      
      # Add noise level control
      sliderInput("noise_level",
                  "Noise level:",
                  min = 0.1,
                  max = 1,
                  value = 0.3,
                  step = 0.1),
      
      actionButton("regenerate", "Regenerate Data"),
      
      # Add explanatory text
      helpText("Adjust the parameters to see how true correlations in absolute abundances",
               "translate into different correlation patterns in relative abundances.",
               "The noise level affects how much random variation is added to the correlations.")
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Correlation Plots",
                 plotOutput("correlationPlots", height = "800px")),
        tabPanel("Scatter Plots",
                 selectInput("xvar", "X variable:", ""),
                 selectInput("yvar", "Y variable:", ""),
                 plotOutput("scatterPlots", height = "600px")),
        tabPanel("Summary Statistics",
                 verbatimTextOutput("correlationStats"))
      )
    )
  )
)

server <- function(input, output, session) {
  # Reactive values for data storage
  rv <- reactiveValues(data = NULL)
  
  # Function to generate data
  generate_data <- function() {
    set.seed(sample.int(1000, 1))  # Random seed for variety
    n <- input$n_samples
    
    # Generate base independent counts
    taxa1 <- rpois(n, lambda = input$lambda1)
    taxa2 <- rpois(n, lambda = input$lambda2)
    
    # Add correlated taxa with noise
    taxa3 <- taxa1 * input$cor_strength1 + 
      rpois(n, lambda = input$lambda3 * input$noise_level)
    taxa4 <- taxa2 * input$cor_strength2 + 
      rpois(n, lambda = input$lambda4 * input$noise_level)
    
    # Combine into a data frame
    counts_df <- data.frame(
      Sample = 1:n,
      Taxa1 = taxa1,
      Taxa2 = taxa2,
      Taxa3 = taxa3,
      Taxa4 = taxa4
    )
    
    # Calculate relative abundances
    rel_abundances <- counts_df %>%
      pivot_longer(cols = starts_with("Taxa"), 
                   names_to = "Taxa", 
                   values_to = "Count") %>%
      group_by(Sample) %>%
      mutate(RelativeAbundance = Count / sum(Count)) %>%
      ungroup() %>%
      pivot_wider(id_cols = Sample,
                  names_from = Taxa,
                  values_from = RelativeAbundance,
                  names_prefix = "Rel_")
    
    # Combine absolute and relative abundances
    combined_df <- counts_df %>%
      select(-Sample) %>%
      bind_cols(rel_abundances %>% select(-Sample))
    
    return(combined_df)
  }
  
  # Update data when parameters change or regenerate button is clicked
  observeEvent(input$regenerate, {
    rv$data <- generate_data()
  })
  
  # Initialize data and update variable choices
  observe({
    if (is.null(rv$data)) {
      rv$data <- generate_data()
    }
    
    # Update variable choices for scatter plots
    vars <- names(rv$data)
    updateSelectInput(session, "xvar", choices = vars)
    updateSelectInput(session, "yvar", choices = vars, selected = vars[2])
  })
  
  # Create correlation plots
  output$correlationPlots <- renderPlot({
    req(rv$data)
    
    # Absolute correlations
    abs_cors <- rv$data %>%
      select(Taxa1:Taxa4) %>%
      ggcorr(method = c("everything", "pearson"), 
             label = TRUE, 
             label_round = 2) +
      ggtitle("Correlations in Absolute Abundances")
    
    # Relative correlations
    rel_cors <- rv$data %>%
      select(starts_with("Rel_")) %>%
      ggcorr(method = c("everything", "pearson"), 
             label = TRUE, 
             label_round = 2) +
      ggtitle("Correlations in Relative Abundances")
    
    # Combine plots
    abs_cors + rel_cors
  })
  
  # Create scatter plots
  output$scatterPlots <- renderPlot({
    req(rv$data, input$xvar, input$yvar)
    
    ggplot(rv$data, aes(x = .data[[input$xvar]], y = .data[[input$yvar]])) +
      geom_point(alpha = 0.6) +
      geom_smooth(method = "lm", se = FALSE, color = "red") +
      theme_minimal() +
      labs(title = paste(input$xvar, "vs", input$yvar),
           subtitle = paste("Correlation:", 
                            round(cor(rv$data[[input$xvar]], 
                                      rv$data[[input$yvar]]), 3)))
  })
  
  # Display correlation statistics
  output$correlationStats <- renderPrint({
    req(rv$data)
    
    cat("Summary Statistics:\n\n")
    
    cat("1. Correlations in Absolute Abundances:\n")
    print(round(cor(rv$data %>% select(Taxa1:Taxa4)), 3))
    
    cat("\n2. Correlations in Relative Abundances:\n")
    print(round(cor(rv$data %>% select(starts_with("Rel_"))), 3))
    
    cat("\n3. Summary of Counts:\n")
    print(summary(rv$data %>% select(Taxa1:Taxa4)))
  })
}

shinyApp(ui = ui, server = server)