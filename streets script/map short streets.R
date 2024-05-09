


# Load library
library(sf)
library(dplyr)
library(leaflet)

# Load shapefile
shp <- read_sf("C:/Users/ERODRI01/OneDrive - Environmental Protection Agency (EPA)/temp docs/Roadway_SubBlock/Roadway_SubBlock.shp")

# show the coordinate reference system:
st_crs(shp)

# look at the class of the sf object:
class(shp)


# create a flag for whether the street segment is less than 90 meters in length
shp$street_len_meters <- abs(shp$FROMMEASUR - shp$TOMEASURE)
shp$short_street <- 0
shp$short_street[shp$street_len_meters <= 100] <- 1

# number of street segments in the original dataset:
nrow(shp)

# subset. Quadrant 1 is NW. Road type 1 is "streets" (e.g. not alleys etc)
# if "DOUBLEYELL" is NA, the street doesn't have a double yellow line.
short_streets_shp <-
  shp %>%
  filter(short_street == 1 & 
           QUADRANT %in% c(1) & 
           ROADTYPE == "1" & 
           (SPEEDLIM_2 <= 20 | is.na(SPEEDLIM_2)) &
           is.na(DOUBLEYELL))

# number of street segments in the "short street" dataset:
nrow(short_streets_shp)

# clean up broken segments
goodLine <- st_zm(short_streets_shp, drop = T, what = "ZM")

# plot the data on a map:
leaflet(goodLine) %>% 
  addProviderTiles(providers$Esri.WorldImagery, group = "ESRI World Imagery") %>% 
  addProviderTiles("CartoDB.Positron", group = "Carto Positron") %>% 
  leaflet::addPolygons(color = "green") %>%
  addLayersControl(
    baseGroups = c("Carto Positron", "ESRI World Imagery"),
    options = layersControlOptions(collapsed = FALSE)
  )







