#- fichero .R con el código del tutorial tt_05_data-munging.Rmd ----------------
library("tidyverse")
library("haven")
#library("xlsx")
library("foreign")
library("readxl")
library("gapminder")

#- APRENDIENDO the PIPE (%>%) --------------------------------------------------

#- Las siguientes dos instrucciones de R hacen exactamente lo mismo:
library(palmerpenguins)

head(penguins, n = 4)         #- forma habitual de llamar/usar la función head()

penguins %>% head(. , n = 4)  #- usando el operador pipe


#- estas tres instrucciones son equivalentes.
head(penguins, n = 4)         #- forma habitual de llamar/usar la función head()

penguins %>% head(. , n = 4)  #- usando el operador pipe (con el punto actuando como placeholder)

penguins %>% head(n = 4)      #- usando el operador pipe (SIN el punto)


#-  Intentad ver si entendéis la siguiente instrucción:
4 %>% head(penguins, .)

#- por qué no funciona la siguiente instrucción:
4 %>% head(penguins)


#- El operador pipe podemos leerlo como “entonces” y permite encadenar sucesivas llamadas a funciones.
penguins %>% filter(sex == "female") %>%
             group_by(species) %>%
             summarise(peso_medio = mean(body_mass_g))


#- TAREA: entender la siguiente linea --------------------
letters %>% paste0( "-----" ,  .  ,  "!!!" ) %>% toupper

#- (!!!!!!) The “tee pipe” (%T>%) permite hacer cosas como esta:
rnorm(200) %>% matrix(ncol = 2) %T>%
plot %>% # plot usually does not return anything.
colSums

#- (!!!!) The “exposition pipe” (%$%) hace accesibles las columnas de un dataframe 
library(magrittr)
iris %>% mean(Sepal.Length)   #- no funciona
iris %$% mean(Sepal.Length)   #- con the exposition pipe sí funciona

iris %>% cor(Sepal.Length, Sepal.Width)  #- no funciona
iris %$% cor(Sepal.Length, Sepal.Width)

cor(iris$Sepal.Length, iris$Sepal.Width) #- cor sin usar the pipe


#- Muchas funciones de R-base no están preparadas para trabajar con el operador pipe.
library(tidyverse)

x1 <- c(-5:5, NA)  #- es un vector

#- escribiendo à la R-base
mean(x1[x1>0], na.rm = TRUE)   #-  calcula la media de los valores positivos de x1
sum(x1[!is.na(x1)])            #-  calcula la suma de los valores de x1 que no son NA

#- ahora haremos lo mismo, seguimos usando R-base, pero con el operador pipe (!!!!)
x1 %>% .[.>0] %>% mean(., na.rm = TRUE)
x1 %>% .[!is.na(.)]  %>% sum

#- podríamos trabajar con data.frames usando the exposition pipe
df <- as.data.frame(x1)   #- tidyverse usa data.frames
df %$% x1 %>% .[.>0] %>% mean(., na.rm = TRUE)
df %$% x1 %>% .[!is.na(.)]  %>% sum

#- con tydiverse
df <- as.data.frame(x1)   #- tidyverse usa data.frames
df %>% filter(x1 > 0) %>% summarise(mean_x1 = mean(x1, na.rm = TRUE))
df %>% filter(!is.na(x1)) %>% summarise(suma_x1 = sum(x1))




#- TIDY data --------------------------------------------------------------

#- Un ejemplo de datos (no tidy)
data_1 <- data.frame(
            year  = c("2014", "2015", "2016"),  
            Pedro = c(100, 500, 200), 
            Carla = c(400, 600, 250), 
            María = c(200, 700, 900)  )
data_1


data_2 <- data.frame(names = c("Pedro", "Carla", "María"), 
                      W_2014 = c(100, 400, 200), 
                      W_2015 = c(500, 600, 700),
                      W_2016 = c(200, 250, 900)   )
data_2

