read_data <- function()
{
    # Assume that the data file (household_power_consumption.txt) is in the working directory.
    # Noticing that entries are sorted by date and time, we find out what part of the file
    # we need to read in. Here we precomputed the values of first and last line (utilising Unix shell, using 
    # commands shown in the comments) and stored them as constants in the appropriate variables.
    
    firstLine <- 66638L # as.integer(system("grep -m1 -n  \"^1/2/2007\"  household_power_consumption.txt | 
    # head -1 | cut -f1 -d\":\"", intern=T)) 
    
    lastLine <- 69517L # as.integer(system("grep -n  \"^2/2/2007\"  household_power_consumption.txt | 
    # tail -1 | cut -f1 -d\":\"", intern=T)) 
    
    # Get the column names from the header    
    colnames <- names(read.csv("household_power_consumption.txt",sep=";",nrows=1,header=T))
    
    # Read the data
    data <- read.csv("household_power_consumption.txt",sep=";",skip=firstLine-1,nrows=lastLine-firstLine+1,
                     col.name=colnames,header=F,na.strings="?")
    
    # The method above is much faster than an alternative solution of reading the whole 
    # file into a data frame and subsetting in R:
    # data <- read.csv("household_power_consumption.txt",sep=";",header=T,na.strings="?")
    # data <- subset(data, Date=="1/2/2007" | Date=="2/2/2007")
    
    # Combine time and date into datetime and store it in the column Time
    data$Time <- strptime(paste(data$Date,data$Time),"%d/%m/%Y %T")
    
    # Drop the now redundant column Date
    data <-subset(data,select=Time:Sub_metering_3)
}

data <- read_data()

png(filename="plot4.png",width=480,height=480)

#for this layout the default cex is 0.83, changed to 0.8 to better match the required output
par(mfcol=c(2,2),cex=0.8) 

with(data, {
    plot(Time,Global_active_power,type="l",xlab="",
     ylab="Global Active Power")
    plot(Time,Sub_metering_1,type="l",col="black",
     xlab="",ylab="Energy sub metering")
    lines(Time,Sub_metering_2,col="red")
    lines(Time,Sub_metering_3,col="blue")
    legend("topright", lty=1, col=c("black","blue","red"),
       legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),bty="n")
    plot(Time,Voltage,type="l",xlab="datetime",
         ylab="Voltage")
    plot(Time,Global_reactive_power,type="l",xlab="datetime",
         ylab="Global_reactive_power")
})

dev.off()
