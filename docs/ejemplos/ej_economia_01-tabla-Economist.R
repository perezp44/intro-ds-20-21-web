#- replicar tablas de The Economist: 


#- cargando packages ----
# (!"pacman" %in% installed.packages()[,"Package"]) install.packages("pacman", repos='http://cran.r-project.org')
pacman::p_load(tidyverse, rdbnomics, magrittr, zoo, lubridate, knitr, kableExtra, formattable)

#- setup labels ----------------------
currentyear <- year(Sys.Date())
lastyear <- currentyear-1
beforelastyear <- currentyear-2
CountryList <- c("United States", "China", "Japan", "Britain", "Canada", "Euro area", "Austria", "Belgium", "France","Germany", "Greece","Italy", "Netherlands", "Spain", "Czech Republic","Denmark","Norway","Poland","Russia","Sweden","Switzerland","Turkey", "Australia", "Hong Kong", "India", "Indonesia", "Malaysia", "Pakistan", "Philippines", "Singapore","South Korea", "Taiwan", "Thailand", "Argentina","Brazil","Chile","Colombia","Mexico","Peru", "Egypt","Israel","Saudi Arabia","South Africa")


#- obteniendo datos -----------------
gdp <- rdb("OECD","MEI", ids=".NAEXKP01.GPSA+GYSA.Q")

hongkong_philippines_thailand_gdp <- rdb("IMF","IFS",mask="Q.HK+PH+TH.NGDP_R_PC_CP_A_SA_PT+NGDP_R_PC_PP_SA_PT") 
hongkong_philippines_thailand_gdp <- hongkong_philippines_thailand_gdp  %>% 
     rename(Country = `Reference Area`) %>% 
     mutate(Country = case_when(Country == "Hong Kong, China" ~ "Hong Kong", TRUE ~ Country)) %>% 
     mutate(MEASURE = case_when(INDICATOR=="NGDP_R_PC_CP_A_SA_PT" ~ "GYSA", INDICATOR=="NGDP_R_PC_PP_SA_PT" ~ "GPSA"))
     
     
malaysia_peru_saudi_singapore_gdp <- rdb("IMF","IFS",mask="Q.MY+PE+SA+SG.NGDP_R_PC_CP_A_PT+NGDP_R_PC_PP_PT") 
malaysia_peru_saudi_singapore_gdp <- malaysia_peru_saudi_singapore_gdp %>% 
  rename(Country = `Reference Area`) %>% 
  mutate(MEASURE = case_when(INDICATOR=="NGDP_R_PC_CP_A_PT" ~ "GYSA",
                             INDICATOR=="NGDP_R_PC_PP_PT" ~ "GPSA"))

taiwan_gdp <- rdb("BI/TABEL9_1/17.Q") 
taiwan_gdp <- taiwan_gdp %>% mutate(Country = "Taiwan", MEASURE="GYSA")

egypt_pakistan_gdp <- rdb("IMF","WEO",mask="EGY+PAK.NGDP_RPCH") 
egypt_pakistan_gdp <- egypt_pakistan_gdp %>% rename(Country=`WEO Country`) %>% 
              mutate(MEASURE = "GYSA") %>% filter(year(period) < currentyear)

china_gdp_level <- rdb(ids="OECD/MEI/CHN.NAEXCP01.STSA.Q")
gdp_qoq_china <- china_gdp_level %>% arrange(period) %>% 
                 mutate(value = value/lag(value) - 1, MEASURE="GPSA")
gdp_yoy_china <- china_gdp_level %>% arrange(period) %>% 
                 mutate(quarter = quarter(period)) %>% group_by(quarter) %>% 
                mutate(value = value/lag(value) - 1, MEASURE="GYSA")

argentina_gdp_level <- rdb(ids="Eurostat/naidq_10_gdp/Q.SCA.KP_I10.B1GQ.AR") 
argentina_gdp_level <- argentina_gdp_level %>% rename(Country = `Geopolitical entity (reporting)`)
gdp_qoq_argentina <- argentina_gdp_level %>% arrange(period) %>%  mutate(value = value/lag(value) - 1, MEASURE = "GPSA")
gdp_yoy_argentina <- argentina_gdp_level %>% arrange(period) %>%  
                  mutate(quarter=quarter(period)) %>% group_by(quarter) %>% 
                 mutate(value = value/lag(value) - 1, MEASURE = "GYSA")


