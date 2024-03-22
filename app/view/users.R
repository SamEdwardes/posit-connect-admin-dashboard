# app/view/users

box::use(
  shiny[h3, moduleServer, NS, p, tagList],
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    h3("Users"),
    p("This is the users page")
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    print("Users module server part works!")
  })
}