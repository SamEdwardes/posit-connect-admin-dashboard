box::use(
  shiny[div, moduleServer, NS, renderUI, tags, uiOutput],
  bslib[page_navbar, nav_panel],
  rhino[rhinos],
)
box::use(
  app/view/index,
  app/view/users,
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  page_navbar(
    title = "Connect Admin Dashboard",
    nav_panel(
      "Home",
      index$ui(ns("index")),
    ),
    nav_panel(
      "Users",
      users$ui(ns("users"))
    )
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    data <- rhinos
    
    index$server("index")
    users$server("users")
  })
}