#- junta los gdps -------------------------
gdp <- bind_rows(gdp, hongkong_philippines_thailand_gdp, malaysia_peru_saudi_singapore_gdp, taiwan_gdp, egypt_pakistan_gdp, gdp_yoy_china, gdp_qoq_china, gdp_yoy_argentina, gdp_qoq_argentina)


#- producción industrial
indprod <- rdb("OECD","MEI", ids=".PRINTO01.GYSA.M")
australia_swiss_indprod <- rdb("OECD","MEI","AUS+CHE.PRINTO01.GYSA.Q")
china_egypt_mexico_malaysia_indprod <-
  rdb("IMF","IFS",mask="M.CN+EG+MX+MY.AIP_PC_CP_A_PT") %>% 
  rename(Country=`Reference Area`)
indonesia_pakistan_peru_philippines_singapore_southafrica_indprod <-
  rdb("IMF","IFS",mask="M.ID+PK+PE+PH+SG+ZA.AIPMA_PC_CP_A_PT") %>% 
  rename(Country=`Reference Area`)
argentina_hongkong_saudiarabia_thailand_indprod <- 
  rdb("IMF","IFS",mask="Q.AR+HK+SA+TH.AIPMA_PC_CP_A_PT") %>% 
  rename(Country=`Reference Area`) %>% 
  mutate(Country=case_when(Country=="Hong Kong, China" ~ "Hong Kong",
                           TRUE ~ Country))
indprod <- bind_rows(indprod,australia_swiss_indprod,china_egypt_mexico_malaysia_indprod,indonesia_pakistan_peru_philippines_singapore_southafrica_indprod,argentina_hongkong_saudiarabia_thailand_indprod)

cpi <- rdb("OECD","MEI",ids=".CPALTT01.GY.M")
australia_cpi <- rdb("OECD","MEI",ids="AUS.CPALTT01.GY.Q")
taiwan_cpi <- 
  rdb("BI/TABEL9_2/17.Q") %>% 
  mutate(Country="Taiwan")
other_cpi <- 
  rdb("IMF","IFS",mask="M.EG+HK+MY+PE+PH+PK+SG+TH.PCPI_PC_CP_A_PT") %>% 
  rename(Country=`Reference Area`) %>% 
  mutate(Country=case_when(Country=="Hong Kong, China" ~ "Hong Kong",
                           TRUE ~ Country))
cpi <- bind_rows(cpi,australia_cpi,taiwan_cpi,other_cpi)

unemp <- rdb("OECD","MEI",ids=".LRHUTTTT.STSA.M")
swiss_unemp <- rdb("OECD","MEI",mask="CHE.LMUNRRTT.STSA.M")
brazil_unemp <- rdb("OECD","MEI",mask="BRA.LRUNTTTT.STSA.M")
southafrica_russia_unemp <- rdb("OECD","MEI",mask="ZAF+RUS.LRUNTTTT.STSA.Q")
china_unemp <- 
  rdb(ids="BUBA/BBXL3/Q.CN.N.UNEH.TOTAL0.NAT.URAR.RAT.I00") %>% 
  mutate(Country="China")
saudiarabia_unemp <-
  rdb(ids="ILO/UNE_DEAP_SEX_AGE_RT/SAU.BA_627.AGE_AGGREGATE_TOTAL.SEX_T.A") %>%
  rename(Country=`Reference area`) %>%
  filter(year(period)<currentyear)
india_unemp <-
  rdb(ids="ILO/UNE_2EAP_SEX_AGE_RT/IND.XA_1976.AGE_YTHADULT_YGE15.SEX_T.A") %>%
  rename(Country=`Reference area`) %>%
  filter(year(period)<currentyear)
