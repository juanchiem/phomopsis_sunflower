# sp0 = cbind(x = c(0,0,1), y = c(0,1,1))
sp0 = cbind(x = dat_geo_df$lon, y = dat_geo_df$lat)

row.names(sp0) = paste("point", 1:nrow(sp0), sep="")

library(sp)
sp1 = SpatialPoints(sp0)

# time = as.POSIXct("2010-08-05")+3600*(10:13)
time = as.Date(ISOdate(dat_geo_df$year, 1, 1))  # beginning of year

m = c(10,20,30) # means for each of the 3 point locations

# mydata = rnorm(length(sp1)*length(time),mean=rep(m, 4))
mydata = dat_geo_df$inoc_presence

IDs = paste("ID", 1:length(mydata))

mydata = data.frame(values = signif(mydata,3), ID=IDs)

# mydata = data.frame(values = signif(mydata,3), ID=IDs)


library("spacetime")

stfdf = STFDF(sp1, time, mydata)
stfdf
stfdf[1:2,]
stfdf[,1:2]
stfdf[,,2]
stfdf[,,"values"]
stfdf[1,]
stfdf[,2]
as(stfdf[,,1], "xts")
as(stfdf[,,2], "xts")
# examples for [[, [[<-, $ and $<- 
stfdf[[1]]
stfdf[["values"]]
stfdf[["newVal"]] <- rnorm(12)
stfdf$ID
stfdf$ID = paste("OldIDs", 1:12, sep="")
stfdf$NewID = paste("NewIDs", 12:1, sep="")
stfdf
x = stfdf[stfdf[1:2,],] 
all.equal(x, stfdf[1:2,]) 
all.equal(stfdf, stfdf[stfdf,]) # converts character to factor.