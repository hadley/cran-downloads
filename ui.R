library(shiny)

top5 <- cranlogs::cran_top_downloads(count = 5)$package
today <- Sys.Date() - 1
last_month <- today - 60

shinyUI(fluidPage(
  titlePanel("CRAN downloads"),

  sidebarLayout(
    sidebarPanel(
      textInput("packages", "Packages", paste(top5, collapse = ", ")),
      dateRangeInput("range", "Dates", last_month, today),
      checkboxInput("showTrend", "Show trend")
    ),

    mainPanel(
      plotOutput("trend"),
      HTML(
        "<p>Data from <a href='https://github.com/metacran/cranlogs'>cranlogs</a>.",
        "Code on <a href='https://github.com/hadley/cran-downloads'>github</a>.</p>"
      )
    )
  )
))