data_3 <- data.frame(
            names =rep(c("Pedro", "Carla", "María"), times = 3),  
            year = rep(c("2014", "2015", "2016"), each = 3),
            salario = c(100, 400, 200, 500, 600, 700, 200, 250,900) )
data_3


#- De wide a long format con pivot_longer() -----------------
library(tidyr)
data_wide <- data_2   #- data_2 está en formato ancho (wide)

#- la función pivot_longer() transforma los datos de formato ancho(wide) a formato largo(long)
data_long <- data_wide %>% pivot_longer(cols = 2:4, names_to = "periodo")

#(!!) stringr::str_replace encuentra el texto "W_" en la columna "periodo" y lo sustituye por ""
data_long <- data_long %>% mutate(periodo = str_replace(periodo, "W_", "" ))

#- De long a wide format con pivot_wider() -----------
#- `pivot_longer()` convierte un df de long a wide
data_wide2 <- data_long %>% pivot_wider(names_from = periodo, values_from = value)


#- separate() y unite() -----------------------------------------
#- funciones para separar y unir columnas
df <- data.frame( names = c("Pedro_Navaja", "Bob_Dylan", "Cid_Campeador"), 
                  year  = c(1978, 1941, 1048) )
df

#- Separamos la primera columna:
df_a <- df %>% separate(names, c("Nombre", "Apellido"), sep = "_")
df_a

#- Si queremos volver a unirlos, tendríamos que:
df_b <- df_a %>% unite(Nombre_y_Apellido, Nombre:Apellido, sep = "&")
df_b


#- DPLYR -----------------------------------------------------------
#- DPLYR -----------------------------------------------------------

#- las 3 hacen lo mismo. Por qué no funcionan?
df_new <- filter(df, X1 >= 10)

df_new <- df %>% filter(. , X1 >= 10)

df_new <- df %>% filter(X1 >= 10)

#- vamos a trabajar con los datos del [pkg gapminder](https://github.com/jennybc/gapminder)
gapminder <- gapminder::gapminder

#- Observaciones de España (country == "Spain")
aa <- gapminder %>% filter(country == "Spain")

#- filas con valores de "lifeExp" < 29
aa <- gapminder %>% filter(lifeExp < 29)

#- filas con valores de "lifeExp" entre [29, 32]
aa <- gapminder %>% filter(lifeExp >=  29 , lifeExp <= 32)
aa <- gapminder %>% filter(lifeExp >=  29 &  lifeExp <= 32)
aa <- gapminder %>% filter(between(lifeExp, 29, 32))

#- observaciones de paises de África con lifeExp > 32
aa <- gapminder %>% filter(lifeExp > 72 &  continent == "Africa")

#- observaciones de países de África o Asia con lifeExp > 32
aa <- gapminder %>% filter(lifeExp > 72 &  continent %in% c("Africa", "Asia") )
aa <- gapminder %>% filter(lifeExp > 72 & (continent == "Africa" | continent == "Asia") )

#- slice() también es muy útil para seleccionar filas ---------------
#- selecciona las observaciones de la décima a la quinceava
aa <- gapminder %>% slice(c(10:15))

#- selecciona las observaciones de la 12 a 13 Y de la 44 a 46, Y las 4 últimas
aa <- gapminder %>% slice( c(12:14, 44:46, n()-4:n()) ) #- AQUI hay un error, tenéis que arreglarlo.

#- Pista: igual os ayuda crear una columna con el índice de rows y repetir el cálculo
aa <- gapminder %>% mutate(index = 1:n())
aa <- gapminder %>% slice( c(12:14, 44:46, n()-4:n()) )


#- variantes de slice() -------------------------------------
#- selecciona las 3 filas con mayor valor de lifeExp
aa <- gapminder %>% slice_max(lifeExp, n = 3)
#- selecciona las 4 filas con MENOR valor de pop
aa <- gapminder %>% slice_min(pop, n = 4)

