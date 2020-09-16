#- Ejemplo nº 01 del curso
#- ejemplo simple para familiarizarse un poco con el entorno de RStudio y la sintaxis de R
#- este ejemplo, "ejemplifica" qué es la Ciencia de Datos, se ven las etapas típicas de un análisis de datos
#- las etapas básicamente son 5. 1) importar/cargar datos, 2) arreglar los datos o data wrangling 3) análisis exploratorio 4) Modelización y 5) presentación de resultados



#- cargamos paquetes en memoria (antes tienes que haberlos instalado en tu PC)
library(tidyverse)  #- install.packages("tidyverse")
library(ggthemes)   #- #install.packages("ggthemes")

#- Etapa 1: importar/cargar datos ---------------------------------------------------------
#- cargamos 2 conjuntos de datos
nivel_CO2   <- read.table("ftp://aftp.cmdl.noaa.gov/products/trends/co2/co2_annmean_mlo.txt")
temperatura <- read.table("https://go.nasa.gov/2r8ryH1", skip = 5)


#- Etapa 2: arreglamos un poco los datos ------------------------------------
df_1 <- temperatura %>% mutate(celsius = V2*100)  %>%  #- creamos la variable "celsius" como V2*100
                        select(-c(V2,V3))              #- eliminamos las variables V2 y V3 del df "temperatura"

df_2 <- nivel_CO2 %>% rename(CO2 = V2) %>% select(-V3)  #- ¿qué estamos haciendo?


#- fusionamos las 2 tablas (dataframes) de datos -----
datos <- inner_join(df_1, df_2)

#- Etapa 3): análisis exploratorio -------------------------------------------------

# hacemos gráficos con R-base -----
plot(datos$CO2, datos$celsius)

#- hacemos gráficos con el pkg ggplot2 -----
ggplot(datos, aes(CO2, celsius)) + geom_point()



#- hacemos más gráficos con ggplot2 -----
ggplot(datos, aes(CO2, celsius)) + geom_point() + geom_smooth()

ggplot(datos, aes(CO2, celsius)) + geom_point() + geom_smooth() + geom_smooth(method = "lm", colour = "red")

ggplot(datos, aes(CO2, celsius)) + geom_point() + geom_smooth(method = "lm") +
    xlab("CO2") + ylab("Temperatura") + theme_dark()

ggplot(datos, aes(CO2, celsius)) + geom_point() + geom_smooth(method = "lm") +
    labs(title = "Temperatura vs. CO2",
         subtitle = "1959-2018",
         caption = "https://go.nasa.gov/2r8ryH1",
         x = "Nivel de CO2")


#- veamos mas themes() -----
# https://yutannihilation.github.io/allYourFigureAreBelongToUs/ggthemes/
# https://exts.ggplot2.tidyverse.org/gallery/        #- pegadle un vistazo a esta gallery


my_plot <- ggplot(datos, aes(CO2, celsius)) + geom_point() + geom_smooth(method = "lm") +
    labs(title = "Temperatura vs. CO2",
         subtitle = "1959-2018",
         caption = "https://go.nasa.gov/2r8ryH1",
         x = "Nivel de CO2")


my_plot  + theme_economist()

my_plot + theme_stata()

my_plot + theme_fivethirtyeight()

my_plot + theme_excel()

#- TAREA: poner la linea de regresión en "my_plot" de color verde [pista: colour = "green"]





#- Etapa 4): Modelización -------------------------------------------------

#- planteamos y estimamos un modelo lineal ---
lm(formula = celsius ~ CO2, data = datos)

my_model <- lm(celsius ~ CO2, datos)
summary(my_model)



#- Etapa 5): Presentación de resultados -----------------------------------------
#- para hacer tablas hay multitud de paquetes. Por ejemplo
library(jtools)        #- install.packages("jtools")
jtools::summ(my_model)
summ(my_model, confint = TRUE, digits = 3) #- con intervalo de confianza





