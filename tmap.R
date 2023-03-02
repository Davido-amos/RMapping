# With the tmap package, thematic maps can be generated

#install.packages("tmap")

library(tmap)
library(sf)

library(readr)



admin2 <- st_read("shapefiles/LGAs/LGAs.shp")

roads <- st_read("shapefiles/shapefiles/Accessibility Roads/All_new_roads.shp")

towns <- st_read("shapefiles/shapefiles/Accessibility Points/All_new_points.shp")

test <- read.csv("data.csv")



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
  tm_add_legend(type = "symbol", labels = "Town", col = "green", shape = 18) 
  
  # remove box
 # tm_layout(frame = TRUE) +
 # tm_legend(Position = c("left", "top"))
  
  

library(readr)

dtm <- read_csv("/Users/hany/Desktop/RLeaflet/data/dtm_data.csv")

library(sf)

adm2 <- st_read(
  "/Users/hany/Desktop/adm2/nga_admbnda_adm2_osgof_20190417_WFP.shp")

library(tmap)
dtm_sf <- st_as_sf(dtm, coords = c("lon", "lat"), crs = 4326)

tm_shape(dtm_sf) +   
  tm_dots(size = "ind")

tm_shape(dtm_sf) +   
  tm_dots(alpha = 0.8, col = "ind", palette = "PRGn",
          stretch.palette = TRUE,size = 0.01)

#point to polygon
library(spatialEco)
dtm_lga <- point.in.poly(dtm_sf,adm2)

dtmlgadf <-
  as.data.frame(dtm_lga) # Creates the table to see how many individuals in each lga

library(dplyr)
ind_dtm <-
  dtmlgadf %>%
  filter(!is.na(ADM1_EN))%>%
  group_by(ADM2_EN) %>%
  summarise(tot_ind = sum(ind)) 

library(tigris)

dtm_pol <- geo_join(adm2,
                    ind_dtm,
                    "ADM2_EN",
                    "ADM2_EN",
                    how = "left") # Joins the rwi average to the LGA shapefile






#polygon map
tm_shape(dtm_pol) +
  tm_fill("blue")

#add data - color
tm_shape(dtm_pol) +
  tm_fill(col = "tot_ind")

#convert to density
tm_shape(dtm_pol) +
  tm_fill(col = "tot_ind", convert2density=TRUE,
          style="kmeans",
          title="individuals by sqm")

#Add borders
tm_shape(dtm_pol) +
  tm_fill(col = "tot_ind", convert2density=TRUE,
          style="kmeans",
          title="individuals by sqm")+
  tm_borders(alpha = .5) 


#Add text
tm_shape(dtm_pol) +
  tm_fill(col = "tot_ind", convert2density=TRUE,
          style="kmeans",
          title="individuals by sqm")+
  tm_borders(alpha = .5) +
  tm_text("ADM2_EN",
          size = 0.4) 


#Add facets
tm_shape(dtm_pol) +
  tm_fill(col = "tot_ind", convert2density=TRUE,
          style="kmeans",
          title="individuals by sqm")+
  tm_borders(alpha = .5) +
  tm_text("ADM2_EN",
          size = 0.4) +
  tm_facets(by="ADM1_EN") +
  tm_layout(legend.show = FALSE,
            outer.margins=0)













