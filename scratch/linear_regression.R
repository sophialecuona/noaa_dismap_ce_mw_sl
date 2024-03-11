library(here)
library(tidyverse)
library(janitor)
library(dplyr)
library(ggplot2)

devtools::install_github("cfree14/wcfish", force=T)
library(wcfish)

all <- pacfin_all1

eis <- all %>%
  select(year, comm_name, value_usd, landings_mt, landings_kg, landings_lb, price_usd_lb)

temp_df <- read_csv(here("data","average_temp.csv"))

## save processed data to the app's data directory ----
write_csv(x = eis, file = here::here("distribution_app_noaa", "data", "eis.csv"))

### Squid
##############################################
squid_temp_rev <- eis %>%
  filter(comm_name == "Market squid") %>%
  full_join(temp_df, by = 'year') %>%
  drop_na()

write_csv(x = squid_temp_rev, file = here::here("distribution_app_noaa", "data", "squid_temp_rev.csv"))

squidrev_output<-lm(value_usd ~ average_temp, data=squid_temp_rev) #linear model (lm)
squidrev_output # gets only the coefficients
summary(squidrev_output)

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

squidrev_plot


### Chinook
#################################################

chinook_temp_rev <- eis %>%
  filter(comm_name == "Chinook salmon") %>%
  full_join(temp_df, by = 'year') %>%
  drop_na()

chinookrev_output<-lm(value_usd ~ average_temp, data=chinook_temp_rev) #linear model (lm)
chinookrev_output # gets only the coefficients
summary(chinookrev_output)

broom::tidy(chinookrev_output) %>%
  knitr::kable() %>%
  kableExtra::kable_classic_2()

chinookrev_plot<-ggplot(chinook_temp_rev, aes(x= average_temp, y= value_usd))+
  geom_point()+
  labs(x="Sea Surface Temperature (C)", y="Revenue in Millions (USD)")+
  geom_abline(intercept = coef(chinookrev_output)[1],
              slope = coef(chinookrev_output)[2])+
  theme_bw()+
  scale_y_continuous(labels = scales::label_number(scale = 1e-6))

chinookrev_plot


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

dungrev_plot

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

urchinrev_plot

