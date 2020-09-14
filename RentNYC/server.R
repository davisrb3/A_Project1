# RentNYC

shinyServer(function(input, output, session) {
    
    observe({
        input$boroPick
        input$dateRange
        input$datePick
        nhList <- unique(filter(MedRent, Borough %in% input$boroPick, areaType=="neighborhood")[,"areaName"])
        top5list <- top5() %>% .$areaName
        updateCheckboxGroupInput(session, "nhPick", 
                                 choices = nhList, 
                                 inline = T)
        })
    
    criteria <- reactive({
        MedRent %>% 
            filter(., between(Month, input$dateRange[1], input$dateRange[2]),
                   areaType== "neighborhood", 
                   Borough == input$boroPick
                   ) %>% 
            group_by(., Month, Borough, areaName, BR)
        })
    
    top5 <- reactive({
        criteria() %>% 
            filter(., BR %in% c("BdTwo")) %>%
            group_by(.,areaName) %>% 
            filter(.,Month == max(Month, na.rm = T)) %>% 
            ungroup(.) %>% 
            arrange(., desc(Rent)) %>% 
            top_n(.,5, Rent)
        })
    
    output$trend <- renderPlot(
        criteria() %>% 
            filter(., BR == "BdTwo", areaName %in% input$nhPick) %>%
            ggplot(.,mapping = aes(x = Month, y = Rent)) + 
            xlab("Neighborhoods") +
            ylab("Median Rent") +
            geom_point(mapping = aes(color = areaName)) +
            geom_smooth(mapping = aes(color = areaName), se = F) + 
            ggtitle("Median Price of 2nd Bedroom") + 
            labs(color = "Neighborhood")
        )

    output$compare <- renderPlot(
        top5() %>% 
            ggplot(mapping = aes(x = areaName, y = Rent)) + 
            geom_col(mapping = aes(fill = areaName)) +
            xlab("Neighborhoods") +
            ylab("Median Rent") +
            ggtitle("Top 5 Median Rent Increases for 2nd Bedroom (Most Recent)") +
            labs(fill = "Neighborhood")
        )
    })
