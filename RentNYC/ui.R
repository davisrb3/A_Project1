# RentNYC

shinyUI(dashboardPage(
    dashboardHeader(title = "Median Asking Rent"),
    dashboardSidebar(
        sidebarMenu(
            menuItem("About", tabName = "about", icon = icon("info")),
            menuItem("Bedroom Rent Trends", tabName = "trend", icon = icon("calendar")),
            menuItem("Compare Bedroom Prices", tabName = "compare", icon = icon("bed"))
        ),
        selectizeInput(
            inputId = "boroPick",
            label = "Borough",
            choices = unique(MedRent["Borough"]),
            selected = "Bronx"
            ),
        sliderInput(
            inputId = "dateRange",
            label = "Date Range",
            min = ymd(min(MedRent[,"Month"], na.rm = T)),
            max = ymd(max(MedRent[,"Month"], na.rm = T)),
            value = c(ymd(min(MedRent[,"Month"])), ymd(max(MedRent[,"Month"], na.rm = T))),
            timeFormat = "%b, %Y"
        )
    ),
        dashboardBody(
            tabItems(
                tabItem(tabName = "trend",
                        plotOutput("trend"),
                        checkboxGroupInput(
                            inputId = "nhPick",
                            label = "Neighborhoods",
                            choices = unique(filter(MedRent, areaType =="neighborhood")[, "areaName"]),
                            inline = T
                            # Future Improvement: align choices into grid
                            )
                        ),
                tabItem(tabName = "compare",
                    plotOutput("compare"),
                    ),
                tabItem(
                    tabName = "about",
                    h1("About"),
                    "In the wake of COVID-19, nearly all employees have begun working from home, and an increasing number of companies are moving to a permanent work from home model. 
                    This is a significant disruption to the conventional style of living and will have a dramatic impact on renters' priorities when choosing a living space.", 
                    "The goal of this application is to act as one piece in developing an understanding of what renters value most in an apartment and the future of living spaces.",
                    h2("Future Improvements"),
                    h4("Data:"),
                    "The dataset currently used is very lacking in data which would be very helpful, such as square footage, inclusion of washer/dryer, proximety to subway stops, etc.  Additionally, rent prices likely behave in a seasonal pattern, 
                    and improved time series analysis and regression would be helpful in understanding the key factors determining the value of otherwise equivalent apartmetnts.",
                    h4("Analysis:"),
                    "Most graphs will need to be redone with better data and and improved regression.",
                    h4("User Interface:"),
                    "Selecting dates as months instead of full dates. More options to filter data should be added. Displaying map graphics with positions and quick stats on neighborhoods.  Heat maps for relative rent rates across neighborhoods." 
                    
                    )
                )
            )
))
