



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
NEIData <- NEIData[,c(6,4)]

## Aggregate the emissions using sum by the year they
## were recorded.
PlotData <- aggregate(list(Emissions = NEIData$Emissions), by = list(Year = NEIData$year), FUN = "sum")

## Additional Column for Emissions Level calculated to
## Millions of Tons.
PlotData$EmissionsInMillions <- PlotData$Emissions / 1000000    

## Precalculate Rainbow Max Value based on number of rows of data
#MaxColors <- ceiling(PlotData$EmissionsInMillions)
#PlotColors <- rainbow(MaxColors, start = 0, end = 2/6)

## Plot to PNG file plot1.png
barplot(PlotData$EmissionsInMillions, names.arg = PlotData$Year, ylim = c(0,8),
        # col = PlotColors[7-PlotData$EmissionsInMillions],
        main = "Total U.S. PM2.5 Emissions",
        ylab = "Emissions (Millions of Tons)", xlab = "Year")
dev.copy(png, "plot1.png")
dev.off()