#- observaciones en el primer decil en cuanto a esperanza de vida, 10% con menor esperanza de vida
aa <- gapminder %>% slice_min(lifeExp, prop = 0.1)
#- 1% de observaciones con mayor población. Imagino que estarán China e India
aa <- gapminder %>% slice_max(pop, prop = 0.01)

#- selecciona (aleatoriamente) 100 filas de los datos
aa <- gapminder %>% slice_sample(n = 100)
#- selecciona (aleatoriamente) un 5% de los datos
aa <- gapminder %>% slice_sample(prop = 0.05)



#- arrange() ---------------------------------------
#- ordena las filas de MENOR a mayor según los valores de la v. lifeExp
aa <- gapminder %>% arrange(lifeExp)

#- ordena las filas de MAYOR a menor según los valores de la v. lifeExp
aa <- gapminder %>% arrange(desc(lifeExp))

#- ordenada las filas de MENOR a mayor según los valores de la v. lifeExp.
#- Si hay empates se resuelve con la variable "pop"
aa <- gapminder %>% arrange(lifeExp, pop)


#- rename() -----------------------------------------------
#- cambia los nombres de lifeExp y gdpPercap a life_exp y gdp_percap
gapminder %>% rename(life_exp = lifeExp,  gdp_percap = gdpPercap)

#-(!!) la función names() de R-base es muy útil. Tb setNames() y set_names()
aa <- gapminder
names(aa) <- names(aa) %>% toupper
names(aa) <- names(aa) %>% tolower
names(aa) <- c("var_01", "var_02", "var_03", "var_04", "var_05" , "var_06")
names(aa) <- paste0("Var_", 1:6)
names(aa) <- paste0("Lag_", formatC(1:6, width = 2, flag = "0"))

#- rename_with() , una variante de rename()
aa <- gapminder
rename_with(aa, toupper)
rename_with(aa, toupper, starts_with("Life") | contains("countr"))
rename_with(aa, ~ str_replace(.x, "e", "Ö"))  #- (!!!!)



#- select() --------------------------------------------------------
#- Se lee como: “Take el df gapminder, then select the variables year and lifeExp”
aa <- gapminder %>% select(year, lifeExp)
aa <- gapminder %>% select(c(year, lifeExp))


#- eliminar  variables ---
aa <- gapminder %>% select(-year)   #- la forma mas habitual

#- estas dos formas son mucho menos habituales
aa <- gapminder %>% select(!year)   
aa <- gapminder %>% mutate(year = NULL)   #- aún no hemos visto mutate()

#- quitamos las variables: year y lifeExp
aa <- gapminder %>% select(-c(year, lifeExp))

#- seleccionamos las variables {1, 2, 3 y 5}
aa <- gapminder %>% select(1:3, 5)

#- quitamos las variables {1, 2, 3 y 5}
aa <- gapminder %>% select(- c(1:3, 5))


#- select() con la función auxiliar where() -----------------
#- En el data.frame gapminder las 2 primeras variables (country y continent) son factores y las 4 siguientes son variable numéricas.
print(gapminder, n = 3)

aa <- gapminder %>% select(is.numeric)        #- funciona, pero ...
aa <- gapminder %>% select(where(is.numeric)) #- es "preferible" esta segunda expresión

aa <- gapminder %>% select(!is.numeric)
aa <- gapminder %>% select(!where(is.numeric))  #- es preferible esta segunda expresión

#- renombrando y reordenando columnas con select()
#- dejamos en aa solamente a las columnas "year" y "pop"; ADEMÁS, ahora, "pop" irá antes que "year"
aa <- gapminder %>% select(pop, year)

#- dejamos en aa solamente a las columnas "year" y "pop" y les cambiamos el nombre
aa <- gapminder %>% select(poblacion = pop, año = year)


#- Imagina que quieres que la última columna pase a ser la primera (manías!!). Podemos hacerlo con select y everything(). everything es una función auxiliar
#- "gdpPercap" que es la última columna pasa a ser la primera
aa <- gapminder %>% select(gdpPercap, everything())

