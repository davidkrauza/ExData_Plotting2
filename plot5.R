#Load the lattice library
library(lattice)

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
data.nei <- NEI[NEI$SCC %in% SCC[grep("Mobile", SCC$EI.Sector), 1], ]
data.fips <- data.nei[which(data.nei$fips == "24510"), ]
data.scc <- SCC[, c(1, 4)]
data.merged <- merge(data.fips, data.scc, by.x = "SCC"
                     , by.y = "SCC")[, c(4, 6, 7)]
data.merged[data.merged$Emissions > 15, ] <- NA
data.merged <- data.merged[which(data.merged$EI.Sector 
                                 != "Mobile - Commercial Marine Vessels"), ]
data.merged <- data.merged[which(data.merged$EI.Sector != "Mobile - Aircraft"), ]

#create lattice plot
trellis.device(device="png", filename="plot5.png")
plot5 <- xyplot(Emissions ~ year | EI.Sector
                       , data.merged, layout = c(4, 2), ylab = "Emissions", 
       xlab = "years", panel = function(x, y) {
           panel.xyplot(x, y)
           panel.lmline(x, y, lty = 1, col = "red")
           par.strip.text = list(cex = 0.8)
       }, as.table = T)

#save png to disk
print(plot5)
dev.off()
