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

#Plot 4 charts as tiles and save as png file. Default size is 480 x 480
png("plot4.png")

#Set tile layout with column fills
par(mfcol = c(2,2))

#Tile 1 - Datetime vs Active Power
with(febdata, plot(datetime,Global_active_power, type = "l", xlab = "", ylab = "Global Active Power (kilowatts)"))

#Tile 2 - Datetime vs sub meters with legend
with(febdata, plot(datetime, Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering"))
with(febdata, lines(datetime, Sub_metering_2, type = "l", col = "red"))
with(febdata, lines(datetime, Sub_metering_3, type = "l", col = "blue"))
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty = 1, col = c("black","red","blue"))

#Tile 3 - Datetime vs Voltage
with(febdata, plot(datetime, Voltage, type = "l"))

#Tile 4 - Datetime vs Reactive Power
with(febdata, plot(datetime, Global_reactive_power, type = "l"))

dev.off()