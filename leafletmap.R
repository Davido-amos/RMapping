# install.packages("leaflet")   from CRAN
# install_github("rstudio/leaflet")  the development version from Github

library(leaflet)
library(leaflet.extras)
library(leaflet.extras2)
library(leaflegend)


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
# (e.g. add Tiles, add Markers, add Polygons) to modify the map widget.

# A map is organized in a number of smaller portions known as map tiles. 
# These map tiles are transferred one by one to your device and combined 
# there to form a complete and ready-to-use map. A map tile URL contains the information
# a map library needs to determine where to get required map tiles from



town <- st_read("shapefiles/shapefiles/Accessibility Points/All_new_points.shp")
admin1 <- st_read("shapefiles/shapefiles/admin/LGA.shp")

pal <- colorNumeric(
  palette = "Blues",
  domain = data$partners_2)


roadpal <- colorFactor(c("seagreen", "#58280F","red","orange"), 
                       domain = roads$type)



roads <- st_read("shapefiles/shapefiles/Accessibility Roads/All_new_roads.shp") %>% 
  st_transform(CRS("+init=epsg:4326"))




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
                        
                        ifelse(town$Status == "Inaccessible Town", "img/inace.png" , 
                               ifelse( town$Status == "Hard to Reach Town", "img/hard.png", 
                                       ifelse( town$Status ==  "Hard to reach town - UNHAS only","img/helipad_neww.png",  " "
                        
                        ))) ), iconWidth = 15, iconHeight = 15 )


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


leafImg2 <- c("img/accesble.png", "img/hard.png", "img/inace.png","img/helipad_neww.png")
val2 <- c('Accessible town', 'Hard-to-reach town', "Extremely Hard-to-reach town", "Hard-to-reach town UNHAS Only")


leaflet() %>% 
  
  # A map is organized in a number of smaller portions known as map tiles. 
  # https://wiki.open street map.org/wiki/Tile_servers
  
  addTiles( urlTemplate = "https://cartodb-basemaps-{s}.global.ssl.fastly.net/dark_all/{z}/{x}/{y}.png") %>% 
 
  # The leaflet package comes with 100+ providers tiles
  # The names pf these tiles are stored in a list named providers 
  addProviderTiles(providers$Esri.WorldGrayCanvas, group = "Esri.WorldGrayCanvas") %>% 
  addProviderTiles(providers$HERE.satelliteDay, group = "HERE.satelliteDay") %>% 
  
  # Add an inset mini map
  addMiniMap(
    position = "bottomright",
    tiles = providers$OpenStreetMap,
    toggleDisplay = TRUE,
    minimized = FALSE
  ) %>%
  
  # Add measurement tool
  addMeasure(
    position = "topleft",
    primaryLengthUnit = "meters",
    secondaryLengthUnit = "kilometers",
    primaryAreaUnit = "sqmeters"
  ) %>%
  
  # Add scale bar
  addScaleBar(
    position = "bottomleft",
    options = scaleBarOptions(imperial = FALSE)) %>% 
  
  
  # library(leaflet.extra)
  addDrawToolbar(
    targetGroup = "draw",
    editOptions = editToolbarOptions(
      selectedPathOptions = selectedPathOptions()
    )
  ) %>% 
  
  # styling 
  addStyleEditor(position = "topleft", 
                 openOnLeafletDraw = TRUE) %>% 
  addMarkers(town, lng =  town$lon, lat = town$lat,  popup = paste0(town$Settlement, "<br>", town$Status), group = "Town", icon = icon) %>% 
  #  library(leaflegend)
  addLegendImage(images = leafImg2,
                 labels = val2,
                 width = 10,
                 height = 10,
                 labelStyle = "font-size: 14px; vertical-align: middle;",
                 group = "Town",
                 title = 'Town Accessibility - Source: NIF/INSO MAP ',
                 position = 'bottomleft') %>% 
  
  addPolylines(data = roads, color  = roadpal(roads$type), weight = 3, group = "Road", popup = ~paste("Road Status:",roads$type )) %>% 
 
  addLegend(
    title = "Road Accessibility - Source: NIF/INSO MAP ",
    pal = roadpal,
    opacity = 1,
    values = roads$type, 
    group = "Road",
    position = "bottomleft") %>% 
  
  addPolygons( data = admin1, 
               stroke = 1,
               color = "white",
               fillColor  = "#000000",
               weight = 1,
               group = "Admin",
               opacity = 9
                ) %>% 
  addLabelOnlyMarkers(lng = data$long, lat = data$lat, label = data$LGAs_ADM2_, group = "Label",
                      labelOptions = labelOptions(noHide = T, direction = 'center', textOnly = T)) %>% 
  
  
  
  
  addLayersControl(
    baseGroups = c("Esri.WorldGrayCanvas", "HERE.satelliteDay"),
    overlayGroups = c("Town", "Road", "Admin", "Label")
  )
  
  

    
  

  



# Learning Objectives
# Learn how to make interactive maps using leaflet 
# Learn how to host an interactive map on web and github





# convert a table into a spacial object using st_as_sf() from the sf package




# So the problem with using leaflet generally is that it doesn't scale to large data 
# so we have leaf gl this use webgl and when you do that you can plot hundreds of thousands
# of points in few seconds
# for chloroplast you have to first create a color palette by mapping it to the domain of the counts

# |>  or %>% 