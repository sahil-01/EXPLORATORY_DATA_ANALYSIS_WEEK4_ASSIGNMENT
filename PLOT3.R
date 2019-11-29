if("ggplot2" %in% rownames(installed.packages()) == FALSE)
{
  install.packages("ggplot2")
}

require("ggplot2")

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
## the Year and the Emissions levels remain, and
## subset data for Baltimore only.
NEIData <- readRDS("summarySCC_PM25.rds")
NEIData <- NEIData[ which(NEIData$fips == "24510"), ]
NEIData <- NEIData[,c(6,5,4)]

## Aggregate the emissions using sum by the year they
## were recorded.
PlotData <- aggregate(list(Emissions = NEIData$Emissions), by = list(Year = NEIData$year, Type = NEIData$type), FUN = "sum")

## Additional Column for Emissions Level calculated to
## Hundreds of Tons.
PlotData$EmissionsInHundreds <- PlotData$Emissions / 100   

## Plot to PNG file plot3.png
png("plot3.png", width=640, height=480)
NewPlot <- ggplot(PlotData, aes(Year, EmissionsInHundreds, color = Type))
NewPlot <- NewPlot + geom_line(linetype = "solid", size = 2) +
  xlab("Year") +
  ylab(expression("Emissions (Hundreds of Tons)")) +
  ggtitle("Total Emissions in Baltimore City")
print(NewPlot)
dev.off()


## Unload ggplot2
detach("package:ggplot2", unload=TRUE)