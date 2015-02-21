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
#SCC <- readRDS("Source_Classification_Code.rds")

#extract data
data.baltimore <- NEI[which(NEI$fips=="24510"),]
data.la <- NEI[which(NEI$fips=="06037"),]

data <- rbind(data.baltimore, data.la)
data$fips[which(data$fips == "24510")] <- "Baltimore City"
data$fips[which(data$fips == "06037")] <- "Los Angeles County"
names(data)[1] <- "Cities"

#Create plott
g2plot <- ggplot(data, aes(year,Emissions, fill = Cities)) +
    geom_bar(stat = "identity", position = position_dodge())

#save png to disk
ggsave(g2plot, file="plot6.png")
