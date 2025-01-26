library(shiny)
library(tidyverse)
library(patchwork)

ui <- fluidPage(
  titlePanel("Exploring Absolute vs Relative Abundances in Microbiome Data"),
  
  sidebarLayout(
    sidebarPanel(
      # Sample 1 inputs
      h4("Sample 1 Abundances"),
      numericInput("bacteroides1", "Bacteroides:", value = 1000, min = 0),
      numericInput("prevotella1", "Prevotella:", value = 2000, min = 0),
      numericInput("faecali1", "Faecalibacterium:", value = 1000, min = 0),
      
      # Sample 2 inputs
      h4("Sample 2 Abundances"),
      numericInput("bacteroides2", "Bacteroides:", value = 2000, min = 0),
      numericInput("prevotella2", "Prevotella:", value = 4000, min = 0),
      numericInput("faecali2", "Faecalibacterium:", value = 2000, min = 0),
      
      # Add preset scenarios
      selectInput("preset", "Load Preset Scenario:",
                  choices = c("Custom",
                              "1. Same Proportions, Different Scales",
                              "2. Impact of One Taxa Increase",
                              "3. Spurious Correlation")),
      
      # Add explanatory text
      helpText("Modify the absolute abundances and observe how they affect (or don't affect) the relative abundances."),
      
      # Add total counts display
      verbatimTextOutput("totalCounts")
    ),
    
    mainPanel(
      plotOutput("abundancePlots", height = "600px"),
      verbatimTextOutput("proportions")
    )
  )
)

server <- function(input, output, session) {
  
  # Reactive expression for the dataset
  getData <- reactive({
    # Update values based on preset scenarios
    if (input$preset != "Custom") {
      if (input$preset == "1. Same Proportions, Different Scales") {
        # Sample 1: Base values
        updateNumericInput(session, "bacteroides1", value = 1000)
        updateNumericInput(session, "prevotella1", value = 2000)
        updateNumericInput(session, "faecali1", value = 1000)
        # Sample 2: All values multiplied by 5
        updateNumericInput(session, "bacteroides2", value = 5000)
        updateNumericInput(session, "prevotella2", value = 10000)
        updateNumericInput(session, "faecali2", value = 5000)
      } else if (input$preset == "2. Impact of Taxa Increased") {
        # Sample 1: Base values
        updateNumericInput(session, "bacteroides1", value = 1000)
        updateNumericInput(session, "prevotella1", value = 2000)
        updateNumericInput(session, "faecali1", value = 1000)
        # Sample 2: Prevotella doubles, others stay same
        updateNumericInput(session, "bacteroides2", value = 1000)
        updateNumericInput(session, "prevotella2", value = 4000)
        updateNumericInput(session, "faecali2", value = 1000)
      } else if (input$preset == "3. Impact of Taxa Decrease") {
        # Sample 1: Base values
        updateNumericInput(session, "bacteroides1", value = 1000)
        updateNumericInput(session, "prevotella1", value = 2000)
        updateNumericInput(session, "faecali1", value = 1000)
        # Sample 2: Two taxa decrease, one stays same
        updateNumericInput(session, "bacteroides2", value = 200)
        updateNumericInput(session, "prevotella2", value = 400)
        updateNumericInput(session, "faecali2", value = 1000)
      }
    }
    
    data.frame(
      Sample = rep(c("Sample1", "Sample2"), each = 3),
      Taxa = rep(c("Bacteroides", "Prevotella", "Faecalibacterium"), 2),
      Counts = c(input$bacteroides1, input$prevotella1, input$faecali1,
                 input$bacteroides2, input$prevotella2, input$faecali2)
    )
  })
  
  # Create the plots
  output$abundancePlots <- renderPlot({
    req(getData())
    data <- getData()
    
    # Calculate relative abundances
    data_rel <- data %>%
      group_by(Sample) %>%
      mutate(RelativeAbundance = Counts/sum(Counts) * 100)
    
    # Absolute abundance plot
    abs_plot <- ggplot(data, aes(x = Sample, y = Counts, fill = Taxa)) +
      geom_col(position = "stack") +
      theme_minimal() +
      labs(title = "Absolute Abundances",
           y = "Counts") +
      scale_fill_brewer(palette = "Set2")
    
    # Relative abundance plot
    rel_plot <- ggplot(data_rel, aes(x = Sample, y = RelativeAbundance, fill = Taxa)) +
      geom_col(position = "stack") +
      theme_minimal() +
      labs(title = "Relative Abundances",
           y = "Relative Abundance (%)") +
      scale_fill_brewer(palette = "Set2")
    
    # Combine plots
    abs_plot + rel_plot
  })
  
  # Display total counts
  output$totalCounts <- renderText({
    data <- getData()
    totals <- data %>%
      group_by(Sample) %>%
      summarise(Total = sum(Counts))
    
    paste("Total counts:",
          "\nSample 1:", format(totals$Total[1], big.mark = ","),
          "\nSample 2:", format(totals$Total[2], big.mark = ","))
  })
  
  # Display proportions
  output$proportions <- renderText({
    data <- getData()
    props <- data %>%
      group_by(Sample) %>%
      mutate(Proportion = Counts/sum(Counts) * 100) %>%
      select(Sample, Taxa, Proportion)
    
    paste("Relative Abundances (%):\n\n",
          paste(capture.output(print(props)), collapse = "\n"))
  })
}

shinyApp(ui = ui, server = server)