#(!!) otras 3 formas de hacer lo mismo: que la última columna pase a ser la primera
aa <- gapminder %>% select(ncol(df), everything())
aa <- gapminder %>% select(length(df), everything())
aa <- gapminder %>% select(last_col(), everything())  #- usamos the selection helper last_col()


#- relocate() ---------------------------------------------------
aa <- gapminder %>% dplyr::relocate(country, .after = lifeExp)
aa <- gapminder %>% dplyr::relocate(country, .before = lifeExp)


#- mutate() --------------------------------------------------
#- Creamos la variable: GDP = pop*gdpperCap
aa <- gapminder %>% mutate(GDP = pop*gdpPercap)

aa <- gapminder %>% mutate(GDP = pop*gdpPercap, .after = country)
aa <- gapminder %>% mutate(GDP = pop*gdpPercap, .before = country)

aa <- gapminder %>% mutate(GDP = pop*gdpPercap, .keep = "used")



#- summarise() -----------------------------------------------------
#- retornará un único valor: la media global de la v. "lifeExp"
aa <- gapminder %>% summarise(media = mean(lifeExp))

#- retornará un único valor: el número de filas
aa <- gapminder %>% summarise(NN = n())
aa <- gapminder %>% count()                #- más adelante veremos la utilidad de count()


#- retornará un único valor: la desviación típica de la v. "lifeExp"
aa <- gapminder %>% summarise(desviacion_tipica = sd(lifeExp))

#- retornará un único valor: el máximo de la variable "pop"
aa <- gapminder %>% summarise(max(pop))

#- retornará 2 valores: la media y sd de la v. "lifeExp"
aa <- gapminder %>% summarise(mean(lifeExp), sd(lifeExp))

#- retornará 2 valores: las medias de "lifeExp" y "gdpPercap"
aa <- gapminder %>% summarise(mean(lifeExp), mean(gdpPercap))


#- across() y where() -----------------------------------------------
#- media de cada una de las 6 variables. Devuelve 2 warnings porque las 2 primeras son textuales. No se puede calcular la media de continent y country
gapminder %>% summarise(across(everything(), mean) )

#- calculamos la media de tercera a la sexta variable
gapminder %>% summarise(across(3:6, mean) )

gapminder %>% summarise(across(where(is.numeric), mean))

#- con los nombres de los argumentos (más largo pero conviene verlo de vez en cuando)
gapminder %>% summarise(across(.cols = where(is.numeric), .fns = mean))

#- calculamos la media y desviación típica de las columnas 3 a 6.
gapminder %>% summarise(across(3:6, list(media = mean, desv = sd)))

#- lo mismo, pero explicitando los nombres de los argumentos
gapminder %>% summarise(across(.cols = 3:6, .fns = list(media = mean, desv = sd) ))

#- lo mismo otra vez, pero eligiendo el nombre de las variables que se van aa crear con .names
gapminder %>% summarise(across(3:6, list(media = mean, desv = sd), .names = "{fn}_{col}"))


#- (!!!)Imagina que quisiéramos presentar en una tabla los anteriores resultados; tendríamos que usar tidyr::pivot_longer(). Lo voy a hacer por trozos. Nos va a costar un poco:

aa <- gapminder %>% summarise(across(3:6, list(media = mean, desv = sd), .names = "{fn}_{col}")) 

aa1 <- aa %>% pivot_longer(1:8, names_to = "names", values_to = "values")
aa2 <- aa1 %>% separate(names, into = c("operacion", "variable"), sep =  "_") %>% 
               select(variable, everything())
aa3 <- aa2 %>% pivot_wider(1:3, names_from = operacion, values_from = values)



#- group_by() -----------------------------------------------------

#- cogemos df y lo (des)agrupamos por grupos definidos por la variable "continent"; osea, habrá 5 grupos
#- después con summarise() calcularemos el nº de observaciones en cada continente o grupo; es decir, nos retornará un df con una fila por cada continente
aa <- gapminder %>% group_by(continent) %>% summarise(NN = n()) 
aa

