# Katherine Taylor
# 03_data_exploration.R

# libraries
library(tidytext)
library(tidyverse)
# install.packages("widyr")
library(widyr)
library(igraph)
# install.packages("ggraph")
library(ggraph)

# read in data
artwork_title <- read_csv(here("data","tidy_data","artwork_title.csv"))
artwork_medium <- read_csv(here("data","tidy_data","artwork_medium.csv"))
artwork_credit_line <- read_csv(here("data","tidy_data","artwork_credit_line.csv"))

# remove stop words
artwork_title <- artwork_title %>%
    unnest_tokens(word, title) %>%
    anti_join(stop_words)

artwork_credit_line <- artwork_credit_line %>%
    unnest_tokens(word,credit_line) %>%
    anti_join(stop_words)

# initial exploration
artwork_title %>%
    count(word, sort = TRUE)

artwork_credit_line %>%
    count(word, sort = TRUE)

my_stopwords <- data_frame("word" = c(as.character(1:10),
    "1856","title","blank","inscription","turner","inscriptions"))

artwork_title <- artwork_title %>%
    anti_join(my_stopwords)

artwork_credit_line <- artwork_credit_line %>%
    anti_join(my_stopwords)

artwork_medium %>%
    group_by(medium) %>%
    count(sort = TRUE)

# should use other in artwork_medium, there probably are a lot of very specific mediums

#region  networks of title and credit_line words
title_word_pairs <- artwork_title %>%
    pairwise_count(word, id, sort = TRUE, upper = FALSE)

credit_line_word_pairs <- artwork_credit_line %>%
    pairwise_count(word, id, sort = TRUE, upper = FALSE)

set.seed(317)

title_word_pairs %>%
    filter(n >= 100) %>%
    graph_from_data_frame() %>%
    ggraph(layout = "fr") +
    geom_edge_link(aes(edge_alpha = n, edge_width = n),edge_color = "cyan4") +
    geom_node_point(size = 5) +
    geom_node_text(aes(label = name), repel = TRUE, 
        point.padding = unit(0.2, "lines")) +
    theme_void()

#endregion