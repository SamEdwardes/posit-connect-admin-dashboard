# app/view/index

box::use(
  shiny[tags, moduleServer, NS],
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  
  tags$div(
    tags$h2("Connect Admin Dashboard"),
    tags$p("Manager your Posit Connect instance with the Connect Admin Dashboard:"),
    tags$ul(
      tags$li("Users"),
    )
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    print("Index module server part works!")
  })
}