library(reshape)
library(ggplot2)

url<-"http://data.london.gov.uk/datafiles/demographics/census-historic-population-borough.csv"

x<-read.csv(url)
x.sub<-subset(x, Area.Name!="Outer London")
x.sub<-subset(x.sub, Area.Name!="Greater London")
x.sub<-subset(x.sub, Area.Name!="Inner London")

x.m<-melt(x.sub)

x.m$year<-as.numeric(gsub("Persons.", "", x.m$variable))
x.m$population<-x.m$value/1000

p<-ggplot(data=x.m, aes(x=year, y=Area.Name, fill=population))

p+geom_tile()

p<-ggplot(data=x.m, aes(x=year, y=population))

pdf(file="London Population.pdf", width = 8,height=10)

p+geom_line()+facet_wrap(~Area.Name, ncol=4)+ylab("Population (in 000s)")+xlab("Census Year")

dev.off()