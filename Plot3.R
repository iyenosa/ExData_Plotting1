# Check to see if a "data" folder is present, if not it creates one
        if(!file.exists("data")) {dir.create("data")}

# Download zip file and get the list
        url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        download.file(url, "./data/powerconsumption.zip")
        unzip("./data/powerconsumption.zip", list = TRUE)

# Read in filtered data from specified time period
        powerdata <- read.table(unz("./data/powerconsumption.zip", "household_power_consumption.txt"),
                        sep = ";", na.strings = "?",
                        col.names = c("Date", "Time", "Global_active_power", "Global_reactive_power", "Voltage", "Global_intensity", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
                        skip=grep("31/1/2007;23:59:00", readLines(unz("./data/powerconsumption.zip", "household_power_consumption.txt"))),
                        nrows = 2880)

# Create new variable with formatted date and time
        powerdata$date_time <- strptime(paste(powerdata$Date, powerdata$Time),
                                format = "%d/%m/%Y %H:%M:%S")
        names(powerdata) <- tolower(names(powerdata))

# Create line plot of energy sub metering across the days
        png("Plot3.png", width = 480, height = 480)
        with(powerdata, {
                plot(powerdata$date_time, sub_metering_1, type = "n",
                             xlab = "", ylab = "Energy sub metering")
                lines(x = powerdata$date_time, y = sub_metering_1)
                lines(x = powerdata$date_time, y = sub_metering_2, col = "red")
                lines(x = powerdata$date_time, y = sub_metering_3, col = "blue")
                legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),lty = 1, col = c("black", "red", "blue"))
        })
        dev.off()