indonesia_pakistan_unemp <-
  rdb("ILO","UNE_DEAP_SEX_AGE_EDU_RT",mask="IDN+PAK..AGE_AGGREGATE_TOTAL.EDU_AGGREGATE_TOTAL.SEX_T.Q") %>% 
  rename(Country=`Reference area`)
other_unemp <-
  rdb("ILO","UNE_DEA1_SEX_AGE_RT",mask="ARG+EGY+HKG+MYS+PER+PHL+SGP+THA+TWN..AGE_YTHADULT_YGE15.SEX_T.Q") %>%
  rename(Country=`Reference area`) %>%
  mutate(Country=case_when(Country=="Hong Kong, China" ~ "Hong Kong",
                           Country=="Taiwan, China" ~ "Taiwan",
                           TRUE ~ Country))
unemp <- bind_rows(unemp,brazil_unemp,southafrica_russia_unemp,swiss_unemp,china_unemp,saudiarabia_unemp,india_unemp,indonesia_pakistan_unemp,other_unemp)

forecast_gdp_cpi_ea <- 
  rdb("IMF","WEOAGG",mask="163.NGDP_RPCH+PCPIPCH") %>% 
  rename(`WEO Country`=`WEO Countries group`)
forecast_gdp_cpi <- 
  rdb("IMF","WEO",mask=".NGDP_RPCH+PCPIPCH") %>% 
  bind_rows(forecast_gdp_cpi_ea) %>% 
  transmute(Country=`WEO Country`,
            var=`WEO Subject`,
            value,
            period) %>% 
  mutate(Country=str_trim(Country),
         var=str_trim(var)) %>% 
  mutate(Country=case_when(Country=="United Kingdom" ~ "Britain",
                           Country=="Hong Kong SAR" ~ "Hong Kong",
                           Country=="Korea" ~ "South Korea",
                           Country=="Taiwan Province of China" ~ "Taiwan",
                           TRUE ~ Country),
         var=case_when(var=="Gross domestic product, constant prices" ~ "GDP",
                       var=="Inflation, average consumer prices" ~ "CPI",
                       TRUE ~ var))
forecast_gdp_cpi <- left_join(data.frame(Country=CountryList),forecast_gdp_cpi,by="Country")

#- Transform--------------------------------------------

gdp_yoy_latest_period <-
  gdp %>% 
  filter(MEASURE=="GYSA") %>% 
  filter(!is.na(value)) %>% 
  group_by(Country) %>% 
  summarise(period=max(period))
gdp_yoy_latest <-
  gdp %>% 
  filter(MEASURE=="GYSA") %>% 
  inner_join(gdp_yoy_latest_period) %>% 
  mutate(var="GDP",measure="latest")

gdp_qoq_latest_period <-
  gdp %>% 
  filter(MEASURE=="GPSA") %>% 
  filter(!is.na(value)) %>% 
  group_by(Country) %>% 
  summarise(period=max(period))
gdp_qoq_latest <-
  gdp %>% 
  filter(MEASURE=="GPSA") %>% 
  inner_join(gdp_qoq_latest_period) %>% 
  mutate(value=((1+value/100)^4-1)*100,
         var="GDP",
         measure="quarter")

gdp_2020_2021 <-
  forecast_gdp_cpi %>% 
  filter(var=="GDP" & (period=="2020-01-01" | period=="2021-01-01")) %>% 
  mutate(measure=as.character(year(period)))

indprod_latest_period <-
  indprod %>% 
  filter(!is.na(value)) %>% 
  group_by(Country) %>% 
  summarise(period=max(period))
indprod_latest <-
  indprod %>% 
  inner_join(indprod_latest_period) %>% 
  mutate(var="indprod",measure="latest")

cpi_latest_period <-
  cpi %>% 
  filter(!is.na(value)) %>% 
  group_by(Country) %>% 
  summarise(period=max(period))
cpi_latest <-
  cpi %>% 
  inner_join(cpi_latest_period) %>% 
  mutate(var="CPI",measure="latest")

cpi_2020 <-
  forecast_gdp_cpi %>% 
  filter(var=="CPI" & period=="2020-01-01") %>% 
  mutate(measure=as.character(year(period)))

