library(cranlogs)
library(ggplot2)
library(shiny)
library(dplyr)


show_trend <- function(df) {
  count_ts <- ts(df$count, frequency = 7)
  stl <- as.data.frame(stl(count_ts, "periodic")$time.series)

  df$trend <- stl$trend
  df$remainder <- stl$remainder
  df
}

shinyServer(function(input, output) {
  pkgs <- reactive(strsplit(input$packages, ", ?")[[1]])
  downloads <- reactive({
    df <- cranlogs::cran_downloads(pkgs(), from = input$from, to = input$to)
    df %>% group_by(package) %>% do(show_trend(.))
  })

  y_range <- reactive(range(downloads()$count, downloads()$trend + downloads()$remainder))

  output$trend <- renderPlot({
    if (!input$showTrend) {
      ggplot(downloads(), aes(date, count, colour = package)) +
        geom_line() +
        geom_point() +
        ylim(y_range())
    } else {
      ggplot(downloads(), aes(date, colour = package)) +
        geom_line(aes(y = trend)) +
        geom_linerange(aes(ymin = trend, ymax = trend + remainder), colour = "grey70") +
        ylim(y_range())
    }
  })

})