aa <- gapminder %>% group_by(continent) %>% count()
aa <- gapminder %>% group_by(continent) %>% count(name = "NN")
aa

#- cogemos df y lo agrupamos por "continent", 
#- después calculamos 2 cosas: el número de observaciones o rows
#- y el número de países en cada continente (NN_countries)
aa <- gapminder %>% group_by(continent) %>%  
          summarize(NN = n(), 
                    NN_countries = n_distinct(country)) 
aa

#- cogemos df y lo agrupamos por "continent", después calculamos la media de "lifeExp"
aa <- gapminder %>% group_by(continent) %>%  
                    summarize(mean(lifeExp)) 
aa

#- cogemos df y filtramos para quedarnos con las observaciones de 1952
#- después lo agrupamos por "continent", 
#- después calculamos la media de "lifeExp"
gapminder %>% filter(year == "1952") %>%  
              group_by(continent) %>%  
              summarize(mean(lifeExp)) 


#- Se pueden calcular varios estadísticos a la vez --
#- cogemos df y filtramos (cogemos) las observaciones de 1952 y 2007
#- agrupamos por "continent",
#- después calculamos la media de "lifeExp" y de "gdpPercap"
gapminder %>% filter(year %in% c(1952, 2007)) %>%
             group_by(continent, year) %>%
             summarize(mean(lifeExp), mean(gdpPercap))

#- Vamos a hacer cálculos cada vez más complejos:
#- cogemos df y lo agrupamos por "continent" y "year",
#- después calculamos la media de "lifeExp" y de "gdpPercap"
gapminder %>% filter(year %in% c(1952, 2007)) %>%
              group_by(continent, year) %>%
              #- después calculamos la media de "lifeExp"
              summarise(media = mean(lifeExp))

#- Voy a crear un nuevo df: "gapminder_gr" o "gapminder agrupado"
gapminder_gr <- gapminder %>% filter(year %in% c(1952, 2007)) %>%
                 group_by(continent, year)
#- y sobre "gapminder_gr" iremos haciendo cálculos

#- si queremos calcular la media de varias variables tenemos que usar across()
gapminder_gr %>% summarise(across(c(lifeExp, gdpPercap), mean))

#- si queremos calcular la media de todas las variables numéricas tenemos que usar across() y where()
gapminder_gr %>% summarise(across(where(is.numeric), mean))

#- si queremos calcular la media y la mediana, hay que usar list()
gapminder_gr %>% summarise(across(c(lifeExp, gdpPercap),
                            list (media = mean, mediana = median) ))

#- si ponemos los nombres de los argumentos quedaría como
gapminder_gr %>% summarise(across(.cols = c(lifeExp, gdpPercap),
                                  .fns = list (media = mean, mediana = median)))

#- además, podemos controlar el nombre de las variables creadas con el argumento .names
gapminder_gr %>% summarise(across(c(lifeExp, gdpPercap),
                        list (media = mean, mediana = median),
                        .names = "{fn}_{col}"))



#- Preguntas de verdad ---------------------------------------------
#- cogemos df y lo agrupamos por "continent", después calculamos la media de "lifeExp"
gapminder %>% 
  filter(year %in% c(1952, 2007)) %>%  
  group_by(continent, year) %>% 
  summarize(media = mean(lifeExp)) %>% ungroup()

#- primer intento: se puede hacer de una vez, pero vamos a partir el código en 2 trozos
aa <- gapminder %>% filter(year %in% c(1952, 2007)) %>%  
  group_by(continent, year) %>% 
  summarize(media = mean(lifeExp)) %>% ungroup() 

aa1 <- aa %>% group_by(continent) %>% 
  summarise(min_l = min(media), max_l = max(media)) %>% 
  mutate(dif = max_l-min_l) %>% 
  arrange(desc(dif))

aa1

