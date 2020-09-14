# RentNYC

library(shiny)
library(dplyr)
library(tidyr)
library(ggplot2)
library(DT)
library(lubridate)
library(shinydashboard)

# Helper function to import one table + cleanup and format
import <- function(beds, report) {
  path = paste0("./data/", beds, "/", report, "_", beds, ".csv")
  df.in <- read.csv(path) %>%
    gather(., key = "Month", value = "Rent", -c(1:3), na.rm = FALSE) %>%
    mutate(., BR = beds, Month = ymd(paste0(substr(Month,2,100),".01")))
  return(df.in)
}

# Function to import all data tables and combine, reformat bedroom data
import_all <- function(report) {
  beds <- c("Studio", "OneBd", "TwoBd", "ThreePlusBd")
  out <- data.frame()
  for (br in beds) {
    temp <- import(br, report)
    out <- rbind(out, temp)
  }
  return(out)
}

# Add Rows for individual rooms

perRoom <- function(x) {
  pr <- x %>%
    spread(., key = "BR", value = "Rent") %>%
    arrange(., Borough, areaName, Month) %>% 
    mutate(.,
           BdOne = OneBd - Studio,
           BdTwo = TwoBd - OneBd,
           BdThreePlus = ThreePlusBd - TwoBd) %>%
    select(., Month, areaName, areaType, Borough, 
           Studio, OneBd, TwoBd, ThreePlusBd, 
           BdOne, BdTwo, BdThreePlus) %>% 
    gather(., key = BR, value = Rent, -c(1:4), na.rm = T) %>% 
    mutate(., AptRoom = ifelse(startsWith(BR,"Bd"),"Room","Apt"))
  return(pr)
}

MedRent.in <- import_all("medianAskingRent")
MedRent <- perRoom(MedRent.in)