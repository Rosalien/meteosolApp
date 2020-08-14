#' mod_compileDataUI
#'
#' @description Module to compile data
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom golem get_golem_options
#' @importFrom shiny NS tagList moduleServer checkboxGroupInput column fileInput reactiveValues
#' @importFrom shiny fluidRow updateCheckboxGroupInput isolate need observe observeEvent reactive h2 h5 icon validate 
#' @importFrom shinyBS bsButton
#' @importFrom DT dataTableOutput datatable renderDataTable formatDate
#' @importFrom data.table setkeyv setDT
#' @importFrom reshape melt
#' @importFrom wesanderson wes_palette
#' @import dygraphs
#' @import shinydashboard
#' @import toolboxMeteosol
#' @importFrom utils read.csv timestamp
#' 

mod_compileDataUI <- function(id){

	ns <- NS(id)
	fluidRow(
		column(2,
			fluidRow(
				box(width=12,title = "Variables into the file",
					checkboxGroupInput(ns("variableFile"),label="",selected = NULL,choiceNames=NULL,choiceValues=NULL)
        		)
        	)
        ),
        column(10,
        	fluidRow(
        		box(width=12,title = tagList(shiny::icon("chart-bar"), "Time trend of variables selected"),
        			solidHeader = TRUE,collapsible = TRUE,status="info",collapsed=FALSE,
        			dygraphOutput(ns("dygraph"))
        		)
        	),
			fluidRow(
        		box(width=12,title = tagList(shiny::icon("table"), "Data of variables selected"),
        			solidHeader = TRUE,collapsible = TRUE,status="info",collapsed=FALSE,
        			dataTableOutput(ns("dataTable"))
        		)
        	)
        )
    )
}

#' mod_compileData Server Function
#'
#' @noRd 

mod_compileData <- function(id,compileFilePath=NULL){
moduleServer(
id,
function(input, output, session){

	ns <- session$ns
	attr(ts, "tzone") <- "Africa/Algiers"
	Sys.setenv(TZ = "Africa/Algiers")

	checkinVariable <- reactiveValues(checked = NULL)
	  	observe({
	    input$variableFile
    	isolate({
      	if(!is.null(input$variableFile)){
          	checkinVariable$checked <- input$variableFile        
      	}else{checkinVariable$checked <- NULL}
    	})
  	})

  	observe({ 
	    listVariables <- colnames(compileFile())[grepl("timestamp|date|time",colnames(compileFile()))==FALSE]
	    updateCheckboxGroupInput(session,
    	                     "variableFile", "Variables",
        	                 choiceValues = listVariables,
            	             choiceNames = listVariables,
                	         selected = checkinVariable$checked)
 	})

	variableSelected <- reactive({
    	variables <- input$variableFile
    	validate(need(!is.null(variables),"No variable selected"))
	    variables
  })

	# Data from upload file
	compileFile <- reactive({
		# Read file
		compileFile <- compileFilePath()
    print(compileFile)
  	validate(need(!is.null(compileFile),"Please choose a file to upload"))
    dataCompile <- setDT(read.csv(compileFile$datapath,header=TRUE,sep=";"))
  	dataCompile
	})


	# Data table selected with variable
	output$dataTable <- DT::renderDataTable({
    	tableData <- setDT(compileFile())
    	tableData$timestamp <- as.POSIXct(tableData$timestamp,"%Y-%m-%d %H:%M:%S",tz='Africa/Algiers')
      	meltDataCompile <- setDT(reshape::melt(tableData,id=1:3,na.rm=TRUE))
      	meltDataCompile <- unique(meltDataCompile[timestamp >= values$start & timestamp <= values$end & variable %in% variableSelected(),])
      	retData <- DT::datatable(meltDataCompile,rownames= FALSE,filter = 'top')%>%
					formatDate('timestamp',method = "toLocaleString",params = list("se", list(timeZone = "Africa/Algiers")))
  	    return(retData)
	})
	
	#https://stackoverflow.com/questions/39859013/extract-dyrangeselector-values-from-dygraph-in-shiny-app
  	#https://stackoverflow.com/questions/30955578/r-shiny-dygraphs-series-reacting-to-date-window
  	values <- reactiveValues()  
  		observeEvent(input$dygraph_date_window,{
  			if (!is.null(input$dygraph_date_window)){
    		start <- input$dygraph_date_window[[1]]
    		end <- input$dygraph_date_window[[2]]
    		values$start <- as.POSIXct(start,"%Y-%m-%dT%H:%M:%S",tz='Africa/Algiers')
    		values$end <- as.POSIXct(end,"%Y-%m-%dT%H:%M:%S",tz='Africa/Algiers')
    	}else{}
  	})

	# dygraph of variables selected
	output$dygraph <- renderDygraph({
      validate(need(!is.null(compileFile()),"Please choose a file to upload"))
			dataXTS <- dataToXts(compileFile(),variableSelected(),"timestamp","%Y-%m-%d %H:%M:%S")
			dygraphs::dygraph(dataXTS,width="100%") %>%
					  dyOptions(retainDateWindow = TRUE) %>%
                      dyOptions(stackedGraph = FALSE) %>%
                      dyRangeSelector(height = 20,strokeColor = "") %>%  
                      dyLegend(show = "onmouseover") %>% 
                      dyRangeSelector(retainDateWindow=TRUE) %>%
                      dyHighlight(highlightSeriesBackgroundAlpha = 0.8,highlightSeriesOpts = list(strokeWidth = 3)) %>%   
                      dyOptions(colors = wes_palette("Zissou1", length(variableSelected()),type = "continuous"),retainDateWindow=TRUE,useDataTimezone=TRUE)                
	})
}
)
}

