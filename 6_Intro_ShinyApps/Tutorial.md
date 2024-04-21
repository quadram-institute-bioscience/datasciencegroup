# Ramen Rating Shiny App tutorial

This tutorial will show you step by step how to create the Ramen Rating Shiny App, cover the architecture and the main basic functions available in Shiny. This is not an exhaustive view on what is possible through Shiny App, but rather a first step to create your own more complex apps.

# SETUP
You should already have cloned this repository on your local computer, but if it is not yet the case, do it now!

To start this tutorial, create a new empty script in RStudio and save it in a separate folder in your computer. Make sure to call that script "App.R".
In the same folder copy the ramen picture, the ramen dataset and the footer.html file (these files are all available in this tutorial folder).

## Create the minimal functioning App

In your App.R script, copy and paste the minimal functioning app below:


```R
library(shiny)

ui <- fluidPage()

server <- function(input, output) {}

shinyApp(ui = ui, server = server)

```

Save the script. You can then run this app. This will open a blank page! (but won't throw any error, so that's good!)

## Understand the UI function

First, we'll take a look at the UI function. This function contains all that you want to display to the user.

In the code above, you see that we are using the function "fluidPage()" to create a blank web page. Inside this page we'll place all elements we want to display.

FluidPage is one of the available page layout accessible through Shiny. Other layout can be used. In particular, I tend to use a lot the navPage() layout, which build a nevigation bar and tabs. The apparence of these layouts can be changed using the "theme" parameter.

### Adding HTML elements to the UI

Now that we have a global layout, the fluidPage, let's add HTML elements such as a title, a description and a picture. 

Shiny has tags that allows to easily add to the app the main elements you can find in an HTML page:

| Shiny function        | desc           | HTML  |
| ------------- |:-------------:| -----:|
| p()      | text | ``` <p> ``` |
| h1()...h6()     | header      |  ``` <h1>...<h6> ``` |
| a() | Link      |   ``` <a> ```|
| br() | break      |   ``` <br> ```|
| div() | Link      |   ``` <div> ``` |
| span() | in-line division of text      |   ``` <span> ```|
| img() | image      |   ``` <img> ```|
| strong() | bold text      |   ``` <strong> ```|
| em() | italicized text      |  ```  <em> ```|
| img() | image      |   ``` <img> ```|
| code() | block of code      |   ``` <code> ```|

 	
Let's add to our app a title and some descriptive text in the first tab:

```R
ui <- fluidPage( 
                # ----------------------------------
                h1("Best Ramens in the world", align = "center"),
                p("Explore the best ramens in the world, recommended by the users themselves! In this tab, you can 
                select your favorite ramen style and the country of fabrication. The table below display the best three 
                ramens for this selection!")
                # ----------------------------------

) # end fluidpage panel
```

Note that the elements in the fluidPage should be listed using commas. Rstudio will complain if you forget them!

When you run the app you should now see on the page the title and text we added.

Next, we want to add a picture. Download the picture from the github repo. Create a folder called 'www' in the same directory as your app. Place the picture in that folder, so the app knows where to look for the picture.
Here is the code to add a picture and center it to the page.

```R
ui <- fluidPage( 
                # ----------------------------------
                h1("Best Ramens in the world", align = "center"),
                p("Explore the best ramens in the world, recommended by the users themselves! In this tab, you can 
                select your favorite ramen style and the country of fabrication. The table below display the best three 
                ramens for this selection!"),
                HTML('<center><img src="1200px-Shoyu_Ramen.jpg" width="100%"></center>'),
                br()
                # ----------------------------------

) # end fluidpage panel

```
In this exemple, we are adding directly HTML code using the function (but we could have used the image() tag too): 

```R
HTML()
```
Run the app. Note that the app is reactive to the size of the window! When you resize the window, the app will resize the elements automatically for a better display of your app on different screen sizes.

### Adding a HTML code from another file

It is also possible to directly include HTML code from another document directly into your app using the function:

```R
includeHTML()
```

