#- script de las slides 05: importar datos

(.packages())   #- nos da los nombres de los "currently attached packages"
aa <-  as.data.frame(.packages())

iris
str(iris)     #- qué es iris?
find("iris")  #- donde estaba iris?

my_iris <- iris  #- "hacemos" una copia de iris?
find("my_iris")

iris <- iris
find("iris")

#-----------------------
#- install.packages("palmerpenguins")
library(palmerpenguins)
data(package = "palmerpenguins")  #- el paquete tiene 2 conjuntos de datos

#- ya podemos usar los datos de penguins xq hemos cargado (attach) el paquete en memoria de R
penguins
my_penguins <- penguins

#- quiero tb hablaros de la siguiente expresión
palmerpenguins::penguins


#---------------------------
rm(list = ls()) #- antes vamos a limpiar el Global env.

la_direccion <- "https://raw.githubusercontent.com/perezp44/iris_data/master/data/iris.csv"

rio::import(la_direccion)    #- ¿qué ha pasado???

aa <-  rio::import(la_direccion)  #- como un data.frame
bb <- rio::import(la_direccion, setclass = "tibble")  #- como tibble
cc <- tibble::as_tibble(aa)


#------------------------
rm(list = ls()) #- antes vamos a limpiar el Global env.

my_iris <- iris

rio::export(my_iris, "my_iris.csv")

rio::export(x = my_iris, file = "my_iris.csv")

#- 
fs::dir_create("pruebas")   #- creo el subdirectorio
rio::export(my_iris, "./pruebas/my_iris.csv")


ruta <- here::here("pruebas", "my_iris.csv")
rio::export(my_iris, ruta)

rio::export(my_iris, here::here("pruebas", "my_iris.csv"))


rio::export(iris, here::here("pruebas", "iris.csv"))
rio::export(iris, here::here("pruebas", "iris.xlsx"))
rio::export(iris, here::here("pruebas", "iris.sav"))

rio::export(palmerpenguins::penguins, here::here("pruebas", "pinguinos.csv"))
rio::export(palmerpenguins::penguins, here::here("pruebas", "pinguinos.xlsx"))
rio::export(palmerpenguins::penguins, here::here("pruebas", "pinguinos.dta"))

rm(list = ls())
iris_1 <- rio::import(here::here("pruebas", "iris.csv"))
iris_2 <- rio::import(here::here("pruebas", "iris.xlsx"))

pinguinos_1 <- rio::import(here::here("pruebas", "pinguinos.csv"))
pinguinos_2 <- rio::import(here::here("pruebas", "pinguinos.xlsx"))
pinguinos_3 <- rio::import(here::here("pruebas", "pinguinos.dta"))


#- en esta url hay un fichero de datos en formato .csv
my_url <- "https://raw.githubusercontent.com/perezp44/iris_data/master/data/iris.csv"
download.file(url = my_url, 
              destfile = here::here("pruebas", "iris_descargado.csv"))


aa <- rio::import(my_url)


#- bonus: le añadimos un libro mas al archivo "./pruebas/iris.xlsx"
#- bonus: le añadimos un libro mas al archivo "./pruebas/iris.xlsx"
#- bonus: le añadimos un libro mas al archivo "./pruebas/iris.xlsx"
rio::export(x = iris, 
            file = here::here("pruebas", "iris.xlsx"), 
            which = "iris_2")

#- Bonus 2
rio::export(x = list(iris = iris, pinguinos = palmerpenguins::penguins), 
            file = here::here("pruebas", "my_iris_pinguinos.xlsx"))

#- Bonus 3
iris_1 <- rio::import(here::here("pruebas", "my_iris_pinguinos.xlsx"))  #- solo importa el primer libro

pinguinos_1 <- rio::import(here::here("pruebas", "my_iris_pinguinos.xlsx"), 
                                      sheet = 2)
pinguinos_2 <- rio::import(here::here("pruebas", "my_iris_pinguinos.xlsx"), 
                                      sheet = "pinguinos")


#- Bonus 4
library(readxl)
my_dfs_list <- lapply(excel_sheets(here::here("pruebas", "my_iris_pinguinos.xlsx")), 
                      read_excel,
                      path = here::here("pruebas", "my_iris_pinguinos.xlsx"))


#- Bonus 5

#- importamos todos los archivos que hemos creado en "./pruebas/"
library(purrr)
my_carpeta <- here::here("pruebas")
lista_de_archivos <- list.files(my_carpeta)  #- Ok con base ...
lista_de_archivos <- fs::dir_ls(my_carpeta)  #- pero mejor con el pkg "fs"
my_dfs_list_2 <- map(lista_de_archivos, rio::import)


#- limpiamos ---------------------------------------
#- vamos a borrar los archivos q hemos creado:
list.files("./pruebas")     #- listado de archivos en la carpeta "./pruebas"
file.remove("./pruebas/pinguinos.dta")   #- xq no funciona

#- borramos todos los archivos de ./pruebas/
file.remove(file.path("./pruebas", list.files("./pruebas"))) 

#  borramos toda la carpeta
fs::dir_delete("pruebas")




# retrieve Facebook quotes
x <- quantmod::getSymbols(Symbols = 'FB', src = 'yahoo', auto.assign = FALSE)   
tail(x)





#- Webscrappin

https://es.wikipedia.org/wiki/Pandemia_de_enfermedad_por_coronavirus_de_2020_en_Espa%C3%B1a


library("rvest")
library("tidyverse")
my_url <- "https://es.wikipedia.org/wiki/Pandemia_de_enfermedad_por_coronavirus_de_2020_en_Espa%C3%B1a"
content <- read_html(my_url)
body_table <- content %>% html_nodes('body')  %>%
  html_nodes('table') %>%
  html_table(dec = ",", fill = TRUE) 

tabla_8 <- body_table[[8]]  
tabla_11 <- body_table[[11]]  
