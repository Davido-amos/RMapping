# With the tmap package, thematic maps can be generated

#install.packages("tmap")

library(tmap)
library(sf)



admin2 <- st_read("shapefiles/LGAs/LGAs.shp")

roads <- st_read("shapefiles/shapefiles/Accessibility Roads/All_new_roads.shp")

towns <- st_read("shapefiles/shapefiles/Accessibility Points/All_new_points.shp")



# Static map 
tmap_mode("plot")


# interactive  map 
tmap_mode("view")




map <- tm_shape(admin2) +
  
  # fill color 
  tm_fill("TARGET_FID",
              
          title="individuals per sqm"
          ) +
  
  # add boundaries
  tm_borders(alpha = .5) +
  
  #tm_polygons()  boundaries + fill
  
  # Add labels
  tm_text("ADM2_EN", size = 0.6)+
  
  # Create multiple polygons
  #tm_facets(by="ADM1_EN") +
  
  
  # remove box
  tm_layout(frame = FALSE)



map


# Add multiple layers

# Polygon

tm_shape(admin2)+
  tm_polygons(col = "purple")+
  tm_add_legend(type = "fill" , labels = "State", col = "purple", title = "Legend")+

  # Lines
tm_shape( shp = roads) +
  tm_lines(col = "red", lty = "solid") +
  tm_add_legend(type = "line", labels = "Roads", col = "red", lty = "solid") +
  
  # Points
  
  tm_shape(shp = towns) +
  tm_dots(col = "green") +
  tm_add_legend(type = "symbol", labels = "Town", col = "green", shape = 18) +
  
  # remove box
 # tm_layout(frame = TRUE) +
 # tm_legend(Position = c("left", "top"))
  
  











