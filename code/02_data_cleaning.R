# Katherine Taylor
# 02_data_cleaning.R

library(tidyverse)
library(here)
library(tm)

artwork <- read_csv(here("data","raw_data","artwork.csv"))
artists <- read_csv(here("data","raw_data","artists.csv"))

head(artwork)
head(artists)

head(artwork$medium)
head(artwork$dateText)
head(artwork$creditLine)
head(artwork$inscription, 100)
head(artwork$title)
# need to clean medium, credit_line, inscription, and title,
# remove dateText, dimensions, thumbnail copyright, thumbnail URL, url
artwork_df <- artwork %>%
    select(-c(dateText, dimensions, thumbnailCopyright, thumbnailUrl, url)) %>%
    mutate(
        medium = tolower(medium),
        title = tolower(title),
        title = removePunctuation(title),
        creditLine = tolower(creditLine)
    ) %>%
    janitor::clean_names()

head(artwork_df)

write_csv(artwork_df, here("data","tidy_data","artwork_tidy.csv"))

head(artists$placeOfBirth)

# pick up on cleaning artist data later
artists_df <- artists %>%
    mutate(
        unnest(str_split(placeOfBirth, ",", simplify = TRUE), cols = c("city_of_birth","country_of_birth"))
    ) %>%
    janitor::clean_names()

# on the right track 
head(unlist(str_split_fixed(artists$placeOfBirth, ",", n = 2)),100)

# dfs for text analysis
artwork_title <- data.frame("id" = artwork_df$id, "title" = artwork_df$title)
artwork_medium <- data.frame("id" = artwork_df$id, "medium" = artwork_df$medium)
artwork_credit_line <- data.frame("id" = artwork_df$id, "credit_line" = artwork_df$credit_line)

write_csv(artwork_title, here("data","tidy_data","artwork_title.csv"))
write_csv(artwork_medium, here("data","tidy_data","artwork_medium.csv"))
write_csv(artwork_credit_line, here("data","tidy_data","artwork_credit_line.csv"))