#- segundo intento: se puede hacer de una vez, pero vamos a partir el código en 2 trozos
aa <- gapminder %>% filter(year %in% c(1952, 2007)) %>%  
         group_by(continent, year) %>% 
         summarize(media = mean(lifeExp)) %>% ungroup() 

#- usamos lag()
aa1 <- aa %>% group_by(continent) %>% 
              arrange(year) %>%
              mutate(variac_l = media - lag(media))

#- mostramos los resultados
aa1 %>% filter(year == 2007) %>% arrange(desc(variac_l))

#- esta parte es común
aa <- gapminder %>% 
  filter(year %in% c(1952, 2007)) %>%  
  group_by(continent, year) %>% 
  summarize(media = mean(lifeExp)) %>% ungroup()

#- pero ahora usamos pivot_wider()
aa %>% pivot_wider(names_from = year, values_from = media) %>% 
     mutate(dif_l = `2007` - `1952`) %>% 
     arrange(desc(dif_l))


#- El chunk de abajo, ¿qué hace? ¿qué se está calculando?:
aa <- gapminder %>% 
  group_by(continent, year) %>% 
  select(continent, year, lifeExp) %>% 
  summarise(mean_life = mean(lifeExp)) %>% 
  arrange(year) %>% 
  mutate(incre_mean_life_0 = mean_life - first(mean_life)) %>% 
  mutate(incre_mean_life_t = mean_life - lag(mean_life)) %>% 
  arrange(continent)

#- por ejemplo veamos el resultado para Europe
aa %>% filter(continent == "Europe")

#- variación de lifeExp en Spain año a año (bueno lustro a lustro)
aa <- gapminder %>% 
  group_by(country) %>% 
  select(country, year, lifeExp) %>% 
  mutate(lifeExp_gain_cada_lustro = lifeExp - lag(lifeExp)) %>% 
  filter(country == "Spain" )
aa

#- ganancia acumulada
aa <- gapminder %>% 
  group_by(country) %>% 
  select(country, year, lifeExp) %>% 
  mutate(lifeExp_gain_cada_lustro = lifeExp - lag(lifeExp)) %>% 
  #--- 2 filas nuevas: ifelse()  y cumsum()
  mutate(lifeExp_gain_cada_lustro2 = ifelse(is.na(lifeExp_gain_cada_lustro), 0, lifeExp_gain_cada_lustro)) %>% 
  mutate(lifeExp_gain_acumulado = cumsum(lifeExp_gain_cada_lustro2)) %>%   
  filter(country == "Spain")
aa

#- ganancia acumulada (otra forma de hacer lo mismo)
aa <- gapminder %>% 
  group_by(country) %>% 
  select(country, year, lifeExp) %>% 
  mutate(lifeExp_gain_acumulada = lifeExp - lifeExp[1])  %>% 
  filter(country == "Spain")

aa <- gapminder %>%
  filter(continent == "Asia") %>%
  select(year, country, lifeExp) %>%
  group_by(year) %>%
  slice_max(n = 3, lifeExp) %>% 
  arrange(year) 

#- Obtener, para cada periodo, los países de Asia con mayor y menor lifeExp.
aa <- gapminder %>%
  filter(continent == "Asia") %>%
  select(year, continent, country, lifeExp) %>%
  group_by(year) %>%
  filter(min_rank(desc(lifeExp)) < 2 | min_rank(lifeExp) < 2) %>% 
  arrange(year) 


#- A ver si entendeis este ejemplo
aa <- gapminder %>%
  group_by(continent, year)  %>%
  mutate(media_lifeExp = mean(lifeExp)) %>%
  mutate(media_gdpPercap = mean(gdpPercap)) %>%
  mutate(GOOD_or_BAD = case_when(
    lifeExp > mean(lifeExp) & gdpPercap > mean(gdpPercap)  ~ "good",
    lifeExp < mean(lifeExp) & gdpPercap < mean(gdpPercap)  ~ "bad" ,
    lifeExp < mean(lifeExp) | gdpPercap < mean(gdpPercap)  ~ "medium"
    )) %>%
  filter(country == "Spain")


