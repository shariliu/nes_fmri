library(tidyverse)
library(ggrepel)
base_path <- "~/Dropbox (MIT)/Research/Studies/_NIRS/NES/exp2/experiment_scripts/VOE/video_statistics/"
setwd(base_path)

avg_contrast <- read.csv("CONTRAST_ALL_VIDEOS.csv")

ggplot(avg_contrast, aes(domain, max_contrast, label = video)) + 
  geom_boxplot() +
  geom_point() +
  ylab("Average contrast per video")

ggplot(avg_contrast, aes(domain, max_contrast, label = video)) + 
  geom_boxplot() +
  geom_point()

avg_luminance <- read.csv("LUMINANCE_ALL_VIDEOS.csv")

ggplot(avg_luminance, aes(domain, mean_luminance)) +
  geom_boxplot() +
  geom_point() +
  ylab("Average luminance per video")

avg_entropy <- read.csv("ENTROPY_ALL_VIDEOS.csv") %>%
  mutate(edited = case_when(str_detect(video, "edited") ~ TRUE,
                            TRUE ~ NA))
ggplot(avg_entropy, aes(domain, mean_entropy)) +
  geom_boxplot() +
  geom_point() +
  stat_summary(fun.data = "mean_cl_boot", geom = "pointrange",
               colour = "red") + 
  ylab("Average entropy per video")+
  facet_wrap(~edited)

avg_entropy %>%
  View()