As an exemple, we'll add a footer saved in a separate HTML file. Download the footer.html fine into your app directory. 
Let's link it in the App and specify that it is our footer.

```R
ui <- fluidPage(
                # ----------------------------------
                h1("Best Ramens in the world", align = "center"),
                p("Explore the best ramens in the world, recommended by the users themselves! In this tab, you can 
                select your favorite ramen style and the country of fabrication. The table below display the best three 
                ramens for this selection!"),
                HTML('<center><img src="1200px-Shoyu_Ramen.jpg" width="100%"></center>'),
                br(),
                # ----------------------------------

                # ----------------------------------
                includeHTML("footer.html")
) # end fluidpage panel
```

### Using Shiny Layouts to organize your App

Shiny includes a number of facilities for laying out the components of an application. These layouts are meant to help you to organize content in your page.
A very popular layout is the sidebar layout. It allows to separate your page into a sidebar and a main panel. Let's use this layout for our app.

```R
ui <- fluidPage(
                # ----------------------------------
                h1("Best Ramens in the world", align = "center"),
                p("Explore the best ramens in the world, recommended by the users themselves! In this tab, you can 
                select your favorite ramen style and the country of fabrication. The table below display the best three 
                ramens for this selection!"),
                HTML('<center><img src="1200px-Shoyu_Ramen.jpg" width="100%"></center>'),
                br(),
                # ----------------------------------
                sidebarLayout(fluid=TRUE,
                              sidebarPanel(
                                h3("side bar")
                                
                              ),
                              mainPanel(
                                h3("main panel")
                              ), # end main panel
                ),
                # ----------------------------------
                includeHTML("footer.html")
) # end fluidpage
```

