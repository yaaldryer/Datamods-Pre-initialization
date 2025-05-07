library(shiny)
library(datamods)
library(bslib)
library(shinyjs)

# Sample data
sample_data <- data.frame(
  ID = 1:5,
  Name = LETTERS[1:5],
  Value = 11:15
)

ui <- fluidPage(
  title = "Datamods Invisible Render Example",
  useShinyjs(),
  
  # Add the datamods table UI to a hidden div
  div(
    id = "hidden-ui-container",
    style = "position: absolute; left: -9999px; top: -9999px; width: 1px; height: 1px; overflow: hidden;",
    edit_data_ui("hidden_editable_table")
  ),
  
  navset_card_tab(
    id = "tabs",
    nav_panel(
      title = "Preview Data",
      card(
        card_header("Preview Data"),
        verbatimTextOutput("data_preview")
      )
    ),
    nav_panel(
      title = "Edit Data",
      card(
        card_header("Edit Data"),
        edit_data_ui("editable_table")
      )
    )
  )
)

server <- function(input, output, session){
  # Create a reactiveVal to store shared data
  data_store <- reactiveVal(sample_data)
  
  # Hidden datamods table; only used for initialization
    # Completely off-screen so it initializes but isn't visible
  hidden_res_edit <- edit_data_server(
    id = "hidden_editable_table",
    data_r = data_store
  )
  
  # Visible datamods table; used for user edits
  res_edit <- edit_data_server(
    id = "editable_table",
    data_r = data_store
  )
  
  # When the visible datamods table is edited, update the shared data
  observe({
    updated_data <- res_edit()
    if(!is.null(updated_data)){
      data_store(updated_data)
    }
  })
  
  # Display preview using the shared data
  output$data_preview <- renderPrint({
    req(data_store())
    str(data_store())
  })
  
  # Once the hidden table is initialized, remove the hidden div
  observe({
    req(hidden_res_edit())
    # Delay removal to ensure everything is initialized
    delay(1000, {
      runjs("document.getElementById('hidden-ui-container').remove();")
    })
  })
}

shinyApp(ui = ui, server = server)