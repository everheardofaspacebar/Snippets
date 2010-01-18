library(RgoogleMaps)

#Define the markers: 
mymarkers<-cbind.data.frame(lat = c(38.898648,38.889112, 38.880940),
lon = c(-77.037692, -77.050273, -77.03660), size = c("tiny","tiny","tiny"), col = c("blue", "green", "red"), char = c("","",""));
#get the bounding box: 
bb<-qbbox(lat = mymarkers[,"lat"], lon = mymarkers[,"lon"])
#download the map: 
MyMap<-GetMap.bbox(bb$lonR, bb$latR, destfile = "DC.png", GRAYSCALE =T, markers = mymarkers); 
#determine the max zoom, so that all points fit on the plot (not necessary in this case):
zoom<-min(MaxZoom(latrange=bb$latR,lonrange=bb$lonR)); 


#plot:
png("OverlayTest.png",640,640); tmp <- PlotOnStaticMap(MyMap,lat = mymarkers[,"lat"], lon = mymarkers[,"lon"],cex=1.5,pch=20,col=c("blue", "green", "red"), add=F); 

tmp<-PlotOnStaticMap(MyMap,lat = mymarkers[,"lat"], lon = mymarkers[,"lon"], col=c("purple"), add=T, FUN = lines, lwd = 2) 

dev.off()