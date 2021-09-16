# nc <- st_transform(st_read(system.file("shape/nc.shp", package="sf")), 2264)                
nc <- st_transform(BSAS, 2264)                

nc %>% st_make_grid(n = c(5, 5)) %>% 
  plot()

gr = st_sf(
  label = apply(expand.grid(1:7, LETTERS[7:1])[,2:1], 1, paste0, collapse = " "),
  geom = st_make_grid(
    st_as_sfc(st_bbox(nc)), n=c(7,7)))

gr$col = sf.colors(7, categorical = TRUE, alpha = .3)

# cut, to check, NA's work out:
# gr = gr[-(1:30),]
nc_j <- st_join(nc, gr, largest = TRUE)

opar = par(mfrow = c(2,1), mar = rep(0,4))
plot(st_geometry(nc_j))
plot(st_geometry(gr), add = TRUE, col = gr$col)
text(st_coordinates(st_centroid(gr)), labels = gr$label)

#> Warning: st_centroid assumes attributes are constant over geometries of x
# the joined dataset:
plot(st_geometry(nc_j), border = 'black', col = nc_j$col)
text(st_coordinates(st_centroid(nc_j)), labels = nc_j$label, cex = .8)

#> Warning: st_centroid assumes attributes are constant over geometries of x
plot(st_geometry(gr), border = 'green', add = TRUE)
