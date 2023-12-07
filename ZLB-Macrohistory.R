#### Variables ####
library(ggplot2)
library(patchwork)
plot.width <- 10
plot.height <- 6

region = c("Japan","USA","UK","France","Germany")
#region = c("USA")
shortterm_rate <- 7
zlb = 0
startdate <- 1990
enddate <- 2022

################################ Macrohistory DB ##############################
JST.data <- readxl::read_xlsx("/Users/jonathanlei/Library/CloudStorage/OneDrive-Personal/Excel, Code/JSTdatasetR6.xlsx", )
JST.variables <- c("year","country","stir","debtgdp", "rgdpmad")
JST.data <- subset(JST.data, year >= startdate & year <= enddate, select = JST.variables)

### Interest rates
#data.stir.all <- subset(JST.data, stir < shortterm_rate & stir > - shortterm_rate)
data.stir <- subset(JST.data, stir < shortterm_rate & stir > - shortterm_rate & country %in% region)
STIR_plot<- ggplot(data = data.stir, aes(x = year, y = stir)) +
  geom_line(aes(year, stir, color=country), size=1) +
  theme(legend.position="bottom", legend.title = "") +
  geom_hline(yintercept=zlb, linetype = "dashed") +
  geom_text(aes(x = startdate+2.5, y = zlb+0.5, label = "Lower Bound")) +
  theme_bw() +
  labs(x="Year",y="Short Term Real Rate")
ggsave("/Users/jonathanlei/Library/CloudStorage/OneDrive-Personal/1MAS Masterthesis/Plots/STIRplot.png", width = plot.width, height = plot.height)


# Years with interest rate between +- inc_crit in time interval
  for (i in 1:length(region)){
    message(c('zero lower bound years in ',region[i],': ', dim(subset(data.stir, country %in% region[i]))[1]))
  }
  message("time considered: ", startdate , "-", enddate, " or ", enddate - startdate + 1," years")

  
### Real gdp per capita
data.rgdp <- subset(JST.data, country %in% region)
RGDP_plot<-ggplot(data = data.rgdp, aes(x = year, y = rgdpmad)) +
  geom_line(aes(year, rgdpmad, color=country), size=1) +
  theme(legend.position="bottom") + 
  theme_bw() +
  labs(x="Year",y="Real GDP per Capita")
ggsave("/Users/jonathanlei/Library/CloudStorage/OneDrive-Personal/1MAS Masterthesis/Plots/RGDP.png")

Debt_gdp<-ggplot(data = data.rgdp, aes(x = year, y = debtgdp)) +
  geom_line(aes(year, debtgdp, color=country), size=1) +
  theme(legend.position="bottom") + 
  theme_bw() +
  labs(x="Year",y="Debt / GDP Ratio")
ggsave("/Users/jonathanlei/Library/CloudStorage/OneDrive-Personal/1MAS Masterthesis/Plots/Debtquota.png")

# Combined Plot
STIR_plot / RGDP_plot / Debt_gdp
ggsave("/Users/jonathanlei/Library/CloudStorage/OneDrive-Personal/1MAS Masterthesis/Plots/zlbplot.png", height = 15, width = 10)


## Boxplot with Interest rate distributions
# region<-as.factor(region)
# ggplot(JST.data, aes(x = country, y = stir)) +
#   geom_boxplot()
