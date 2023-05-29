options(scipen = 99)
library(tidyverse)
library(dplyr)
library(readr)
library(ggplot2)
library(plotly)
library(glue)
library(scales)
library(DT)
library(shiny)
library(shinydashboard)
library(rworldmap)
library(tidyverse)
library(countrycode)
library(XML)
library(maps)

ds <- read_csv("ds_salaries.csv")

ds_clean <- ds %>% 
  mutate( across(
    .cols = everything(),
    ~str_replace( ., "EN", "Entry-Level"))
  ) %>%
  mutate( across(
    .cols = everything(),
    ~str_replace( ., "MI", "Mid-Level"))
  ) %>%
  mutate( across(
    .cols = everything(),
    ~str_replace( ., "SE", "Senior-Level"))
  ) %>%
  mutate( across(
    .cols = everything(),
    ~str_replace( ., "EX", "Executive-Level"))
  ) %>% 
  mutate(
    experience_level = as.factor(experience_level),
    employment_type = as.factor(employment_type),
    job_title = as.factor(job_title),
    salary_currency = as.factor(salary_currency),
    employee_residence = as.factor(employee_residence),
    remote_ratio = as.factor(remote_ratio),
    company_location = as.factor(company_location),
    company_size = as.factor(company_size),
    salary = as.double(salary),
    salary_in_usd = as.double(salary_in_usd),
    company_country = countrycode(company_location, "iso2c", "country.name"),
    region = as.factor(company_country)
  ) %>% 
  select(-c(...1))
