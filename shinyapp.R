# install and load libraries
library(shiny)

# let's source cheese.R for the plots
source("cheese.R") 

# i want to make an app so that a user can easily look at each plot!
ui <- fluidPage(
  titlePanel("Let's explore cheese data!"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "plot_choice",
        label = "Choose a plot to display:",
        choices = c(
          "Top Cheesy Countries" = "plot1",
          "Top Cheesy US States" = "plot2",
          "Milk Types by Country" = "plot3",
          "Cheese Types across Cheesy Countries" = "plot4",
          "Fat Content by Cheese Type" = "plot5",
          "Fat Content by Cheese Family" = "plot6"
        )
      )
    ),
    
    mainPanel(
      plotOutput("cheese_plot", height = "700px")
    )
  )
)

server <- function(input, output, session) {
  
  output$cheese_plot <- renderPlot({
    if(input$plot_choice == "plot1") {
      plot1
    } else if(input$plot_choice == "plot2") {
      plot2
    } else if(input$plot_choice == "plot3") {
      plot3
    } else if(input$plot_choice == "plot4") {
      plot4
    } else if(input$plot_choice == "plot5") {
      plot5
    } else if(input$plot_choice == "plot6") {
      plot6
    }
  })
}

shinyApp(ui, server)
