##- fichero con las instrucciones R el tutorial tt_04_cargar-datos.Rmd
library(tidyverse)


#- se abrirá una ventana con el listado de datos disponibles
data()
#!! guardamos el listado de datos en un data.frame llamado "aa"
aa <- as.data.frame(data()[[3]])


#- vemos en una ventana el listado de datos disponibles en el pkg ggplot2
data(package = "ggplot2")
#!! guardamos el listado de datos del pkg ggplot2 en el df "aa"
aa <- as.data.frame(data(package = "ggplot2")[[3]]) %>% select(-2)
#!! guardamos el listado de datos del pkg ggplot2 en una tibble
aa <- as_tibble(data(package = "ggplot2")[[3]]) %>% select(-2)


# !! abre una ventana donde se ve el listado de todos los datasets que contienen los packages de nuestra librería
data(package = .packages(all.available = TRUE))



# names() muestra los nombres de las variables de un dataframe
names(iris)

# head() muestra las n (ne este caso 4) primeras filas de un dataframe
head(iris, n = 4)

# Fíjate que la variable "Species" no tiene media, ni mínimo, ni max. ... es porque es un factor
summary(iris)


#- ver la estructura del df. Visualizaremos los nombres y el tipo de las variables
str(iris)

## #devtools::install_github("ropenscilabs/skimr")
library(skimr)
skim(iris)


#- 3. Datos tabulares (o de text)--------------------------------

#- exporta en formato CSV el df iris al fichero "iris.csv"
#- Cuidado!! es una ruta absoluta. No funcionará en todos los ordenadores
write_csv(iris, path = "C:/Users/perezp/Desktop/iris.csv")

#- exporta en formato CSV el df iris al fichero "iris.csv". Como no se especifica la ruta, se grabará en el directorio de trabajo
write_csv(iris, path = "iris.csv")

#- almacenamos en el objeto "path_wd" la ruta del directorio de trabajo del ordenador que estás usando
path_a_mi_wd <- getwd()

#- Podemos fijar  el directorio de trabajo donde queramos. Por ejemplo:
setwd("C:/Users/perezp/Desktop/Mis_datos/")  #- en tu ordenador no funcionará porque tu ordenador no tiene esa ruta o estructura de carpetas

#- fijamos el directorio de trabajo (aunque en realidad no hace falta porque esa ruta almacenada en  "path_a_mi_wd" ya era ese el directorio de trabajo
setwd(path_a_mi_wd)

#- exporta en formato .csv el df iris al fichero "iris.csv". Se guardará en la subcarpeta "datos/pruebas/" del proyecto
write_csv(iris, "./datos/pruebas/iris.csv")

#- Otra vez exportamos en formato .csv el df iris. Esta vez explicitamos las opciones o parámetros de la función
write_csv(iris, path = "./datos/pruebas/iris.csv", col_names = TRUE)


#- para que se pueda correr en .Rmd en otra carpeta que no se la raiz
#- Otra vez exportamos en formato .csv el df iris. Esta vez explicitamos las opciones o parámetros de la función
write_csv(iris, path = here::here("./datos/pruebas/iris.csv"), col_names = TRUE)


#- importamos los datos del fichero "iris.csv" y los guardamos en un objeto que llamamos "iris_imp_csv". Recuerda que acabamos de exportar "iris" a la carpeta "/datos/pruebas/" dentro del Rproject
iris_imp_csv <- read_csv("./datos/pruebas/iris.csv")


#- Algunas opciones de read_csv() que conviene conocer
mis_datos <- read_csv("my_fichero.csv", skip = 5, na = c("-44", "$"), col_names = c("X1", "X2", "YY", "X4", "ZZ"))


#- Otros datos tabulares 
#- importamos los datos del fichero "iris.csv" y los guardamos en un objeto que llamamos iris_imp_csv_2. Fíjate en el argumento 'delim'
iris_imp_csv_2 <- read_delim("./datos/pruebas/iris.csv", delim = ",")

#- exportamos iris en formato tabular separado por punto y coma.
write_delim(iris, "./datos/pruebas/iris_2.txt", delim = ";")
#- exportamos iris en formato tabular separado por tabuladores
write_delim(iris, "./datos/pruebas/iris_3.txt", delim = "\t")
#- exportamos iris en formato tabular separado por un espacio en blanco
write_delim(iris, "./datos/pruebas/iris_4.txt", delim = " ")