Other layouts can be explored (here)[https://shiny.rstudio.com/articles/layout-guide.html]

### Importing Data into the App

For most apps, you'll want to be able to use and display your own dataset. To do so, you can simply import your dataset before declaring the ui.
For our Ramen App, you'll need to download the dataset here. Place it in the same folder as your app.

To be able to manipulate our dataset, we'll import the complete tidyverse library.

```R
library(shiny)
library(tidyverse)


# load ramen Ratings dataset
ramen_ratings <- readr::read_csv("ramen_dataset.csv")
```

### Adding widgets for user inputs

So far, we have added non-reactive elements to our app. Let's now focus on adding some user imputs. In Shiny Apps, widgets allows to create a varieaty of user inputs. The complete gallery of widget is available in the [widget gallery]("https://shiny.rstudio.com/gallery/widget-gallery.html")

For our Ramen App, let's add a first drop down menu to select the ramen style (Cup, Bowl and Pack).

```R
selectInput("style", label="Select the ramen style:",
            c("Pack","Bowl","Cup" ), 
            selected = "Cup",
            multiple= TRUE)
```

Each widget function requires several arguments. The first two arguments for each widget are

  - a name: The name will not be shown on the sceen, but is necessary to access the widget’s value.

  - a label: This label will appear with the widget in your app.

The remaining arguments vary from widget to widget, depending on what the widget needs to do its job. You can find the exact arguments needed by a widget on the widget function’s help page, (e.g., ?selectInput).

Let's place this first widget in the sidebar of our page:

```R
ui <- fluidPage(
                # ----------------------------------
                h1("Best Ramens in the world", align = "center"),
                p("Explore the best ramens in the world, recommended by the users themselves! In this tab, you can 
                select your favorite ramen style and the country of fabrication. The table below display the best three 
                ramens for this selection!"),
                HTML('<center><img src="1200px-Shoyu_Ramen.jpg" width="100%"></center>'),
                br(),
                # ----------------------------------
                sidebarLayout(fluid=TRUE,
                              sidebarPanel(
                                selectInput("style", label="Select the ramen style:",
                                            c("Pack","Bowl","Cup" ), 
                                            selected = "Cup",
                                            multiple= TRUE),
                              ),
                              mainPanel(
                                h3("main panel")
                              ), # end main panel
                ),
                # ----------------------------------
                includeHTML("footer.html")
) # end fluidpage
```
When you run the app, you should now see your widget, allowing to select the style of the Ramen.

We want a second dropdown menu to be added for the user to be able to select the country of fabrication. Because the list of country needs to be addapted to the dataset (and because we don't want to have to type all the countries names). We'll create that list directly from the dataset before the ui.

```R
# get list of countries in dataset
country_list<- ramen_ratings %>% select(country) %>% unique()
```

Then we can use directly this list in the second drop down menu. Note that for this drop down menu, we don't want to enable the multiple selection.

```R
selectInput("country", label="Select the country of fabrication:",
                    country_list, 
                    selected = "Japan",
                    multiple= FALSE)
```

Finally, we also want two radio buttons to choose the plot view.

```R
radioButtons("pType", label="Choose View:",
             list("Barchart", "Boxplot"))
```

All in all, the complete code we have so far should look like this:

```R
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
          h3("main panel")
        ), # end main panel
  ),
  # ----------------------------------
  includeHTML("footer.html")
) # end NavPage panel


server <- function(input, output) {}

shinyApp(ui = ui, server = server)
```

Good job! you now have your UI set up!


## The server function

### Understanding the interplay between UI and server function

Up until now we have been using an empty server function:

```R
server <- function(input, output) {
}
```
In the server function happens all computing tasks that are required to modify the display in reaction to user input. 
Let's first add a title in the main Panel of our app, that reacts to the selected country: 

"Best ramens in XXX"

So in the server function, we want to create an object that will store our title and that will be updated whenever the country input is modified. 

You can create these objects by defining a new element for output within the server function, here we call it ``` output$toptitle```. Each output should contain one of Shiny’s render* functions. 

| render function        | Creates    | 
| ------------- |:-------------:| 
| renderDataTable()      | DataTable |
| renderImage()     | image      |
| renderPlot() | plot      |
| renderTable() | Table      |
| renderText() | text      |

In the server function, we add a renderText() element, that combine "Best ramens in " and the name of the country chosen by the user. To access this country name, we can use the input variable list, in which the different widget names can be directly accessed. 

In our exemple, the country name can be accessed using the input$country variable.

```R
server <- function(input, output) {
  # Title main area
  # ----------------------------------
  output$toptitle <- renderText({
    paste("Best ramens in ", input$country)
  })
}
```

We now want to display this title in the main area of our page. To do so, we need to use Outputs functions from Shiny. There are a lot of different output functions, allowing you to output text, plots, images, tables... 

Shiny provides a family of functions that turn R objects into output for your user interface. Each function creates a specific type of output.

| Shiny function        | Creates    | 
| ------------- |:-------------:| 
| dataTableOutput()      | DataTable |
| imageOutput()     | image      |
| plotOutput() | plot      |
| tableOutput() | Table      |
| textOutput() | text      |

Here we need to render a Text element, so we'll use the textOutput(). You can add output to the user interface in the same way that you added HTML elements and widgets.

Let's add this output in the main area of of ui.

```R
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
          textOutput("toptitle")
        ), # end main panel
  ),
  # ----------------------------------
  includeHTML("footer.html"),
) # end NavPage panel


server <- function(input, output) {
  # Title main area
  # ----------------------------------
  output$toptitle <- renderText({
    paste("Best ramens in ", input$country)
  })
}

shinyApp(ui = ui, server = server)
```

It is possible to add an HTML formating on the text output elements:

```R
h3(textOutput("toptitle"), align = "left")
```

If you now run your app, you should see a reactive title, changing each time the country input variable is changed.

### Adding a tables and plots

Similarly, it is possible to create tables and plot output using renderTable() and renderPlot() function in the server. Let's create a table and two plots. Let's add in the server :

```R
server <- function(input, output) {

  # Title main area
  # ----------------------------------
  output$toptitle <- renderText({
    paste("Best ramens in ", input$country)
  })
  
  # ----------------------------------
  # Table output
  output$top3 <- renderTable({
    display_dataset <- ramen_ratings %>% filter(style %in% input$style & country == input$country)
    display_dataset %>% slice_max(tibble(stars,review_number), n=3, with_ties=FALSE) %>% select(-continent) %>%
      rename("number of reviews"="review_number")
  })
  
  # ----------------------------------
  # Plot outputs
  output$barplot <- renderPlot({ 
    display_dataset <- ramen_ratings %>% filter(style %in% input$style & country == input$country)

    display_dataset %>%  ggplot(aes(x=stars, fill=style)) +
      geom_histogram(color="black",binwidth = 1)+
      scale_x_continuous(breaks = c(0, 1, 2, 3, 4, 5), limits = c(-1,6))+
      ggtitle("Ramens Ratings") +
      ylab("Number of Ramens")+
      xlab("Average Ratings")+
      theme_minimal(base_size = 13)
  })
  
  output$boxplot <- renderPlot({  
    display_dataset <- ramen_ratings %>% filter(style %in% input$style & country == input$country)

    display_dataset %>% ggplot(aes(x=style, y=stars, color=style)) +
      geom_boxplot() +
      ggtitle("Ramens Ratings") +
      ylab("Average Ratings") +
      xlab("Style of Ramen") +
      theme_minimal(base_size = 13)
  })
  
}
```

If you're familiar with TidyR and ggplot2 these elements should be pretty straightforward to understand. Now let's add the table and plots in the ui function to display them.

```R
        mainPanel(
          h3(textOutput("toptitle"), align = "left"),
          tableOutput("top3"),
          plotOutput("barplot"),
          plotOutput("boxplot"),
        ), # end main panel
```

Run the app to see how these elements are displayed and react to user inputs.

### Reactive elements

If you look closely to the server function, you see that there is some code repetition. In particular, the filtering and selection of the dataset to use for the table and plots is reapeated in each of them. To avoid this, improve readability and avoid any issues, we'll use a reactive element to store this selection.

A reactive expression uses a widget input and returns a value. Reactive elements will be updated whenever one of more input they use is changed. 

Here, let's define a reactive value called display_dataset that store the subset of data that we use for our plots and table.


```R
# ----------------------------------
# Reactive elements
display_dataset <- reactive({
  ramen_ratings %>% filter(style %in% input$style & country == input$country)
})
```

This reactive element can then be used in the renderTable and renderPlot functions as a regular dataset. However, when calling a reactive element, you need to add parenthesis after the element name. In our case display_dataset().

```R
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
    display_dataset() %>% slice_max(tibble(stars,review_number), n=3, with_ties=FALSE) %>% select(-continent) %>%
      rename("number of reviews"="review_number")
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
```
When running the app, you should see that the ui apparence did not change and that the interactions are similar as the previous step.

### Conditional panels

Finally, we want to be able to hide the box_plot or the barplot when the user click on the radio buttons. To do so, we can use conditionalPanel() function. This function takes the condition that allows the display of the panel, and the output you want to include. In our case we want the plotOutput("barplot") to be only visible when the radio button 'Barchart' is clicked and the plotOutput("boxplot") visible when the 'Boxplot' button is clicked.

```R
        mainPanel(
          h3(textOutput("toptitle"), align = "left"),
          tableOutput("top3"),
          conditionalPanel('input.pType=="Barchart"', plotOutput("barplot")),
          conditionalPanel('input.pType=="Boxplot"',plotOutput("boxplot")),
        ), # end main panel
```
Run the app to see how these conditional panel react to user input.

### BONUS: Events and action buttons

Another type of widgets available through Shiny are action buttons. They are used in the server function through observeEvent and eventReactive functions.

To create an action button in shiny you can use the actionButton() function. This takes two arguments: 
    - inputId - the ID of the button or link
    - label - the label to display in the button or link

Let's add a "search" button to the ui.

```R
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
                     list("Barchart", "Boxplot")),

        actionButton("go", "Search")
        
        ),
```

Action buttons are a bit different from other shiny widgets because the value of an action button is not meaningful by itself. The click on the button is meant to be observed by one of observeEvent() or eventReactive(). These functions monitor the value, and when it changes they run a block of code.

First, let's see eventReactive(). This function is quite similar to reactive(), as it creates a reactive expression. But this reactive expression monitors an event, and will only be updated when this event occurs. Here we want the app to update the display_dataset reactive expression only when the button is clicked. To do so, we'll modify the reactive() function into eventReactive().

```R
  display_dataset <- eventReactive(input$go,{
    ramen_ratings %>% filter(style %in% input$style & country == input$country)
  })
```
If you run the app, you'll see that the plots and tables only reacts to the button being clicked. Note that no plots or table will be displayed before the user clicks the button for the first time. However, the title is still appearing and changing whenever the user changes the country name.

To avoid this behaviour, we'll also isolate the input$country in an eventReactive() block, and then use this eventReactive element in the renderText() function:

```R
  ntext <- eventReactive(input$go, {
    input$country
  })
  
  output$toptitle <- renderText({
    paste("Best ramens in ", ntext())
  })
```

Because it is quite weird to see an empty app upon loading, you can change the behavior of eventReactive upon loading. To do so, you need to add a ignoreNULL=FALSE parameter in the eventReactive function. This parameter controls whether the value should be calculated, when the input$go is 0 (which is the value of the action button upon loading the app).

```R
  # Title main area
  # ----------------------------------
  ntext <- eventReactive(input$go, {
    input$country
  }, ignoreNULL = FALSE)
  
  output$toptitle <- renderText({
    paste("Best ramens in ", ntext())
  })
  
  # ----------------------------------
  # Reactive elements
  display_dataset <- eventReactive(input$go,{
    ramen_ratings %>% filter(style %in% input$style & country == input$country)
  }, ignoreNULL = FALSE)
```

Now you have an app that uses a 'search' button! congrats!

Note: Action buttons can also be used in the server with the observeEvent() function. You want to use observeEvent() whenever you need to perform an action in response to an event. (But note that "recalculate a value" does not here count as performing an action-- You want to use an EventReactive() for that!). In observeEvent(), the first argument is the event you want to respond to, and the second argument is a function that should be called whenever the event occurs.

## Deploying your app on Shiny.io

We now have a complete app! 

```R
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
    display_dataset() %>% slice_max(tibble(stars,review_number), n=3, with_ties=FALSE) %>% select(-continent) %>%
      rename("number of reviews"="review_number")
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
```

We want to deploy this app on the shinyapps.io server. 
Go to to the [shinyapps.io](https://www.shinyapps.io/) website and login to your account. A free account allows you to deploy few apps and host them for free. 
Once loged in, you can see your personal dashboard with your hosted apps. You can disabled any apps from this dashboard, view they use....

### Install rsconnect

The rsconnect package allows to deploy shinyapps.io server. You can install it by running the R command in your Rstudio

```R
install.packages('rsconnect')
```

After the rsconnect package has been installed, load it into your R session:

```R
library(rsconnect)
```

Once you set up your account in shinyapps.io, you can configure the rsconnect package to use your account. 

Shinyapps.io generates a token and secret, that the rsconnect package can use to access your account. Retrieve your token from the shinyapps.io dashboard. Tokens are listed under Tokens in the menu at the top right of the shinyapps dashboard (under your avatar).

Click the show button on the token page. A window will pop up that shows the full command to configure your account using the appropriate parameters for the rsconnect::setAccountInfo function. Copy this command to your clip board, and then paste it into the command line of RStudio and click enter.

Once this is done, you can simply deploy your application using the deployApp command.

```R
deployApp()
```

You can also deploy your application by clicking the 'Publish button' while viewing the shiny app!
Once the deployment finishes, your browser should open automatically to your newly deployed application.

Congratulations! You’ve written, debugged and deployed an awesome Ramen Rating app! :-)