#- Más funciones auxiliares --
dplyr::ntile(x, n) : categorizes a vector of values into "ntiles" such as quartiles if n = 4

dplyr::n_distinct(x):  counts unique values in a vector; similar a  length(unique(x))

dplyr::between(x, left, right) : is a shortcut for x >= left & x <= right,

tibble::add_row()  : añade rows a un df

tibble::rownames_to_column()


#- Más detalles sobre dplyr --
gapminder %>% mutate(across(where(is.numeric), log)) %>% head(n = 3)

gapminder %>% mutate(across(c(starts_with("life"), contains("po")), .fns =  mean)) %>% head

gapminder %>% group_by(continent) %>%
  summarize(across(where(is.numeric), mean, .names = "mean_{col}")) %>% head(n = 3)

#- Si quieres seleccionar todas las variables usa everything()
gapminder %>% group_by(continent) %>%
  summarize(across(everything(), as.character, .names = "CHAR_{col}")) %>% head(n = 3)


#- más de una condición para seleccionar las columnas:
gapminder %>% mutate(across(where(is.double) & ends_with("cap"), as.integer)) %>% head(n = 3)


#- uso de funciones propias (!!!!) ----------------------------------

#- definiendo primero la función:
  
dividir_100 <- function(x) {x / 100}  #- defino una función

gapminder %>% mutate(across(where(is.numeric), .fns = dividir_100)) %>% head

#- usando formulas anónimas

gapminder %>% mutate(across(where(is.numeric), .fns = function(x) {x / 100})) %>% head

#- con formulas
gapminder %>% mutate(across(where(is.numeric), .fns = ~ .x/100)) %>% head

gapminder %>% mutate(across(where(is.numeric), .fns = ~ {1/sqrt(.)})) %>% head


#- usar formulas facilita el uso de argumentos dentro de la función:
gapminder %>%
  group_by(continent, year) %>%
  summarise(across(c("lifeExp", "gdpPercap"),
				   list(mean = ~ mean(.x, na.rm = TRUE, trim = 0.1))))

#- crear indices de grupo: A veces cuando trabajas con df agrupados es útil saber a que grupo pertenece cada observación. 
gapminder %>% group_by(year)  %>% mutate(id_grupo = cur_group_id())


#- 5. Combinando (joining) df’s ------------------------------------
#- 5. Combinando (joining) df’s ------------------------------------


x <- tibble(id = 1:3, x = paste0("x", 1:3))

y <- tibble(id = (1:4)[-3], y = paste0("y", (1:4)[-3]))

#- Inner Join ----------------
#- only includes observations that match in both x and y
df_inner <- inner_join(x, y)

#- Left Join -----------------
#- includes all observations in x, regardless of whether they match or not. 
#- This is the most commonly used join because it ensures that you don’t lose observations from your primary table.
df_left_join <- left_join(x, y)

#- Right Join -----------------
#- includes all observations in y. 
#- It’s equivalent to left_join(y, x), but the columns will be ordered differently.
df_right_join <- right_join(x, y)

#- Full Join -----------------
#- full_join() includes all observations from x and y
df_full_join <- full_join(x, y)

#- 2 precisiones sobre las mutating joins
x <- tibble(id = 1:3, x = paste0("x", 1:3))

y <- tibble(id = c(1:4,2)[-3], y = paste0("y", c(1:5)[-3]))

#- left_join() en la que se crean nuevas filas
df_left_join <- left_join(x, y)


#- Filtering joins -------------------------------------------
#- Filtering joins -------------------------------------------

#- semi_join ------------------
df_semi_join <-  semi_join(x, y, by = "id")

#- anti_join ------------------
df_anti_join <-  anti_join(x, y, by = "id")

#- comparemos la semi_join con la inner_join
df_inner <-  inner_join(x, y, by = "id")
df_semi_join <-  semi_join(x, y, by = "id")