#- exportamos iris en formato tabular separado por punto y coma.
read_delim("./datos/pruebas/iris_2.txt", delim = ";")
#- exportamos iris en formato tabular separado por tabuladores
read_delim("./datos/pruebas/iris_3.txt", delim = "\t")
#- exportamos iris en formato tabular separado por un espacio en blanco
read_delim("./datos/pruebas/iris_4.txt", delim = " ")



#- 4. Formatos propietarios -----------------------------------

#- exportar a Excel
library(xlsx)
write.xlsx(iris, "./datos/pruebas/iris.xlsx")

# library(xlsx)
write.xlsx(iris, "./datos/pruebas/iris.xlsx", sheetName = "IRIS", row.names = FALSE)

# library(xlsx)
write.xlsx(iris, "./datos/pruebas/iris.xlsx", sheetName = "IRIS_2", append = TRUE)

#library(writexl)
write_xlsx(iris, "./datos/pruebas/iris8.xlsx")


#- Si queremos IMPORTAR datos .xls o .xlsx
library(readxl)
iris_imp_xls <- read_excel("./datos/pruebas/iris.xlsx")

# library(readxl)
iris_imp_xls <- read_excel("./datos/pruebas/iris.xlsx", sheet = 2)
iris_imp_xls <- read_excel("./datos/pruebas/iris.xlsx", sheet = "IRIS_2")

# library(readxl)
# (!!!)
IRIS_list <- lapply(excel_sheets("./datos/pruebas/iris.xlsx"), read_excel, path = "./datos/pruebas/iris.xlsx")

# (!!!)
str(IRIS_list)

# (!!!)
primer_iris  <- IRIS_list[[1]]
segundo_iris <- IRIS_list[[2]]


#- Otros formatos propietarios -------------------
library(haven)
write_sav(iris, "./datos/pruebas/iris.sav")

# library(haven)
iris_imp_spss <- read_spss("./datos/pruebas/iris.sav")

library(foreign)
write.dta(iris, "./datos/pruebas/iris.dta")

# library(haven)
iris_imp_stata <- read_stata("./datos/pruebas/iris.dta")

# mtcars es un dataset  del pkg ggplot2, asi que ggplot2 debe estar cargado
library(ggplot2)
library(haven)
write_sas(mtcars, "./datos/pruebas/mtcars.sas")

# library(haven)
mtcars_imp_sas <- read_sas("./datos/pruebas/mtcars.sas")



#- 5. Formato(s) propios de R ------------------------------------

#- exporta en formato .RData el df my_iris al fichero "iris.RData".
save(iris, file = "./datos/pruebas/iris.RData")

save(mtcars, iris,  file = "./datos/pruebas/mtcars_and_iris.RData")

#- gurada todos los objetos de una sesión, pero mejor NO hacerlo
save(list = ls(all = TRUE), file= "./datos/pruebas/all_objects.RData")

#- tb puedo guardar todo el espacio de trabajo
save.image(file = "./datos/pruebas/my_work_space.RData")

load("./datos/pruebas/all_objects.RData")
load("./datos/pruebas/my_work_space.RData")

#- importamos el fichero "my_data2.RData"
load(file = "./datos/pruebas/iris.RData")


#- RDS (Serialized R objects) ---------------------
write_rds(iris, "./datos/pruebas/iris.rds")

iris_imp_rds <- readRDS("./datos/pruebas/iris.rds")



#- 6. Otros formatos ------------------------------------
library(rio)
export(mtcars, "./datos/pruebas/mtcars.csv")   # comma-separated values
export(mtcars, "./datos/pruebas/mtcars.rds")   # R serialized
export(mtcars, "./datos/pruebas/mtcars.sav")   # SPSS
export(mtcars, "./datos/pruebas/mtcars.json")  # JSON
export(mtcars, "./datos/pruebas/mtcars.arff")  # Weka Attribute-Relation File Format

#- library(rio)
export(mtcars, "./datos/pruebas/mtcars.tsv.zip") # TSV & Zip it