unemp_latest_period <-
  unemp %>% 
  filter(!is.na(value)) %>% 
  group_by(Country) %>% 
  summarise(period=max(period))
unemp_latest <- 
  unemp %>% 
  inner_join(unemp_latest_period) %>% 
  mutate(var="unemp",measure="latest")

#- MERGE ----------------------------------------------
df_all <- 
  bind_rows(gdp_yoy_latest,gdp_qoq_latest,gdp_2020_2021,indprod_latest,cpi_latest,cpi_2020,unemp_latest) %>% 
  mutate(value=ifelse(value>=0,
                      paste0("+",sprintf("%.1f",round(value,1))),
                      sprintf("%.1f",round(value,1)))) %>% 
  unite(measure,c(var,measure))

df_latest <- 
  df_all %>% 
  filter(measure %in% c("GDP_latest","indprod_latest","CPI_latest","unemp_latest")) %>% 
  mutate(value=case_when(`@frequency`=="quarterly" ~ paste(value," Q",quarter(period),sep=""),
                         `@frequency`=="monthly" ~ paste(value," ",month(period,label = TRUE, abbr = TRUE, locale = "en_US.utf8"),sep=""),
                         `@frequency`=="annual" ~ paste(value," Year",sep=""),
                         TRUE ~ value)) %>% 
  mutate(value=text_spec(ifelse(year(period)==lastyear,paste0(value,footnote_marker_symbol(3)),
                                ifelse(year(period)==beforelastyear,paste0(value,footnote_marker_symbol(4)),value)),
                         link = paste("https://db.nomics.world",provider_code,dataset_code,series_code,sep = "/"), 
                         color = "#333333",escape = F,extra_css="text-decoration:none"))

df_final <- 
  df_all %>% 
  filter(measure %in% c("GDP_quarter","GDP_2020","GDP_2021","CPI_2020")) %>% 
  bind_rows(df_latest) %>% 
  mutate(Country=case_when(Country=="United Kingdom" ~ "Britain",
                           Country=="Euro area (19 countries)" ~ "Euro area",
                           Country=="China (People's Republic of)" ~ "China",
                           Country=="Korea" ~ "South Korea",
                           TRUE ~ Country)) %>% 
  select(Country,value,measure) %>% 
  spread(measure,value) %>% 
  select(Country,GDP_latest,GDP_quarter,GDP_2020,GDP_2021,indprod_latest,CPI_latest,CPI_2020,unemp_latest)

df_final <- left_join(data.frame(Country=CountryList),df_final,by="Country")

#- Display -----------------------------------------------

names(df_final)[1] <- ""
names(df_final)[2] <- "latest"
names(df_final)[3] <- paste0("quarter",footnote_marker_symbol(1))
names(df_final)[4] <- paste0("2020",footnote_marker_symbol(2))
names(df_final)[5] <- paste0("2021",footnote_marker_symbol(2))
names(df_final)[6] <- "latest"
names(df_final)[7] <- "latest"
names(df_final)[8] <- paste0("2020",footnote_marker_symbol(2))
names(df_final)[9] <- "latest"

df_final %>% 
  kable(row.names = F,escape = F,align = c("l",rep("c",8)),caption = "Economic data (% change on year ago)") %>% 
  kable_styling(bootstrap_options = c("striped", "hover","responsive"), fixed_thead = T, font_size = 13) %>% 
  add_header_above(c(" " = 1, "Gross domestic product" = 4, "Industrial production  " = 1, "Consumer prices"= 2, "Unemployment rate, %"=1)) %>% 
  column_spec(1, bold = T) %>% 
  row_spec(seq(1,nrow(df_final),by=2), background = "#D5E4EB") %>% 
  row_spec(c(5,14,22,33,39),extra_css = "border-bottom: 1.2px solid") %>% 
  footnote(general = "DBnomics (Eurostat, ILO, IMF, OECD and national sources). Click on the figures in the `latest` columns to see the full time series.",
           general_title = "Source: ",
           footnote_as_chunk = T,
           symbol = c("% change on previous quarter, annual rate ", "IMF estimation/forecast", paste0(lastyear),paste0(beforelastyear)))




