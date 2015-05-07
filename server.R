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
    df <- cranlogs::cran_downloads(pkgs(), from = input$range[1], to = input$range[2])

    last_week <- filter(df, date > max(date) - 7) %>%
      group_by(package) %>%
      summarise(avg = mean(count, na.rm = TRUE)) %>%
      arrange(desc(avg))
    df <- df %>% mutate(package = factor(package, levels = last_week$package))

    df %>% group_by(package) %>% do(show_trend(.))
  })

  y_range <- reactive(range(downloads()$count, downloads()$trend + downloads()$remainder))

  output$trend <- renderPlot({
    if (!input$showTrend) {
      ggplot(downloads(), aes(date, count, colour = package)) +
        geom_line() +
        ylim(y_range()) +
        xlab(NULL) +
        ylab("Daily downloads")
    } else {
      ggplot(downloads(), aes(date, colour = package)) +
        geom_linerange(aes(ymin = trend, ymax = trend + remainder), colour = "grey70") +
        geom_line(aes(y = trend)) +
        ylim(y_range()) +
        xlab(NULL) +
        ylab("Daily downloads (smoothed)")
    }
  })

})
