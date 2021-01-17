# Katherine Taylor
# 02_data_cleaning.R

library(tidyverse)
library(here)

artwork <- read_csv(here("data","raw_data","artwork.csv"))
artists <- read_csv(here("data","raw_data","artists.csv"))

head(artwork)
head(artists)

head(artwork$medium)
head(artwork$dateText)

# need to clean medium, credit_line, inscription, and title,
# remove dateText, dimensions, thumbnail copyright, thumbnail URL, url
artwork_df <- artwork %>%
    select(-(dateText, dimensions, thumbnailCopyright, thumbnailUrl, url)) %>%

    janitor::clean_names()