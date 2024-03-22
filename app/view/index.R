# app/view/index

box::use(
  shiny[h3, moduleServer, NS, p, tagList],
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    h3("Index"),
    p("This is the index page")
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    print("Index module server part works!")
  })
}