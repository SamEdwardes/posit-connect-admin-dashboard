# app/view/users

box::use(
  shiny[tags, moduleServer, NS, textOutput, renderText, invalidateLater, isolate, selectInput, reactive],
  connectapi[connect, get_users],
  bslib[card, card_header, value_box, layout_column_wrap, layout_sidebar, sidebar],
  bsicons[bs_icon],
  reactable[reactableOutput, renderReactable, reactable, colDef],
  scales[comma],
  dplyr[filter, arrange, mutate, group_by, summarise, n],
  apexcharter[apex, renderApexchart, apexchartOutput, aes, ax_labs, ax_tooltip, JS],
  ggplot2[ggplot],
  lubridate[today, days]
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  
  tags$div(
    layout_sidebar(
      fillable = TRUE,
      sidebar = sidebar(
        selectInput(
          ns("user_role_filter"),
          "User Role",
          c("all", "administrator", "publisher", "viewer"),
          selected = "all",
          selectize = TRUE,
        ),
        position = "left"
      ),
      layout_column_wrap(
        value_box(
          title = "Users",
          value = textOutput(ns("number_of_users")),
          showcase = bs_icon("person"),
          tags$p("Number of users who are not locked.")
        ),
        value_box(
          title = "Not active",
          value = textOutput(ns("number_not_active_users")),
          showcase = bs_icon("person-dash"),
          tags$p("Number of users with no activity in the last year.")
        ),
        value_box(
          title = "Locked Users",
          value = textOutput(ns("number_of_locked_users")),
          showcase = bs_icon("person-lock"),
          tags$p("Number of locked users")
        ),
      ),
      card(
        card_header('Last activity'),
        apexchartOutput(ns("last_activity_chart"))
      ),
      card(
        card_header('Users'),
        reactableOutput(ns("users_table"))
      )
      
    )
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    # Query the Connect API to get all of the user data.
    client <- connect()
    
    all_users <- client |> 
      get_users(page_size = 50, limit = 99999)
    
    # Filter the user data
    users <- reactive({
      out <- all_users
      if (input$user_role_filter != "all") {
        out <- out |> 
          filter(user_role == input$user_role_filter)
      }
      out
    })

    # Render number of not locked users.
    output$number_of_users <- renderText({
      users() |> 
        filter(locked == FALSE) |> 
        nrow() |> 
        comma()
    })
    
    # Render number of not active users.
    output$number_not_active_users <- renderText({
      users() |> 
        filter(
          locked == FALSE,
          active_time < today() - days(365),
        ) |> 
        nrow() |> 
        comma()
    })
    
    # Render number of locked users.
    output$number_of_locked_users <- renderText({
      users() |> 
        filter(locked == TRUE) |> 
        nrow() |> 
        comma()
    })
    
    # Render the area chart for the month of last activity
    output$last_activity_chart <- renderApexchart({
      data <- users() |> 
        mutate(
          last_active_month = as.Date(lubridate::floor_date(active_time, unit = "month")),
        ) |> 
        group_by(last_active_month) |>
        summarise(count = n(), .groups = "drop") |> 
        arrange(desc(last_active_month))
      
      data |> 
        apex(type = "area", mapping = aes(last_active_month, count)) |> 
        ax_tooltip(
          y = list(
            title = list(
              formatter = JS("function() {return 'Number of Users';}")
            )
          )
        ) |> 
        ax_labs(
          x = "Month of Last Activity",
          y = "Number of Users",
        )
    })
    
    # Render the users table.
    output$users_table <- renderReactable(
      users() |> 
        reactable(
          bordered = TRUE, 
          highlight = TRUE,
          filterable = TRUE,
          defaultSorted = list("active_time" = "desc"),
          wrap = FALSE,
          defaultColDef = colDef(
            header = function(value) gsub("_", " ", value, fixed = TRUE),
            align = "center",
            headerStyle = list(background = "#f7f7f8")
          ),
        )
    )
    
  })
}