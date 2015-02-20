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


#open plot output
png("plot2.png")                                                                              

#set x-axis variable
years <- c("1999", "2002", "2005", "2008")
means <- vector()  #initializing data
for (i in years) {
    means[i] <- mean(NEI$Emissions[which(NEI$year == i & NEI$fips == "24510")]
                     , na.rm = TRUE)
}

# create plot
barplot(means, main = "Mean PM_2.5 emissions (Tons)\nin Baltimore City")

#close plot output
dev.off()