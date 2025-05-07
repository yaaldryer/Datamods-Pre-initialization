# Module for preemptively initializing hidden components
preInitializeUI <- function(id, ui_component){
  ns <- NS(id)
  div(
    id = ns("container"),
    style = "position: absolute; left: -9999px; top: -9999px; width: 1px; height: 1px; overflow: hidden;",
    ui_component
  )
}

preInitializeServer <- function(id, component_server_fn, cleanup = TRUE){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    # Run the component's server function
    result <- component_server_fn()
    
    # Clean up after initialization if requested
    if(cleanup){
      observe({
        req(result())
        # Delay cleanup to ensure initialization is complete first
        delay(1000, {
          runjs(sprintf("document.getElementById('hidden-ui-container').remove();", ns("container")))
        })
      })
    }
    
    return(result)
  })
}