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
Classification <- readRDS("Source_Classification_Code.rds")
Plot4Data <- merge(NEIData, Classification, by="SCC")
remove(Classification, NEIData)
Plot4Data <- Plot4Data[grepl("coal", Plot4Data$Short.Name, ignore.case=TRUE), ]
Plot4Data <- Plot4Data[,c(6,4)]

## Aggregate the emissions using sum by the year they
## were recorded.
PlotData <- aggregate(list(Emissions = Plot4Data$Emissions), by = list(Year = Plot4Data$year), FUN = "sum")

## Additional Column for Emissions Level calculated to
## Millions of Tons.
PlotData$EmissionsInHundredThousands <- PlotData$Emissions / 100000    

## Precalculate Rainbow Max Value based on number of rows of data
#MaxColors <- ceiling(PlotData$EmissionsInMillions)
#PlotColors <- rainbow(MaxColors, start = 0, end = 2/6)

## Plot to PNG file plot4.png
barplot(PlotData$EmissionsInHundredThousands, names.arg = PlotData$Year, ylim = c(0,7),
        # col = PlotColors[7-PlotData$EmissionsInMillions],
        main = "Total U.S. PM2.5 Emissions from Coal",
        ylab = "Emissions (Hundred Thousands of Tons)", xlab = "Year")
dev.copy(png, "plot4.png")
dev.off()