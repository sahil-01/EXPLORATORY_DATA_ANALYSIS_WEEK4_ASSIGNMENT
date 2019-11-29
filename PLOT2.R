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
NEIData <- NEIData[ which(NEIData$fips == "24510"), ]
NEIData <- NEIData[,c(6,4)]

## Aggregate the emissions using sum by the year they
## were recorded.
PlotData <- aggregate(list(Emissions = NEIData$Emissions), by = list(Year = NEIData$year), FUN = "sum")

## Additional Column for Emissions Level calculated to
## Thousands of Tons.
PlotData$EmissionsInThousands <- PlotData$Emissions / 1000   

## Precalculate Rainbow Max Value based on number of rows of data
#MaxColors <- ceiling(PlotData$EmissionsInMillions)
#PlotColors <- rainbow(MaxColors, start = 0, end = 2/6)

## Plot to PNG file plot2.png
barplot(PlotData$EmissionsInThousands, names.arg = PlotData$Year, ylim = c(0,3.5),
        # col = PlotColors[7-PlotData$EmissionsInMillions],
        main = "Total PM2.5 Emissions in Baltimore",
        ylab = "Emissions (Thousands of Tons)", xlab = "Year")
dev.copy(png, "plot2.png")
dev.off()