#- library(rio)
mtcars_csv  <- import("./datos/pruebas/mtcars.csv")  # CSV
mtcars_spss <- import("./datos/pruebas/mtcars.sav")  # SPSS (.sav)

#- library(rio)
mtcars_csv  <- import("./datos/pruebas/mtcars.csv", setclass = "tibble")  # CSV

my_url <- "http://www.scoresway.com/?sport=soccer&page=competition&id=8"
table <- import(my_url, format = "html", which = 2)



#- Descargar datos de internet ------------------------------------
# cargamos los datos del fichero "bio260-heights.csv"
url <- "https://raw.githubusercontent.com/datasciencelabs/data/master/bio260-heights.csv"
datos <- read_csv(url)

# descargamos y almacenamos en nuestro PC los datos del fichero "bio260-heights.csv"
url <- "https://raw.githubusercontent.com/datasciencelabs/data/master/bio260-heights.csv"
destino <- "./datos/pruebas/bio260-heights.csv"
download.file(url, destino)
dat <- read.csv(destino)

#install.packages("downloader")
library(downloader)
url <- "https://raw.githubusercontent.com/datasciencelabs/data/master/bio260-heights.csv"
filename <- basename(url)
destino <- paste0("./datos/pruebas/", filename)
download(url,destino)
dat <- read.csv(destino)



#- 8. APIs y Webscrapping --------------------------------------


# install.packages("eurostat")
library("eurostat")
df <- get_eurostat("cult_emp_sex", time_format = 'raw', keepFlags = T)       #- bajamos los datos de la tabla "cult_emp_sex": empleo cultural por genero"

#------------------ podemos buscar un  "tema" con la f. search_eurostat()
aa <- search_eurostat("employment", type = "all") 

#------------------ elegimos una tabla de Eurostat
my_table <- "hlth_silc_17"          #- elegimos una tabla; por ejemplo "hlth_silc_17": "Healthy life expectancy based on self-perceived health"
label_eurostat_tables(my_table)     #- da informacion sobre la Base de datos q estas buscando

#------------------ descargamos los datos con get_eurostat()
df <- get_eurostat(my_table, time_format = 'raw', keepFlags = T )       #- bajamos los datos de una tabla
df_l <- label_eurostat(df)        #- pone labels: Spain en lugar de su código (mas legible,menos fácil de programar)

#------------------ los arreglamos un poco 
library("tidyverse")
library("pjpv2020.01") #- remotes::install_github("perezp44/pjpv2020.01")
aa <- pjp_f_valores_unicos(df)       #- ver los valores unicos de cada columna
aa <- pjp_f_valores_unicos(df_l)     #- ver los valores unicos de cada columna
df <- label_eurostat(df, code = c("geo", "unit", "indic_he"))


#- este sí funcionará
df_x <- df %>% filter(time == "2016") %>%  filter(sex == "Females") %>% filter(indic_he_code == "HE_50") %>% 
        mutate(cat = cut_to_classes(values, n = 7, decimals = 1))

geometrias <- get_eurostat_geospatial(resolution = "20", nuts_level = "0") #- ahora se bajan las geometrías y tienes que unirla tu con dplyr (Hay un Pb de encoding)
mapdata <- inner_join(geometrias, df_x, by = c("geo" = "geo_code"))

p <- ggplot(mapdata) +
  geom_sf(aes(fill = cat, geometry = geometry), color = "black", size = .1) +
  scale_fill_brewer(palette = "RdYlBu") +
  labs(title = "Healthy life expectancy, 2016",
       subtitle = "Health expectancy in years at 50",
       fill = "Healthy life expectancy",
       caption = "(C) EuroGeographics for the administrative boundaries") + theme_light() +
  coord_sf(xlim = c(-12, 44), ylim = c(35, 67)) 
p


#- INE ----------------------------------------------
## library("pxR")              #- para trabajar con datos PC-Axis
## library("tidyverse")
## library("pjpv2020.01")
## file_name <- "http://www.ine.es/jaxiT3/files/t/es/px/4189.px?nocab=1"
## df <- read.px(file_name) %>% as.data.frame() %>% as.tbl()   #- no funcionaba en 3.5 x $
## aa <- pjpv2020.01::pjp_f_valores_unicos(df)     #- ver los valores únicos de cada columna

