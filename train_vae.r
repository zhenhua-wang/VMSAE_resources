library(tidycensus)
library(tidyverse)
library(datasets)
library(sf)
library(spdep)
library(reticulate)
library(VMSAE)
install_environment()
load_environment()
census_api_key("deff5363dbd43b11c62dccc8717b487bbd6765ab",
  install = TRUE, overwrite=TRUE)

geography <- "tract"
stat_abb <- state.abb[!(state.name %in% c("Alaska", "Hawaii"))]
for (state in stat_abb) {
  census_shp <- get_acs(
    geography = geography,
    state = state,
    variables = "B19013_001",
    year = 2020,
    survey = "acs5",
    geometry = TRUE,
    output = "wide"
  ) %>% filter(!st_is_empty(.))
  W <- nb2mat(poly2nb(census_shp), style = "B", zero.policy = TRUE)
  loss <- train_vae(W = W,
    GEOID = census_shp$GEOID,
    vae_model_name = sprintf("%s_%s", state, geography),
    vae_save_dir = "model",
    n_samples = 10000,
    batch_size = 256,
    epoch = 10000,
    lr_init = 0.001)
  print(sprintf("%s is done.", state))
}
