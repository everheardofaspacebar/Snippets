library(ggplot2)
library(maps)
library(sp)


con <- url("http://www.gadm.org/data/rda/GBR_adm2.RData")
print(load(con))
close(con)

ukmap<-fortify.SpatialPolygonsDataFrame(gadm, region="NAME_2")
ukmap$order<-rownames(ukmap)

url<-"http://data.london.gov.uk/datafiles/demographics/nino-registrations-overseas-borough-2009.csv"

x<-read.csv(url)

x.m<-melt(x, id=c("Code", "Area", "Total.Number.of.Registrations", "MYE.Working.age.2008"))

x.c<-cast(x.m, variable~., fun.aggregate=sum)
colnames(x.c) <- c("Area", "total")

x.c<-x.c[order(x.c$total, decreasing=TRUE), ]
x.c$rank<-as.numeric(rank(x.c$total))


x.m<-merge(x.m, x.c, by.x="variable", by.y="Area")
x.m<-subset(x.m, as.numeric(rank)>=185)


###Merge on data


ukmap.data<-merge(ukmap, x.m, by.x="id", by.y="Area")
ukmap.data<-ukmap.data[order(ukmap.data$order), ]
ukmap.data.sub<-subset(ukmap.data, value>0)
ukmap.data.sub<-subset(ukmap.data.sub, group!="London.1")

ukmap.data.sub$order<-as.numeric(ukmap.data.sub$order)
ukmap.data.sub<-ukmap.data.sub[order(ukmap.data.sub$rank, ukmap.data.sub$group, ukmap.data.sub$order), ]

p<-ggplot(data=ukmap.data.sub, aes(x=long, y=lat, fill=cut_interval(log(value), n=9), grouping = group))

pdf(file="immigration.pdf", width=17, height=13)
p+geom_polygon()+theme_bw()+geom_path(colour="grey")+xlim(c(-0.6, 0.4))+ylim(c(51.25, 51.7))+facet_wrap(~variable)+scale_fill_brewer(palette="PuRd", label = "Number of registered immigrants")
dev.off()
