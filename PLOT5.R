## Acquire and extract the data files
## Link provided as part of assignment
if(!file.exists("summarySCC_PM25.rds") || !file.exists("Source_Classification_Code.rds"))
{
  ZipFile <- "exdata-data-NEI_data.zip"
  
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",
                ZipFile, method = "auto")
  
  unzip(ZipFile, overwrite = TRUE)
  file.remove(ZipFile)
}

## Read data, eliminate and rearrange columns so only
## the Year and the Emissions levels remain.
NEIData <- readRDS("summarySCC_PM25.rds")
# Classification <- readRDS("Source_Classification_Code.rds")
# Plot4Data <- merge(NEIData, Classification, by="SCC")
# remove(Classification, NEIData)
NEIData <- NEIData[NEIData$fips=="24510" & NEIData$type=="ON-ROAD",  ]
NEIData <- NEIData[,c(6,4)]

## Aggregate the emissions using sum by the year they
## were recorded.
PlotData <- aggregate(list(Emissions = NEIData$Emissions), by = list(Year = NEIData$year), FUN = "sum")

## Precalculate Rainbow Max Value based on number of rows of data
#MaxColors <- ceiling(PlotData$EmissionsInMillions)
#PlotColors <- rainbow(MaxColors, start = 0, end = 2/6)

## Plot to PNG file plot5.png
barplot(PlotData$Emissions, names.arg = PlotData$Year, ylim = c(0,400),
        # col = PlotColors[7-PlotData$EmissionsInMillions],
        main = "Total PM2.5 Emissions from Vehicles in Baltimore",
        ylab = "Emissions (Hundred of Tons)", xlab = "Year")
dev.copy(png, "plot5.png")
dev.off()