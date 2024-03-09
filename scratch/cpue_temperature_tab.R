#CPUE and Temperature Tab

#libraries
library(tidyverse)
library(here)
library(broom)
library(janitor)
library(cowplot)
library(patchwork)
library(dplyr)


#Putting data in
dismap_all_df <- read_csv(here("data", "full_dung_squid_chin.csv"))
avg_temp_df <- read_csv(here("data", "average_temp.csv"))

#Filtering not to include Chinook
merged_dis_temp <- merge(avg_temp_df, dismap_all_df, by = "year")
merge_nochinook <- merged_dis_temp[merged_dis_temp$species != "chinook", ]

ggplot(merge_nochinook, aes(x = year)) +
  geom_point(aes(y = wtcpue, color = species), alpha = 0.5, size = 1.5) +  # Swap y = average_temp with y = wtcpue
  geom_line(aes(y = average_temp), color = "red", size = 1.5) + # Swap y = wtcpue with y = average_temp
  scale_x_discrete(labels = c("Dungeness", "Squid")) +
  facet_wrap(~ species, scales = "free_y", ncol = 1, labeller = labeller(species = c("squid" = "Squid", "dungeness" = "Dungeness Crab"))) +
  labs(title = "Squid and Dungeness Crab CPUE vs Temperature",
       x = "Year",
       y = "Weighted CPUE") +
  scale_color_manual(
    values = c("#603B38", "#CF9555"),
    breaks = c("squid", "dungeness"),
    labels = c("Squid", "Dungeness Crab")
  ) +
  guides(color = guide_legend(title = "Species")) +
  theme(strip.background = element_blank(), strip.placement = "outside")+
  scale_y_continuous(
    sec.axis = sec_axis(~., name = "Temperature (°C)", breaks = seq(0, 30, by = 5)),
    name = "Weighted CPUE",
    limits = c(0, max(merge_nochinook$average_temp) * 3)  # Adjust the limits as needed
  )


#Non-temperature but super cool graphs

#Bubble chart
ggplot(dismap_all_df, aes(x = year, y = wtcpue, color = species, size = depth)) +
  geom_point(alpha = 0.6)+
  scale_size(range = c(.1, 10), name="Depth (m)")+
  labs(title = "CPUE vs. Species vs. Depth",
       x = "Year",
       y = "Weighted Catch Per Unit Effort (CPUE)",
       color = "Species Type")+
  scale_color_manual(values = c("#74E291", "#59B4C3", "#211C6A"))+
  theme_minimal()










