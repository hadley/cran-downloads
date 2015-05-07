library(shiny)

top5 <- cranlogs::cran_top_downloads(count = 5)$package
today <- Sys.Date() - 1
last_month <- today - 30

shinyUI(fluidPage(
  titlePanel("CRAN downloads"),

  sidebarLayout(
    sidebarPanel(
      textInput("packages", "Packages", paste(top5, collapse = ", ")),
      dateInput("from", "From", last_month),
      dateInput("to", "To", today)
    ),

    mainPanel(
      plotOutput("trend")
    )
  )
))
