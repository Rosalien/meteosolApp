#' The application User-Interface
#' 
#' @param request Internal parameter for `{shiny}`. 
#'     DO NOT REMOVE.
#' @importFrom shiny conditionalPanel a
#' @importFrom shinyBS bsPopover
#' @import shinydashboard
#' @noRd

options(shiny.maxRequestSize=30*1024^2) 
attr(ts, "tzone") <- "Africa/Algiers"
Sys.setenv(TZ = "Africa/Algiers")

app_ui <- function(request){
  dashboardPage(
    dashboardHeader(title = "Biometeorological data management"),
    dashboardSidebar(
      
      sidebarMenu(id="menu1",
        menuItem("Compile data", tabName = "compileData", icon = icon("th")),
        conditionalPanel(
                  condition = "input.menu1 == 'compileData'",
                  fileInput('compileFile', 'Choose path data',
                            accept = '.csv')
        ),
        menuItem("Check data", tabName = "timeTrend", icon = icon("dashboard")),
      conditionalPanel(
                  condition = "input.menu1 == 'timeTrend'",
                  fileInput('checkFile',
                   label=h5(tags$b('Choose file to upload'),
                    tags$style(type = "text/css", "#q1 {vertical-align: top;}"),
                    bsButton("q1", label = "", icon = icon("question"), style = "info", size = "extra-small")
                    ),
                   accept = '.csv'
                  ),
                    #https://stackoverflow.com/questions/37051631/add-popovers-to-shiny-app
                    bsPopover(id = "q1", title = "File format",
                      content = paste0("Example file format like ",a("this",href = "https://raw.githubusercontent.com/Rosalien/toolboxMeteosol/master/inst/extdata/compilation/Compile_lgt_bm1_2020.csv",target="_blank")),
                      placement = "right", 
                      trigger = "focus", 
                      options = list(container = "body"))
                )
          )
      ),
    dashboardBody(
      tabItems(
        # First tab content
        tabItem(tabName = "timeTrend",
          fluidRow(
            mod_timetrendUI("mod_timetrendUI_1")
          )
        ),
      # Second tab content
        tabItem(tabName = "widgets",h2("Widgets tab content"))
      )
    )
  )
}

#' Add external Resources to the Application
#' 
#' This function is internally used to add external 
#' resources inside the Shiny application. 
#' 
#' @importFrom shiny tags
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function(){
  
  add_resource_path(
    'www', app_sys('app/www')
  )
 
  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = 'meteosolApp'
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert() 
  )
}