#- Set operations ------------------------------------------
#- Set operations  -----------------------------------------

x <- tibble::tibble(v1 = c(1, 1, 2), v2 = c("a" , "b", "a"))
y <- tibble::tibble(v1 = c(1, 2),    v2 = c("a" , "b"))

intersect(x, y)

union(x, y)

setdiff(x, y)

setdiff(y, x)

setequal(x, y)

setequal(union(x, y), union(y, x))

#- Esperando a GODOT/ggplot2 ----------------------
#- Esperando a GODOT/ggplot2 ----------------------


library("ggplot2")
my_plot <- ggplot(gapminder, aes(x = continent, y = lifeExp)) +
  geom_boxplot(outlier.colour = "hotpink") +
  geom_jitter(position = position_jitter(width = 0.1, height = 0), alpha = 1/4) +
  labs(title = "Experanza de vida (por continente)",
       subtitle = "Datos de gapminder. 1952-2007(observaciones cada 5 años)",
       caption = "Source: Gapminder. Jenny Bryan rocks in gapminder vignette!!", 
       x = "Continente", y = "Esperanza de Vida (lifeExp)") 

my_plot

#----

gapminder2 <- gapminder %>% mutate(year = as.factor(year))

library("ggplot2")
my_plot <- ggplot(gapminder2, aes(x = year, y = lifeExp)) +
  geom_boxplot(outlier.colour = "hotpink") +
  geom_jitter(position = position_jitter(width = 0.1, height = 0), alpha = 1/4) +
  labs(title = "Experanza de vida (por año)",
       subtitle = "Datos de gapminder. 1952-2007(observaciones cada 5 años)",
       caption = "Source: Gapminder. Jenny Bryan rocks in gapminder vignette!!", 
       x = "Periodo", y = "Esperanza de Vida (lifeExp)") 

my_plot

#---

library("ggplot2")
my_plot <- ggplot(gapminder, aes(x = gdpPercap, y = lifeExp, colour = continent)) +
  geom_jitter(position = position_jitter(width = 0.1, height = 0), alpha = 1/4) +
  labs(title = "Experanza de vida vs. GDP (per cápita)",
       subtitle = "Datos de gapminder. 1952-2007(observaciones cada 5 años)",
       caption = "Source: Gapminder. Jenny Bryan rocks in gapminder vignette!!", 
       x = "GDP (per cápita)", y = "Esperanza de Vida (lifeExp)") 

my_plot



#- Tidylog package --------------------
library("dplyr")
library("tidyr")
library("tidylog", warn.conflicts = FALSE)
filtered <- filter(mtcars, cyl == 4)
mutated <- mutate(mtcars, new_var = wt ** 2)

library(dplyr)
mtcars %>%
  group_by(cyl, am) %>%
  select(mpg, cyl, wt, am) %>%
  summarise(avgmpg = mean(mpg), avgwt = mean(wt)) %>%
  filter(avgmpg > 20)

filter(
  summarise(
    select(
      group_by(mtcars, cyl, am),
      mpg, cyl, wt, am),
    avgmpg = mean(mpg), avgwt = mean(wt)),
  avgmpg > 20)


filter(summarise(select(group_by(mtcars, cyl, am),  mpg, cyl, wt, am),avgmpg = mean(mpg), avgwt = mean(wt)), avgmpg > 20)


df %>% filter(country == "Spain") %>%  select(year, lifeExp)


df[df$country == "Spain", c("year", "lifeExp")]



#- el paquete dbplyr traduce expresiones de dplyr a SQL. 

#- con tidyverse
df_cars %>%
  select(longname, cyl, hp) %>%
  mutate( shortname = word(longname, 1) ) %>%
  select( - longname)  ->
df_cars_limited
head( df_cars_limited )

#- con dplyr PERO sin %>%
head(
  select(
    mutate(
      select(df_cars, longname, cyl, hp) ,
      shortname = word(longname, 1)
      ),
    -longname
    )
)
