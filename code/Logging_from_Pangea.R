setwd("C:/Users/maxma/OneDrive/R_Projects/first_serious_R_project")
library(tidyverse)
library(patchwork)

#read data
magsus <- read_delim("data/GeoB6425-2_susceptibility_age.tab",
            na = c("", "NA"), 
            skip = 15)  %>%
  rename(depth = "Depth [m]", 
         age = "Age [ka BP]", 
         kappa = "kappa [10**-6 SI]")
  #select(depth, kappa)

magsus

h2o_dens <- read_delim("data/GeoB6425-2_water_density.tab",
                     na = c("", "NA"), 
                     skip = 16) %>%
  rename(depth = "Depth [m]", watercont = "Water wm [%]", 
         poros = "Poros [% vol]",
         dbd = "DBD [g/cm**3]",
         wbd = "WBD [g/cm**3]")
  #select(-dbd, -wbd) 

h2o_dens

#joining data frames together
core_data <- left_join(magsus, h2o_dens, by = "depth")
core_data2 <- core_data %>% 
  filter(!is.na(watercont) & 
           !is.na(poros) & 
           !is.na(dbd) &
           !is.na(wbd)) %>% 
  select(-kappa)

#individual theme
theme_log <- function(){
  theme(axis.ticks.y = element_blank(),
        axis.title.y = element_blank(),
        panel.background = element_blank(),
        axis.line.x = element_line(colour = 'black', size=0.5, linetype='solid'))
}


#plotting
ms <-core_data %>% 
      ggplot(aes(x = kappa, y = depth)) + 
        geom_path(lineend = "round",
                  linejoin = "round") +
        #geom_point() + 
        theme_classic() +
        scale_y_continuous(trans = "reverse", 
                           breaks = seq(0, 11, by = 0.5), 
                           expand = c(0,0)) +
        scale_x_continuous(position = "top", 
                           breaks = seq(0, 1000, by = 100), 
                           expand = c(0,0),
                           minor_breaks = seq(0, 11, by = 0.2)) +
        labs(x = "Magnetic Susceptibility",
             y = "Depth [cm]")

wc <-core_data2 %>% 
  ggplot(aes(x = watercont, y = depth)) + 
  geom_path() +
  geom_point() + 
  theme_log() +
  scale_y_continuous(trans = "reverse", 
                     breaks = seq(0, 11, by = 1), 
                     expand = c(0,0)) +
  scale_x_continuous(position = "top", 
                     breaks = seq(40, 66, by = 2), 
                     expand = c(0,0)) +
  labs(x = "Water content [%]",
       y = "Depth [cm]")

po <-core_data2 %>% 
  ggplot(aes(x = poros, y = depth)) + 
  geom_path() +
  geom_point() + 
  theme_log() +
  scale_y_continuous(trans = "reverse", 
                     breaks = seq(0, 11, by = 1), 
                     expand = c(0,0)) +
  scale_x_continuous(position = "top", 
                     n.breaks = 10, 
                     expand = c(0,0)) +
  labs(x = "Porosity [%]",
       y = "Depth [cm]")

db <-core_data2 %>% 
  ggplot(aes(x = dbd, y = depth)) + 
  geom_path() +
  geom_point() + 
  theme_log() +
  scale_y_continuous(trans = "reverse", 
                     breaks = seq(0, 11, by = 0.5), 
                     expand = c(0,0)) +
  scale_x_continuous(position = "top", 
                     breaks = seq(0.4, 1, by = 0.1), 
                     expand = c(0,0)) +
  labs(x = "DBD [g/cm**3]",
       y = "Depth [cm]")

wd <-core_data2 %>% 
  ggplot(aes(x = wbd, y = depth)) + 
  geom_path() +
  geom_point() + 
  theme_log() +
  scale_y_continuous(trans = "reverse", 
                     breaks = seq(0, 11, by = 1), 
                     expand = c(0,0)) +
  scale_x_continuous(position = "top", 
                     breaks = seq(1, 2, by = 0.1), 
                     expand = c(0,0)) +
  labs(x = "WBD [g/cm**3]",
       y = "Depth [cm]")

Final_Plot <- ms + wc + po + db + wd +
  plot_annotation(title = "Composite Log of GeoB6425-2", tag_levels = "A" ) +
  plot_layout(nrow = 1, byrow = FALSE)

Final_Plot

ggsave("figures/composite_log_GeoB6425_2.tiff", 
       width = 20, 
       height = 10, 
       dpi = 300)

                       