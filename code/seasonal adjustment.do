


******************************************************************************

clear
set more off

rsource, terminator(END_OF_R) rpath("/usr/local/bin/R") roptions(`"--vanilla"')

rm(list=ls())

library("seasonal")
library("haven")
library("xts")
library("tsbox")

data <- read_dta("/Users/camillaadams/Dropbox/Mac/Documents/slack/intermediate/industry_unemployment_notsa.dta")
data$date <- as.Date(data$datestr)   


data_ts <- xts(data$unemp_manu, data$date)        # Convert data frame to time series
nowTS <-ts_ts(data_ts)            # convert from xts to ts

sa_series <- seas(nowTS, x11 = "")    # estimate seasonal adjustment

plot(nowTS)
lines(final(sa_series),col=2)

data1 <- as.data.frame(sa_series) # save seasonal adjustment

data2 <- data.frame(data1$date, data1$final)

colnames(data2) <- c('date','unemp')

write.csv(data2, '/Users/camillaadams/Dropbox/ustar_by_ind/intermediate/sa/unemp_sa/unemp_manu.csv', row.names= FALSE)

END_OF_R

******************************************************************************

clear
set more off

rsource, terminator(END_OF_R) rpath("/usr/local/bin/R") roptions(`"--vanilla"')

rm(list=ls())

library("seasonal")
library("haven")
library("xts")
library("tsbox")

data <- read_dta("/Users/camillaadams/Dropbox/Mac/Documents/slack/intermediate/industry_unemployment_notsa.dta")
data$date <- as.Date(data$datestr)   


data_ts <- xts(data$unemp_tu, data$date)        # Convert data frame to time series
nowTS <-ts_ts(data_ts)            # convert from xts to ts

sa_series <- seas(nowTS, x11 = "")    # estimate seasonal adjustment

plot(nowTS)
lines(final(sa_series),col=2)

data1 <- as.data.frame(sa_series) # save seasonal adjustment

data2 <- data.frame(data1$date, data1$final)

colnames(data2) <- c('date','unemp')

write.csv(data2, '/Users/camillaadams/Dropbox/ustar_by_ind/intermediate/sa/unemp_sa/unemp_tu.csv', row.names= FALSE)

END_OF_R

*******************************************************************************

set more off

rsource, terminator(END_OF_R) rpath("/usr/local/bin/R") roptions(`"--vanilla"')

rm(list=ls())

library("seasonal")
library("haven")
library("xts")
library("tsbox")

data <- read_dta("/Users/camillaadams/Dropbox/Mac/Documents/slack/intermediate/industry_unemployment_notsa.dta")
data$date <- as.Date(data$datestr)   


data_ts <- xts(data$unemp_trade, data$date)        # Convert data frame to time series
nowTS <-ts_ts(data_ts)            # convert from xts to ts

sa_series <- seas(nowTS, x11 = "")    # estimate seasonal adjustment

plot(nowTS)
lines(final(sa_series),col=2)

data1 <- as.data.frame(sa_series) # save seasonal adjustment

data2 <- data.frame(data1$date, data1$final)

colnames(data2) <- c('date','unemp')

write.csv(data2, '/Users/camillaadams/Dropbox/ustar_by_ind/intermediate/sa/unemp_sa/unemp_trade.csv', row.names= FALSE)

END_OF_R

******************************************************************************

clear
set more off

rsource, terminator(END_OF_R) rpath("/usr/local/bin/R") roptions(`"--vanilla"')

rm(list=ls())

library("seasonal")
library("haven")
library("xts")
library("tsbox")

data <- read_dta("/Users/camillaadams/Dropbox/Mac/Documents/slack/intermediate/industry_unemployment_notsa.dta")
data$date <- as.Date(data$datestr)   


data_ts <- xts(data$unemp_cons, data$date)        # Convert data frame to time series
nowTS <-ts_ts(data_ts)            # convert from xts to ts

sa_series <- seas(nowTS, x11 = "")    # estimate seasonal adjustment

plot(nowTS)
lines(final(sa_series),col=2)

data1 <- as.data.frame(sa_series) # save seasonal adjustment

data2 <- data.frame(data1$date, data1$final)

colnames(data2) <- c('date','unemp')

write.csv(data2, '/Users/camillaadams/Dropbox/ustar_by_ind/intermediate/sa/unemp_sa/unemp_cons.csv', row.names= FALSE)

END_OF_R


******************************************************************************

clear
set more off

rsource, terminator(END_OF_R) rpath("/usr/local/bin/R") roptions(`"--vanilla"')

rm(list=ls())

library("seasonal")
library("haven")
library("xts")
library("tsbox")

data <- read_dta("/Users/camillaadams/Dropbox/Mac/Documents/slack/intermediate/industry_unemployment_notsa.dta")
data$date <- as.Date(data$datestr)   


data_ts <- xts(data$unemp_ehs, data$date)        # Convert data frame to time series
nowTS <-ts_ts(data_ts)            # convert from xts to ts

sa_series <- seas(nowTS, x11 = "")    # estimate seasonal adjustment

plot(nowTS)
lines(final(sa_series),col=2)

data1 <- as.data.frame(sa_series) # save seasonal adjustment

data2 <- data.frame(data1$date, data1$final)

colnames(data2) <- c('date','unemp')

write.csv(data2, '/Users/camillaadams/Dropbox/ustar_by_ind/intermediate/sa/unemp_sa/unemp_ehs.csv', row.names= FALSE)

END_OF_R


******************************************************************************

clear
set more off

rsource, terminator(END_OF_R) rpath("/usr/local/bin/R") roptions(`"--vanilla"')

rm(list=ls())

library("seasonal")
library("haven")
library("xts")
library("tsbox")

data <- read_dta("/Users/camillaadams/Dropbox/Mac/Documents/slack/intermediate/industry_unemployment_notsa.dta")
data$date <- as.Date(data$datestr)   


data_ts <- xts(data$unemp_finan, data$date)        # Convert data frame to time series
nowTS <-ts_ts(data_ts)            # convert from xts to ts

sa_series <- seas(nowTS, x11 = "")    # estimate seasonal adjustment

plot(nowTS)
lines(final(sa_series),col=2)

data1 <- as.data.frame(sa_series) # save seasonal adjustment

data2 <- data.frame(data1$date, data1$final)

colnames(data2) <- c('date','unemp')

write.csv(data2, '/Users/camillaadams/Dropbox/ustar_by_ind/intermediate/sa/unemp_sa/unemp_finan.csv', row.names= FALSE)

END_OF_R

******************************************************************************

clear
set more off

rsource, terminator(END_OF_R) rpath("/usr/local/bin/R") roptions(`"--vanilla"')

rm(list=ls())

library("seasonal")
library("haven")
library("xts")
library("tsbox")

data <- read_dta("/Users/camillaadams/Dropbox/Mac/Documents/slack/intermediate/industry_unemployment_notsa.dta")
data$date <- as.Date(data$datestr)   


data_ts <- xts(data$unemp_govt, data$date)        # Convert data frame to time series
nowTS <-ts_ts(data_ts)            # convert from xts to ts

sa_series <- seas(nowTS, x11 = "")    # estimate seasonal adjustment

plot(nowTS)
lines(final(sa_series),col=2)

data1 <- as.data.frame(sa_series) # save seasonal adjustment

data2 <- data.frame(data1$date, data1$final)

colnames(data2) <- c('date','unemp')

write.csv(data2, '/Users/camillaadams/Dropbox/ustar_by_ind/intermediate/sa/unemp_sa/unemp_govt.csv', row.names= FALSE)

END_OF_R


******************************************************************************

clear
set more off

rsource, terminator(END_OF_R) rpath("/usr/local/bin/R") roptions(`"--vanilla"')

rm(list=ls())

library("seasonal")
library("haven")
library("xts")
library("tsbox")

data <- read_dta("/Users/camillaadams/Dropbox/Mac/Documents/slack/intermediate/industry_unemployment_notsa.dta")
data$date <- as.Date(data$datestr)   


data_ts <- xts(data$unemp_info, data$date)        # Convert data frame to time series
nowTS <-ts_ts(data_ts)            # convert from xts to ts

sa_series <- seas(nowTS, x11 = "")    # estimate seasonal adjustment

plot(nowTS)
lines(final(sa_series),col=2)

data1 <- as.data.frame(sa_series) # save seasonal adjustment

data2 <- data.frame(data1$date, data1$final)

colnames(data2) <- c('date','unemp')

write.csv(data2, '/Users/camillaadams/Dropbox/ustar_by_ind/intermediate/sa/unemp_sa/unemp_info.csv', row.names= FALSE)

END_OF_R



******************************************************************************

clear
set more off

rsource, terminator(END_OF_R) rpath("/usr/local/bin/R") roptions(`"--vanilla"')

rm(list=ls())

library("seasonal")
library("haven")
library("xts")
library("tsbox")

data <- read_dta("/Users/camillaadams/Dropbox/Mac/Documents/slack/intermediate/industry_unemployment_notsa.dta")
data$date <- as.Date(data$datestr)   


data_ts <- xts(data$unemp_lah, data$date)        # Convert data frame to time series
nowTS <-ts_ts(data_ts)            # convert from xts to ts

sa_series <- seas(nowTS, x11 = "")    # estimate seasonal adjustment

plot(nowTS)
lines(final(sa_series),col=2)

data1 <- as.data.frame(sa_series) # save seasonal adjustment

data2 <- data.frame(data1$date, data1$final)

colnames(data2) <- c('date','unemp')

write.csv(data2, '/Users/camillaadams/Dropbox/ustar_by_ind/intermediate/sa/unemp_sa/unemp_lah.csv', row.names= FALSE)

END_OF_R


******************************************************************************

clear
set more off

rsource, terminator(END_OF_R) rpath("/usr/local/bin/R") roptions(`"--vanilla"')

rm(list=ls())

library("seasonal")
library("haven")
library("xts")
library("tsbox")

data <- read_dta("/Users/camillaadams/Dropbox/Mac/Documents/slack/intermediate/industry_unemployment_notsa.dta")
data$date <- as.Date(data$datestr)   


data_ts <- xts(data$unemp_mine, data$date)        # Convert data frame to time series
nowTS <-ts_ts(data_ts)            # convert from xts to ts

sa_series <- seas(nowTS, x11 = "")    # estimate seasonal adjustment

plot(nowTS)
lines(final(sa_series),col=2)

data1 <- as.data.frame(sa_series) # save seasonal adjustment

data2 <- data.frame(data1$date, data1$final)

colnames(data2) <- c('date','unemp')

write.csv(data2, '/Users/camillaadams/Dropbox/ustar_by_ind/intermediate/sa/unemp_sa/unemp_mine.csv', row.names= FALSE)

END_OF_R


******************************************************************************

clear
set more off

rsource, terminator(END_OF_R) rpath("/usr/local/bin/R") roptions(`"--vanilla"')

rm(list=ls())

library("seasonal")
library("haven")
library("xts")
library("tsbox")

data <- read_dta("/Users/camillaadams/Dropbox/Mac/Documents/slack/intermediate/industry_unemployment_notsa.dta")
data$date <- as.Date(data$datestr)   


data_ts <- xts(data$unemp_pbs, data$date)        # Convert data frame to time series
nowTS <-ts_ts(data_ts)            # convert from xts to ts

sa_series <- seas(nowTS, x11 = "")    # estimate seasonal adjustment

plot(nowTS)
lines(final(sa_series),col=2)

data1 <- as.data.frame(sa_series) # save seasonal adjustment

data2 <- data.frame(data1$date, data1$final)

colnames(data2) <- c('date','unemp')

write.csv(data2, '/Users/camillaadams/Dropbox/ustar_by_ind/intermediate/sa/unemp_sa/unemp_pbs.csv', row.names= FALSE)

END_OF_R



******************************************************************************

clear
set more off

rsource, terminator(END_OF_R) rpath("/usr/local/bin/R") roptions(`"--vanilla"')

rm(list=ls())

library("seasonal")
library("haven")
library("xts")
library("tsbox")

data <- read_dta("/Users/camillaadams/Dropbox/Mac/Documents/slack/intermediate/industry_unemployment_notsa.dta")
data$date <- as.Date(data$datestr)   


data_ts <- xts(data$unemp_other, data$date)        # Convert data frame to time series
nowTS <-ts_ts(data_ts)            # convert from xts to ts

sa_series <- seas(nowTS, x11 = "")    # estimate seasonal adjustment

plot(nowTS)
lines(final(sa_series),col=2)

data1 <- as.data.frame(sa_series) # save seasonal adjustment

data2 <- data.frame(data1$date, data1$final)

colnames(data2) <- c('date','unemp')

write.csv(data2, '/Users/camillaadams/Dropbox/ustar_by_ind/intermediate/sa/unemp_sa/unemp_other.csv', row.names= FALSE)

END_OF_R


********************************************************************************


clear
set more off

rsource, terminator(END_OF_R) rpath("/usr/local/bin/R") roptions(`"--vanilla"')

rm(list=ls())

library("seasonal")
library("haven")
library("xts")
library("tsbox")

data <- read_dta("/Users/camillaadams/Dropbox/Mac/Documents/slack/intermediate/industry_vacancy_notsa.dta")
data$date <- as.Date(data$datestr)   


data_ts <- xts(data$jo_cons, data$date)        # Convert data frame to time series
nowTS <-ts_ts(data_ts)            # convert from xts to ts



sa_series <- seas(nowTS, x11 = "")    # estimate seasonal adjustment

plot(nowTS)
lines(final(sa_series),col=2)

data1 <- as.data.frame(sa_series) # save seasonal adjustment

data2 <- data.frame(data1$date, data1$final)

colnames(data2) <- c('date','jo')

write.csv(data2, '/Users/camillaadams/Dropbox/ustar_by_ind/intermediate/sa/vac_sa/jo_cons.csv', row.names= FALSE)

END_OF_R

********************************************************************************

clear
set more off

rsource, terminator(END_OF_R) rpath("/usr/local/bin/R") roptions(`"--vanilla"')

rm(list=ls())

library("seasonal")
library("haven")
library("xts")
library("tsbox")

data <- read_dta("/Users/camillaadams/Dropbox/Mac/Documents/slack/intermediate/industry_vacancy_notsa.dta")
data$date <- as.Date(data$datestr)   


data_ts <- xts(data$jo_manu, data$date)        # Convert data frame to time series
nowTS <-ts_ts(data_ts)            # convert from xts to ts



sa_series <- seas(nowTS, x11 = "")    # estimate seasonal adjustment

plot(nowTS)
lines(final(sa_series),col=2)

data1 <- as.data.frame(sa_series) # save seasonal adjustment

data2 <- data.frame(data1$date, data1$final)

colnames(data2) <- c('date','jo')

write.csv(data2, '/Users/camillaadams/Dropbox/ustar_by_ind/intermediate/sa/vac_sa/jo_manu.csv', row.names= FALSE)

END_OF_R

********************************************************************************

clear
set more off

rsource, terminator(END_OF_R) rpath("/usr/local/bin/R") roptions(`"--vanilla"')

rm(list=ls())

library("seasonal")
library("haven")
library("xts")
library("tsbox")

data <- read_dta("/Users/camillaadams/Dropbox/Mac/Documents/slack/intermediate/industry_vacancy_notsa.dta")
data$date <- as.Date(data$datestr)   


data_ts <- xts(data$jo_trade, data$date)        # Convert data frame to time series
nowTS <-ts_ts(data_ts)            # convert from xts to ts



sa_series <- seas(nowTS, x11 = "")    # estimate seasonal adjustment

plot(nowTS)
lines(final(sa_series),col=2)

data1 <- as.data.frame(sa_series) # save seasonal adjustment

data2 <- data.frame(data1$date, data1$final)

colnames(data2) <- c('date','jo')

write.csv(data2, '/Users/camillaadams/Dropbox/ustar_by_ind/intermediate/sa/vac_sa/jo_trade.csv', row.names= FALSE)

END_OF_R

********************************************************************************

clear
set more off

rsource, terminator(END_OF_R) rpath("/usr/local/bin/R") roptions(`"--vanilla"')

rm(list=ls())

library("seasonal")
library("haven")
library("xts")
library("tsbox")

data <- read_dta("/Users/camillaadams/Dropbox/Mac/Documents/slack/intermediate/industry_vacancy_notsa.dta")
data$date <- as.Date(data$datestr)   


data_ts <- xts(data$jo_tu, data$date)        # Convert data frame to time series
nowTS <-ts_ts(data_ts)            # convert from xts to ts



sa_series <- seas(nowTS, x11 = "")    # estimate seasonal adjustment

plot(nowTS)
lines(final(sa_series),col=2)

data1 <- as.data.frame(sa_series) # save seasonal adjustment

data2 <- data.frame(data1$date, data1$final)

colnames(data2) <- c('date','jo')

write.csv(data2, '/Users/camillaadams/Dropbox/ustar_by_ind/intermediate/sa/vac_sa/jo_tu.csv', row.names= FALSE)

END_OF_R

********************************************************************************

clear
set more off

rsource, terminator(END_OF_R) rpath("/usr/local/bin/R") roptions(`"--vanilla"')

rm(list=ls())

library("seasonal")
library("haven")
library("xts")
library("tsbox")

data <- read_dta("/Users/camillaadams/Dropbox/Mac/Documents/slack/intermediate/industry_vacancy_notsa.dta")
data$date <- as.Date(data$datestr)   


data_ts <- xts(data$jo_ehs, data$date)        # Convert data frame to time series
nowTS <-ts_ts(data_ts)            # convert from xts to ts



sa_series <- seas(nowTS, x11 = "")    # estimate seasonal adjustment

plot(nowTS)
lines(final(sa_series),col=2)

data1 <- as.data.frame(sa_series) # save seasonal adjustment

data2 <- data.frame(data1$date, data1$final)

colnames(data2) <- c('date','jo')

write.csv(data2, '/Users/camillaadams/Dropbox/ustar_by_ind/intermediate/sa/vac_sa/jo_ehs.csv', row.names= FALSE)

END_OF_R

********************************************************************************

clear
set more off

rsource, terminator(END_OF_R) rpath("/usr/local/bin/R") roptions(`"--vanilla"')

rm(list=ls())

library("seasonal")
library("haven")
library("xts")
library("tsbox")

data <- read_dta("/Users/camillaadams/Dropbox/Mac/Documents/slack/intermediate/industry_vacancy_notsa.dta")
data$date <- as.Date(data$datestr)   


data_ts <- xts(data$jo_finan, data$date)        # Convert data frame to time series
nowTS <-ts_ts(data_ts)            # convert from xts to ts



sa_series <- seas(nowTS, x11 = "")    # estimate seasonal adjustment

plot(nowTS)
lines(final(sa_series),col=2)

data1 <- as.data.frame(sa_series) # save seasonal adjustment

data2 <- data.frame(data1$date, data1$final)

colnames(data2) <- c('date','jo')

write.csv(data2, '/Users/camillaadams/Dropbox/ustar_by_ind/intermediate/sa/vac_sa/jo_finan.csv', row.names= FALSE)

END_OF_R

********************************************************************************

clear
set more off

rsource, terminator(END_OF_R) rpath("/usr/local/bin/R") roptions(`"--vanilla"')

rm(list=ls())

library("seasonal")
library("haven")
library("xts")
library("tsbox")

data <- read_dta("/Users/camillaadams/Dropbox/Mac/Documents/slack/intermediate/industry_vacancy_notsa.dta")
data$date <- as.Date(data$datestr)   


data_ts <- xts(data$jo_govt, data$date)        # Convert data frame to time series
nowTS <-ts_ts(data_ts)            # convert from xts to ts



sa_series <- seas(nowTS, x11 = "")    # estimate seasonal adjustment

plot(nowTS)
lines(final(sa_series),col=2)

data1 <- as.data.frame(sa_series) # save seasonal adjustment

data2 <- data.frame(data1$date, data1$final)

colnames(data2) <- c('date','jo')

write.csv(data2, '/Users/camillaadams/Dropbox/ustar_by_ind/intermediate/sa/vac_sa/jo_govt.csv', row.names= FALSE)

END_OF_R



********************************************************************************

clear
set more off

rsource, terminator(END_OF_R) rpath("/usr/local/bin/R") roptions(`"--vanilla"')

rm(list=ls())

library("seasonal")
library("haven")
library("xts")
library("tsbox")

data <- read_dta("/Users/camillaadams/Dropbox/Mac/Documents/slack/intermediate/industry_vacancy_notsa.dta")
data$date <- as.Date(data$datestr)   


data_ts <- xts(data$jo_info, data$date)        # Convert data frame to time series
nowTS <-ts_ts(data_ts)            # convert from xts to ts



sa_series <- seas(nowTS, x11 = "")    # estimate seasonal adjustment

plot(nowTS)
lines(final(sa_series),col=2)

data1 <- as.data.frame(sa_series) # save seasonal adjustment

data2 <- data.frame(data1$date, data1$final)

colnames(data2) <- c('date','jo')

write.csv(data2, '/Users/camillaadams/Dropbox/ustar_by_ind/intermediate/sa/vac_sa/jo_info.csv', row.names= FALSE)

END_OF_R



********************************************************************************

clear
set more off

rsource, terminator(END_OF_R) rpath("/usr/local/bin/R") roptions(`"--vanilla"')

rm(list=ls())

library("seasonal")
library("haven")
library("xts")
library("tsbox")

data <- read_dta("/Users/camillaadams/Dropbox/Mac/Documents/slack/intermediate/industry_vacancy_notsa.dta")
data$date <- as.Date(data$datestr)   


data_ts <- xts(data$jo_lah, data$date)        # Convert data frame to time series
nowTS <-ts_ts(data_ts)            # convert from xts to ts



sa_series <- seas(nowTS, x11 = "")    # estimate seasonal adjustment

plot(nowTS)
lines(final(sa_series),col=2)

data1 <- as.data.frame(sa_series) # save seasonal adjustment

data2 <- data.frame(data1$date, data1$final)

colnames(data2) <- c('date','jo')

write.csv(data2, '/Users/camillaadams/Dropbox/ustar_by_ind/intermediate/sa/vac_sa/jo_lah.csv', row.names= FALSE)


END_OF_R


********************************************************************************

clear
set more off

rsource, terminator(END_OF_R) rpath("/usr/local/bin/R") roptions(`"--vanilla"')

rm(list=ls())

library("seasonal")
library("haven")
library("xts")
library("tsbox")

data <- read_dta("/Users/camillaadams/Dropbox/Mac/Documents/slack/intermediate/industry_vacancy_notsa.dta")
data$date <- as.Date(data$datestr)   


data_ts <- xts(data$jo_mine, data$date)        # Convert data frame to time series
nowTS <-ts_ts(data_ts)            # convert from xts to ts



sa_series <- seas(nowTS, x11 = "")    # estimate seasonal adjustment

plot(nowTS)
lines(final(sa_series),col=2)

data1 <- as.data.frame(sa_series) # save seasonal adjustment

data2 <- data.frame(data1$date, data1$final)

colnames(data2) <- c('date','jo')

write.csv(data2, '/Users/camillaadams/Dropbox/ustar_by_ind/intermediate/sa/vac_sa/jo_mine.csv', row.names= FALSE)


END_OF_R

********************************************************************************

clear
set more off

rsource, terminator(END_OF_R) rpath("/usr/local/bin/R") roptions(`"--vanilla"')

rm(list=ls())

library("seasonal")
library("haven")
library("xts")
library("tsbox")

data <- read_dta("/Users/camillaadams/Dropbox/Mac/Documents/slack/intermediate/industry_vacancy_notsa.dta")
data$date <- as.Date(data$datestr)   


data_ts <- xts(data$jo_pbs, data$date)        # Convert data frame to time series
nowTS <-ts_ts(data_ts)            # convert from xts to ts



sa_series <- seas(nowTS, x11 = "")    # estimate seasonal adjustment

plot(nowTS)
lines(final(sa_series),col=2)

data1 <- as.data.frame(sa_series) # save seasonal adjustment

data2 <- data.frame(data1$date, data1$final)

colnames(data2) <- c('date','jo')

write.csv(data2, '/Users/camillaadams/Dropbox/ustar_by_ind/intermediate/sa/vac_sa/jo_pbs.csv', row.names= FALSE)

END_OF_R
********************************************************************************

clear
set more off

rsource, terminator(END_OF_R) rpath("/usr/local/bin/R") roptions(`"--vanilla"')

rm(list=ls())

library("seasonal")
library("haven")
library("xts")
library("tsbox")

data <- read_dta("/Users/camillaadams/Dropbox/Mac/Documents/slack/intermediate/industry_vacancy_notsa.dta")
data$date <- as.Date(data$datestr)   


data_ts <- xts(data$jo_other, data$date)        # Convert data frame to time series
nowTS <-ts_ts(data_ts)            # convert from xts to ts



sa_series <- seas(nowTS, x11 = "")    # estimate seasonal adjustment

plot(nowTS)
lines(final(sa_series),col=2)

data1 <- as.data.frame(sa_series) # save seasonal adjustment

data2 <- data.frame(data1$date, data1$final)

colnames(data2) <- c('date','jo')

write.csv(data2, '/Users/camillaadams/Dropbox/ustar_by_ind/intermediate/sa/vac_sa/jo_other.csv', row.names= FALSE)

END_OF_R

********************************************************************************

clear
set more off

rsource, terminator(END_OF_R) rpath("/usr/local/bin/R") roptions(`"--vanilla"')

rm(list=ls())

library("seasonal")
library("haven")
library("xts")
library("tsbox")

data <- read_dta("/Users/camillaadams/Dropbox/Mac/Documents/slack/intermediate/industry_vacancy_notsa.dta")
data$date <- as.Date(data$datestr)   


data_ts <- xts(data$jo_ttu, data$date)        # Convert data frame to time series
nowTS <-ts_ts(data_ts)            # convert from xts to ts



sa_series <- seas(nowTS, x11 = "")    # estimate seasonal adjustment

plot(nowTS)
lines(final(sa_series),col=2)

data1 <- as.data.frame(sa_series) # save seasonal adjustment

data2 <- data.frame(data1$date, data1$final)

colnames(data2) <- c('date','jo')

write.csv(data2, '/Users/camillaadams/Dropbox/ustar_by_ind/intermediate/sa/vac_sa/jo_ttu.csv', row.names= FALSE)

END_OF_R



















