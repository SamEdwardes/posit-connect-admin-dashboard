# app/view/content

box::use(
  shiny[tags, moduleServer, NS],
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  
  tags$div(
    tags$h2("Content"),
    tags$p("Content Page"),
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    print("Content page module server part works!")
  })
}