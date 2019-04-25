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
      plotOutput("trend",
        brush = brushOpts("brush", direction = "x", resetOnNew = TRUE),
        dblclick = "click"
      ),
      HTML(
        "<p>Data from <a href='http://r-hub.github.io/cranlogs/'>cranlogs</a>.",
        "Code on <a href='https://github.com/hadley/cran-downloads'>github</a>.</p>"
      )
    )
  )
))
