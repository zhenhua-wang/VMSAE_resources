library(tidycensus)
library(tidyverse)
library(datasets)
library(sf)
library(spdep)

geography <- c("county", "tract")
state_abb <- state.abb[!(state.name %in% c("Alaska", "Hawaii"))]
model_dir <- "./model/"
shp_dir <- "./shp_processed/"
output_dir <- "./zip/"

for (state in state_abb) {
  for (geo in geography) {
    model_name <- paste0(tolower(state), "_", geo)
    shp_name <- paste0(model_name, c(".cpg", ".dbf", ".prj", ".shp", ".shx"))
    vae_name <- paste0(model_name, c(".model", ".GEOID"))
    model_path <- paste0(model_dir, vae_name)
    shp_path <- paste0(shp_dir, shp_name)
    ## files <- c(model_path, shp_path)
    files <- model_path
    zip(zipfile = paste0(output_dir, model_name, ".zip"),
      files = files, flags = "-r -j", zip = "zip")
  }
}

## test zip
library(vmsae)
load_environment()
temp_dir <- tempfile()
dir.create(temp_dir)
unzip(zipfile = "./zip/mo_county.zip", exdir = temp_dir)
vae <- load_vae("mo_county", temp_dir)