## #install.packages("WDI")
## library("WDI")
## 
## #---- buscamos datos relacionados con GDP
## aa <- WDIsearch('gdp')
## aa <- WDIsearch('gdp.*capita.*constant')
## 
## #---- descargamos "NY.GDP.PCAP.KD":  GDP per capita (constant 2010 US$)
## df <- WDI(indicator = "NY.GDP.PCAP.KD")
## #---- podemos filtrar la querry
## df <- WDI(indicator = "NY.GDP.PCAP.KD", country = c('MX','CA','US'), start = 1960, end = 2017)

## #install.packages("wbstats")
## library("wbstats")
## 
## #-------  lista de indicadores disponibles
## aa <- wb_cachelist
## 
## #---- buscamos datos relacionados con GDP
## aa <- wbsearch(pattern = "gdp")
## aa <- wbsearch('gdp.*capita.*constant')
## 
## #---- descargamos "NY.GDP.PCAP.KD":  GDP per capita (constant 2010 US$)
## df <- wb(indicator = "NY.GDP.PCAP.KD")
## 
## #---- podemos filtrar la querry
## df <- wb(indicator = "NY.GDP.PCAP.KD", country = c('MX','CA','US'), startdate = 2000, enddate = 2017)

## #install.packages("rcrossref")
## library("rcrossref")
## 
## #----- con cr_cn() podemos ver como se cita un determinado artículo en un determinado formato, por ejemplo "apa"
## my_doi <- "10.1111/j.1467-6486.2012.01072.x"
## cr_cn(dois = my_doi, format = "text", style = "apa")
## 
## cr_cn(dois = my_doi, format = "bibtex", style = "apa", locale = "en-US", raw = FALSE, progress = "none")
## 
## #------ con cr_citation_count() puedes ver el numero de citas de un artículo/DOI
## aa <- cr_citation_count(doi = my_doi)
## 
## #------ con cr_abstract()
## aa <- cr_abstract(doi = "10.1109/TASC.2010.2088091")
## 
## #------ con cr_journals() vemos journals
## aa <- cr_journals(query = "economics", limit = 100) %>% .$data %>% as.tibble()
## 
## #------ mucha informacion del articulo
## aa <- cr_works(dois = my_doi) %>% .$data %>% as.tibble()

## library(XML)
## 
## url <- "http://www.comuniazo.com/comunio/jugadores"
## url <- "https://www.comuniazo.com/comunio/jugadores"
## 
## jugadores <-  readHTMLTable(url, stringsAsFactors = T, colnames = c("Posicion","Equipo","Jugador","Puntos","Media","Puntos_Casa","Media_Casa","Puntos_Fuera","Media_fuera", "Valor"), colClasses = c("character","character","character","FormattedNumber","FormattedNumber","FormattedNumber","FormattedNumber","FormattedNumber","FormattedNumber"))
## 
## aa <- jugadores[[1]] %>% as.tibble()

library("rvest")
library("tidyverse")
content <- read_html("https://es.wikipedia.org/wiki/Anexo:Municipios_de_la_provincia_de_Teruel")

body_table <- content %>% html_nodes('body')  %>%
                    html_nodes('table') %>%
                    html_table(dec = ",") 
Teruel <- body_table[[1]]
names(Teruel) <- c("Nombre", "Extension", "Poblacion", "Densidad", "Comarca", "Partido_judicial", "Altitud")
library(stringr)
Teruel <- Teruel %>% map(str_trim) %>% as_tibble() #- quita caracteres al final
Teruel <- Teruel %>% mutate(Altitud = str_replace_all(Altitud,"[[:punct:]]", "")) 
Teruel <- Teruel %>% mutate(Altitud = as.double(Altitud)) %>% arrange(desc(Altitud))

library(kableExtra)
aa <- Teruel %>% select(1,3,5,7) %>%  slice(1:4) 
#knitr::kable(aa, digits = 2, align = "c", caption = "Los 4 municipios de Teruel con más altitud" )
knitr::kable(aa, "html", digits = 2,  caption = "Los 4 municipios de Teruel con más altitud") %>%
  kable_styling(bootstrap_options = c("striped", "hover"))
