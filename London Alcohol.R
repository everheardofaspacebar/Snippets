library(ggplot2)
library(maps)
library(sp)

### Testing changes to github

con <- url("http://www.gadm.org/data/rda/GBR_adm2.RData")
print(load(con))
close(con)

ukmap<-fortify.SpatialPolygonsDataFrame(gadm, region="NAME_2")
ukmap$order<-rownames(ukmap)

url<-"http://data.london.gov.uk/datafiles/health/alcohol-mortality-borough.csv"

x<-read.csv(url)

x.sub<-x[, 1:12]
colnames(x.sub) <- c("Code", "Area", "Males.2002", "Males.2003", "Males.2004", "Males.2005", "Males.2006", "Females.2002", "Females.2003", "Females.2004", "Females.2005", "Females.2006")
x.m<-melt(x.sub, id=c("Code", "Area"))

x.m$gender<-substring(x.m$variable, nchar(x.m$variable)-4, nchar(x.m$variable))
x.m$year<-ifelse(x.m$gender=="M", substring(x.m$variable, 7, 12) , substring(x.m$variable, 9, 14))
x.m$gender<-ifelse(x.m$gender=="Fe", "F", x.m$gender)
###Merge on data


ukmap.data<-merge(ukmap, x.m, by.x="id", by.y="Area")
ukmap.data<-ukmap.data[order(ukmap.data$order), ]
ukmap.data.sub<-subset(ukmap.data, value>0)
ukmap.data.sub<-subset(ukmap.data.sub, group!="London.1")

ukmap.data.sub$order<-as.numeric(ukmap.data.sub$order)
ukmap.data.sub<-ukmap.data.sub[order(ukmap.data.sub$variable, ukmap.data.sub$group, ukmap.data.sub$order), ]


p<-ggplot(data=ukmap.data.sub, aes(x=long, y=lat, fill=cut_interval(value, n=9), grouping = group))

pdf(file="alcohol.pdf", width=8, height=8)
p+geom_polygon()+theme_bw()+xlim(c(-0.6, 0.4))+ylim(c(51.25, 51.7))+facet_grid(year~gender)+scale_fill_brewer(palette="PuRd", name="Months of life lost due to alcohol")
dev.off()

q<-ggplot(data=x.m, aes(x=year, y=value, grouping = gender, colour = gender))

pdf(file="alcohol 2.pdf", width=10, height=9)
q+geom_line()+facet_wrap(~Area)+theme_bw()+scale_x_discrete(breaks=c(2002, 2006))+ylab("Months of life lost due to alcohol")+scale_colour_manual(values=c("#C994C7", "#DD1C77"))
dev.off()
