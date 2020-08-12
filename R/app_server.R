#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @noRd

app_server <- function( input, output, session ) {
  # List the first level callModules here
	userCompilFile <- reactive({
	    req(input$compileFile)
  	})

  	userCheckFile <- reactive({
	    req(input$checkFile)
  	})

	mod_timetrend("mod_timetrendUI_1",compileFilePath=userCheckFile)
}
