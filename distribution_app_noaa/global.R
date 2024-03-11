# LOAD LIBRARIES ----
library(shiny)
library(shinydashboard)
library(tidyverse)
library(leaflet)
library(shinycssloaders)
library(sf)
library(markdown)
library(fresh)
library(shinycssloaders)
library(here)
library(broom)
library(janitor)
library(cowplot)
library(patchwork)
library(dplyr)

#devtools::install_github("cfree14/wcfish", force=T)
library(wcfish)


# READ IN DATA ---- sophia
ca_counties_sf <- read_csv("data/ca_counties_sf.csv")
dsc <- read_csv("data/dsc.csv")
full_dung_squid_urch1 <- read_csv("data/full_dsu.csv")

# READ IN DATA ---- caroline
dismap_all_df <- read_csv("data/full_dung_squid_chin.csv")
avg_temp_df <- read_csv("data/average_temp.csv")

#Load Images for TEMP vs CPUE
squid_image <- readJPEG("shinyapp/www/squid_image.jpg")
crab_image <- readJPEG("shinyapp/www/crab_image.jpg")

## Filtering not to include Chinook
merged_dis_temp <- merge(avg_temp_df, dismap_all_df, by = "year")
merge_nochinook <- merged_dis_temp[merged_dis_temp$species != "chinook", ]

# READ IN DATA ---- maddie
eis <- read_csv("data/eis.csv")
temp_df <- read_csv("data/average_temp.csv")
squid_temp_rev <- read_csv("distribution_app_noaa/data/squid_temp_rev.csv")

squidrev_output <- lm(value_usd ~ average_temp, data=squid_temp_rev)

broom::tidy(squidrev_output) %>%
  knitr::kable() %>%
  kableExtra::kable_classic_2()

squidrev_plot<-ggplot(squid_temp_rev, aes(x= average_temp, y= value_usd))+
  geom_point()+
  labs(x="Sea Surface Temperature (C) ", y="Revenue in Millions (USD)")+
  geom_abline(intercept = coef(squidrev_output)[1],
              slope = coef(squidrev_output)[2])+
  theme_bw()+
  scale_y_continuous(labels = scales::label_number(scale = 1e-6))

#### Dungeness
###################################################################

dung_temp_rev <- eis %>%
  filter(comm_name == "Dungeness crab") %>%
  full_join(temp_df, by = 'year') %>%
  drop_na()

dungrev_output<-lm(value_usd ~ average_temp, data=dung_temp_rev) #linear model (lm)
dungrev_output # gets only the coefficients
summary(dungrev_output)

broom::tidy(dungrev_output) %>%
  knitr::kable() %>%
  kableExtra::kable_classic_2()

dungrev_plot<-ggplot(dung_temp_rev, aes(x= average_temp, y= value_usd))+
  geom_point()+
  labs(x="Sea Surface Temperature (C)", y="Revenue in Millions (USD)")+
  geom_abline(intercept = coef(dungrev_output)[1],
              slope = coef(dungrev_output)[2])+
  theme_bw()+
  scale_y_continuous(labels = scales::label_number(scale = 1e-6))

### Urchin
#######################################################
urchin_temp_rev <- eis %>%
  filter(comm_name == "Red sea urchin") %>%
  full_join(temp_df, by = 'year') %>%
  drop_na()

urchinrev_output<-lm(value_usd ~ average_temp, data=urchin_temp_rev) #linear model (lm)
urchinrev_output # gets only the coefficients
summary(urchinrev_output)

broom::tidy(urchinrev_output) %>%
  knitr::kable() %>%
  kableExtra::kable_classic_2()

urchinrev_plot<-ggplot(urchin_temp_rev, aes(x= average_temp, y= value_usd))+
  geom_point()+
  labs(x="Sea Surface Temperature (C)", y="Revenue in Millions (USD)")+
  geom_abline(intercept = coef(urchinrev_output)[1],
              slope = coef(urchinrev_output)[2])+
  theme_bw()+
  scale_y_continuous(labels = scales::label_number(scale = 1e-6))


