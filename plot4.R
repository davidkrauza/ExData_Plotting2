#Load the ggplot2 library
library(ggplot2)

#Check for Zip File
if(!file.exists("NEI_data.zip")){
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
                  ,"NEI.data.zip", method="curl")
}

#Check to see if zip file has already been unzipped
if(!file.exists("summarySCC_PM25.rds") 
   & file.exists("Source_Classification_Code.rds")) {
    unzip("NEI_data.zip")
}

#read RDS files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#extract data
data.nei <- NEI[NEI$SCC %in% SCC[grep("Coal", SCC$EI.Sector),1],]
data.scc <- SCC[,c(1,4)]
data.coal <- merge(data.nei,data.scc, by.x="SCC", by.y="SCC")[,c(4,6,7)]

#create gg2plot
g2plot <- ggplot(data.coal, aes(year, Emissions)) +
    geom_point(aes(color=EI.Sector)) + 
    facet_grid(.~EI.Sector) +
    geom_smooth(size=1,linetype=1, method="lm", se=FALSE)

#save png to disk
ggsave(g2plot, file="plot4.png")
