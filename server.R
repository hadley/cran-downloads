library(cranlogs)
library(ggplot2)
library(shiny)

shinyServer(function(input, output) {
  pkgs <- reactive(strsplit(input$packages, ", ?")[[1]])
  downloads <- reactive({
    cranlogs::cran_downloads(pkgs(), from = input$from, to = input$to)
  })

  output$trend <- renderPlot({
    ggplot(downloads(), aes(date, count, colour = package)) +
      geom_line() +
      geom_point()
  })

})
