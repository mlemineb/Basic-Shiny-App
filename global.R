library(shiny)
require(shinydashboard)
library(shinyjs)
library(shinycssloaders)
library(ggplot2)
library(dplyr)
library(tidyr)
library(datasetsICR)
library(randomNames)
library(echarts4r)

#### some data manipulation to derive the values of KPI boxes ####
# data(customers)
# customers$CustomerID<-1:nrow(customers)
# customers<-cbind(customers,randomNames(nrow(customers), return.complete.data=TRUE))
# customers$gender<-ifelse(customers$gender==1,"Female","Man")
# customers$Channel<-ifelse(customers$Channel==1,"Hotel/Restaurant/Cafe","Retail")
# customers$Region<-ifelse(customers$Region==1,"Lisbon",
#                          ifelse(customers$Region==2,"Oporto","Other"))
# customers$Age<-round(rnorm(nrow(customers), mean = 50, sd = 10),digits=0)
# customers$Total_spend<- as.numeric(apply(customers[,3:8], 1, sum))

# saveRDS(customers,"data/customers_data.RDS")

customers<-readRDS("data/customers_data.RDS")

#### some data manipulation to derive the plots and values of KPI boxes ####

product_stat <- customers[-c(15)] %>% 
  pivot_longer(cols=c("Fresh","Milk","Grocery","Frozen", "Detergents_Paper", "Delicassen"),
   names_to="product", values_to="value")

product.total <- product_stat %>% group_by(product) %>% summarise(total = sum(value))
total.revenue <- sum(customers$Total_spend)
region.total <- customers %>% group_by(Region) %>% summarise(total = sum(Total_spend))
gender.total <- customers %>% group_by(gender) %>% summarise(total = sum(Total_spend))



top_product <- product_stat %>% group_by(product) %>%
  summarise(Total = sum(value)) %>% filter(Total==max(Total))

top_customer <- customers %>% group_by(CustomerID) %>%
  summarise(value = sum(Total_spend)) %>% filter(value==max(value))

top_customer <-left_join(top_customer,customers[c(9,12,13)])

customers<-customers[c(9,12,13,14,10,11,1:8,15)]

#### some specific data manipulation to derive some plots ####


My_df <- product.total %>%
  mutate(percent = round(total/sum(total), 2),
         name = paste(product, percent, sep = ","))


My_df_2 <- region.total %>%
  mutate(percent = round(total/sum(total), 2),
         name = paste(Region, percent, sep = ","))

### CHOICES FOR FILTER (select input) ####

region_choice <- c("All", as.character(sort(unique(customers$Region))))





