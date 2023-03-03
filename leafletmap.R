# install.packages("leaflet")   from CRAN
# install_github("rstudio/leaflet")  the development version from Github

library(leaflet)
library(readr)
library(sf)
library(rgdal)

# Leaflet is one of the most popular open-source JavaScript libraries for interactive maps
# This R package makes it easy to integrate and control Leaflet maps in R.

# Map tiles
# Markers
# Polygons
# Lines
# Popups

# Embed maps in R Markdown documents and Shiny apps
# Create a map widget by calling leaflet()
# Add layers (i.e., features) to the map by using layer functions 
# (e.g. addTiles, addMarkers, addPolygons) to modify the map widget.



town <- st_read("shapefiles/shapefiles/Accessibility Points/All_new_points.shp")
admin1 <- st_read("shapefiles/shapefiles/admin/LGA.shp")

pal <- colorNumeric(
  palette = "Blues",
  domain = data$partners_2)


data <- read.csv("shapefiles/shapefiles/partners/partners.csv") %>% 
  
  st_as_sf(
    # Columns 
    coords = c("long", "lat"),
    
    remove = FALSE,
    
    # Projection
    crs = 4326
        
  )


iconn = makeIcon("GitHub-Mark-removebg-preview.png", iconWidth = 20, iconHeight = 20)


icon = makeIcon(ifelse(town$Status == "Accessible Town", "img/accesble.png", 
                        
                        ifelse(town$Status == "Inaccessible Town", "img/inace.png" , ""
                        
                        )), iconWidth = 20, iconHeight = 20 )


map <- leaflet() %>% 
  
  addProviderTiles(providers$Esri.WorldGrayCanvas, group = "Esri.WorldGrayCanvas") %>%
  
  addProviderTiles(providers$OpenStreetMap, group = "OpenStreetMap") %>% 
  addMarkers(town, lng =  town$lon, lat = town$lat,  group = "Town", icon = icon) %>% 
  addPolygons( data = admin1, 
              fillColor =  ~pal(data$partners_2),
              weight = 1,
              
              opacity = 9
              
              ) %>% 
  addLabelOnlyMarkers(lng = data$long, lat = data$lat, label = data$LGAs_ADM2_, 
                      labelOptions = labelOptions(noHide = T, direction = 'center', textOnly = T)) %>% 


  
  addMarkers(data,  lng = data$long, lat = data$lat, clusterOptions = TRUE, group = "Point", popup = paste0("<b>LGA: </b>", data$LGAs_ADM_1, "<br>", "<b>NGOs: </b>", data$partners_2 ), icon = iconn) %>% 
  
  
  
  
  
  addLayersControl(baseGroups = c("Esri.WorldGrayCanvas","OpenStreetMap"),
                   overlayGroups = c("Point", "Town") )%>% 
                     hideGroup("Town")
  
map


# Learning Objectives
# Learn how to make interactive maps using leaflet 
# Learn how to host an interactive map on web and github





# convert a table into a spacial object using st_as_sf() from the sf package




# So the problem with using leaflet generally is that it doesn't scale to large data 
# so we have leaf gl this use webgl and when you do that you can plot hundreds of thousands
# of points in few seconds
# for chloroplast you have to first create a color palette by mapping it to the domain of the counts

# |>  or %>% 