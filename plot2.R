library(dplyr)

#Download and unzip data
if (!file.exists("./powerconsumption.zip")) {
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
                destfile = "powerconsumption.zip")
}

if (!file.exists("./household_power_consumption.txt")) {
    unzip("./powerconsumption.zip")
}

#Read file and save raw data. NA values are "?"
rawdata <- read.csv("./household_power_consumption.txt",header = TRUE, sep = ";", na.strings = "?", stringsAsFactors = FALSE)

#Filter for February 1 and 2 data. Combine Date and Time columns and convert to DateTime type.
febdata <- rawdata %>%
            filter(Date %in% c("1/2/2007", "2/2/2007")) %>%
            mutate(datetime = paste(Date, Time))

febdata$datetime <- strptime(febdata$datetime, "%d/%m/%Y %H:%M:%S")

#Plot line plot of DateTime vs Global Active Power and save as png file. Default size is 480 x 480 pixels
png("plot2.png")
with(febdata, plot(datetime,Global_active_power, type = "l", xlab = "", ylab = "Global Active Power (kilowatts)"))
dev.off()