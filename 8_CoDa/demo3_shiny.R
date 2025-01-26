library(shiny)
library(tidyverse)
library(compositions)
library(DT)
library(patchwork)

ui <- fluidPage(
  titlePanel("Log-ratio Transformations in Compositional Data"),
  
  sidebarLayout(
    sidebarPanel(
      # File upload
      fileInput("file", "Upload CSV file",
                accept = c("text/csv",
                           "text/comma-separated-values,text/plain",
                           ".csv")),
      
      # Or use example data
      actionButton("use_example", "Use Example Data"),
      
      hr(),
      
      # Reference taxon for ALR
      uiOutput("reference_selector"),
      
      hr(),
      
      # Show zero handling options
      selectInput("zero_method", "Zero handling method:",
                  choices = c("Add pseudocount" = "pseudo",
                              "Multiplicative replacement" = "multi"),
                  selected = "pseudo"),
      
      # Pseudocount value if that method is selected
      conditionalPanel(
        condition = "input.zero_method == 'pseudo'",
        numericInput("pseudocount", "Pseudocount value:",
                     value = 0.5, min = 0.000001, max = 1, step = 0.1)
      ),
      
      hr(),
      
      # Explanatory text
      helpText(
        h4("About the transformations:"),
        tags$ul(
          tags$li("TSS: Total Sum Scaling (relative abundances)"),
          tags$li("CLR: Centered Log-Ratio"),
          tags$li("ALR: Additive Log-Ratio (needs reference)"),
          tags$li("ILR: Isometric Log-Ratio")
        )
      )
    ),
    
    mainPanel(
      tabsetPanel(
        # Raw data tab
        tabPanel("Raw Data",
                 DTOutput("raw_table")),
        
        # Transformed data tabs
        tabPanel("TSS",
                 DTOutput("tss_table")),
        tabPanel("CLR",
                 DTOutput("clr_table")),
        tabPanel("ALR",
                 DTOutput("alr_table")),
        tabPanel("ILR",
                 DTOutput("ilr_table")),
        
        # Visualization tab
        tabPanel("Visualizations",
                 selectInput("viz_samples", "Select samples to compare:",
                             choices = NULL, multiple = TRUE),
                 plotOutput("comparison_plot", height = "800px"))
      )
    )
  )
)

server <- function(input, output, session) {
  # Reactive value to store the data
  rv <- reactiveValues(data = NULL)
  
  # Load example data
  observeEvent(input$use_example, {
    rv$data <- data.frame(
      Sample = paste0("Sample", 1:5),
      Bacteroides = c(1000, 1500, 800, 1200, 900),
      Prevotella = c(2000, 1800, 2500, 1900, 2200),
      Faecalibacterium = c(1500, 1200, 1000, 1400, 1600),
      Ruminococcus = c(800, 1000, 700, 900, 850)
    )
  })
  
  # Load user data
  observeEvent(input$file, {
    rv$data <- read.csv(input$file$datapath, row.names = 1)
  })
  
  # Update reference selector based on available taxa
  output$reference_selector <- renderUI({
    req(rv$data)
    taxa_names <- colnames(rv$data)[colnames(rv$data) != "Sample"]
    selectInput("reference_taxon", "Reference taxon for ALR:",
                choices = taxa_names,
                selected = taxa_names[1])
  })
  
  # Update sample selector for visualizations
  observe({
    req(rv$data)
    updateSelectInput(session, "viz_samples",
                      choices = rv$data$Sample,
                      selected = rv$data$Sample[1:2])
  })
  
  # Function to handle zeros based on selected method
  handle_zeros <- function(data) {
    if (input$zero_method == "pseudo") {
      data + input$pseudocount
    } else {
      # Multiplicative replacement using zCompositions package
      # Note: This is a simplified version
      data[data == 0] <- min(data[data > 0]) / 2
      data
    }
  }
  
  # Calculate transformations
  transformations <- reactive({
    req(rv$data)
    
    # Get numerical columns only
    num_data <- rv$data %>% select(-Sample)
    
    # Handle zeros
    num_data <- handle_zeros(num_data)
    
    # TSS transformation
    tss <- sweep(num_data, 1, rowSums(num_data), "/")
    
    # CLR transformation
    clr <- t(apply(num_data, 1, function(x) log(x) - mean(log(x))))
    
    # ALR transformation
    req(input$reference_taxon)
    ref_col <- which(colnames(num_data) == input$reference_taxon)
    alr <- log(sweep(num_data[,-ref_col], 1, num_data[,ref_col], "/"))
    
    # ILR transformation
    ilr <- ilr(num_data)
    
    list(
      raw = num_data,
      tss = tss,
      clr = clr,
      alr = alr,
      ilr = ilr
    )
  })
  
  # Render tables
  output$raw_table <- renderDT({
    req(rv$data)
    datatable(rv$data, options = list(scrollX = TRUE))
  })
  
  output$tss_table <- renderDT({
    req(transformations())
    datatable(cbind(Sample = rv$data$Sample, 
                    as.data.frame(transformations()$tss)),
              options = list(scrollX = TRUE))
  })
  
  output$clr_table <- renderDT({
    req(transformations())
    datatable(cbind(Sample = rv$data$Sample,
                    as.data.frame(transformations()$clr)),
              options = list(scrollX = TRUE))
  })
  
  output$alr_table <- renderDT({
    req(transformations())
    datatable(cbind(Sample = rv$data$Sample,
                    as.data.frame(transformations()$alr)),
              options = list(scrollX = TRUE))
  })
  
  output$ilr_table <- renderDT({
    req(transformations())
    datatable(cbind(Sample = rv$data$Sample,
                    as.data.frame(transformations()$ilr)),
              options = list(scrollX = TRUE))
  })
  
  # Create comparison plots
  output$comparison_plot <- renderPlot({
    req(transformations(), input$viz_samples)
    
    # Get the data for selected samples
    selected_samples <- which(rv$data$Sample %in% input$viz_samples)
    
    # Function to create comparison plot
    create_comparison_plot <- function(data, title) {
      data_long <- as.data.frame(data[selected_samples,]) %>%
        mutate(Sample = rv$data$Sample[selected_samples]) %>%
        pivot_longer(-Sample, names_to = "Taxa", values_to = "Value")
      
      ggplot(data_long, aes(x = Taxa, y = Value, fill = Sample)) +
        geom_bar(stat = "identity", position = "dodge") +
        theme_minimal() +
        theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
        ggtitle(title)
    }
    
    # Create plots for each transformation
    p1 <- create_comparison_plot(transformations()$raw, "Raw Counts")
    p2 <- create_comparison_plot(transformations()$tss, "TSS")
    p3 <- create_comparison_plot(transformations()$clr, "CLR")
    p4 <- create_comparison_plot(transformations()$alr, "ALR")
    
    # Arrange plots
    (p1 + p2) / (p3 + p4)
  })
}

shinyApp(ui = ui, server = server)