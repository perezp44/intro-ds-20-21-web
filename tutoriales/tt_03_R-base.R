## Fichero con las instrucciones R del tutorial "tt_03_R-base_v5.html"
library(tidyverse)


# operaciones básicas con R ----------------------------------------

# R puede utilizarse como calculadora.
2 + 2
2 - 2
2 * 2
2 / 2

# Potenciación (se puede hacer con el operador ^ o con **)
3^2
3**2

# división entera y módulo
11 %/% 5    # división entera
11 %% 5     # módulo (resto de la división entera)

# Orden de precedencia de las operaciones
6 + 2 * 5   
(6 + 2) * 5

# expresiones de varias lineas
2  + 2 + 2 + 2 + 2 +
10 + 
30

# Asignación (“creación de objetos”) ------------------------------------------
aa <- 2 + 2
aa

aa + 1
aa

aa <- 10
aa

# ¿Qué hacen las siguientes lineas de código? 
aa <- 2 + 2
bb <- 5 + aa
cc <- 1 + aa * 2
dd <- bb


# Global environment (primera referencia al ------------------------------------
ls()       #- muestra los objetos en el Global env. Hace lo mismo que objects()

rm(cc)           #- borra/elimina el objeto cc del Global env.
rm(list = ls()) #- borra todos los objetos del Global env.

# nombres válidos -------------------------------------------------------------
pepe <- 4
pepe_2 <- 4
pepe_2.3 <- 22
.hola <- 7

# nombres NO válidos
4pepe <- 33
_hola <- 66
.2xx <- 88


# R distingue entre mayúsculas y minúsculas


# Nombres reservados (no se pueden usar)
#-- if  else repeat  while  for in next break
#-- function
#-- TRUE FALSE
#-- NULL Inf NaN
#-- NA NA_integer_ NA_real_ NA_complex_ NA_character_


#  Tipos de datos -------------------------------------------------------------
aa <- "La calle en la que vivo es"    #- texto
bb <- 4L                              #- número entero
cc <- 4.3                             #- número decimal
dd <- TRUE                            #- logical

typeof(aa)
typeof(bb)
typeof(cc)
typeof(dd)

# En realidad 3 tipos fundamentales de datos: numéricos, texto y lógicos
  

# Además, hay 4 valores especiales: NULL, NA, NaN, e infinito -------------
#- atención a los NAs cuando se hacen calculos estadísticos
aa <- c(182, 178, 172, NA, 168)
mean(aa)
mean(aa, na.rm = TRUE)


# Operaciones con números-------------------------------------------------------
# Evidentemente con números se pueden hacer operaciones aritméticas: sumar, restar etc...
# pero tb se pueden hacer COMPARACIONES -------------------------
2 < 4    # MENOR que: esta expresión chequea si 2 es MENOR que cuatro. Como es cierto, nos devuelve un TRUE
2 > 4    # MAYOR que: esta expresión chequea si 2 es MAYOR que cuatro. Como es cierto, nos devuelve un TRUE
5 >= 7   # MAYOR o IGUAL que.
8 <= 8   # MENOR o IGUAL que.
9 == 7   # IGUAL a: como 9 no es igual a 7, nos devolverá un FALSE
2 == 2   # IGUAL a: como 2 es igual a 2, nos devuelve TRUE
2 != 4   # NO IGUAL: como 2 no es igual a 4 nos devuelve TRUE
5 != 5   # NO IGUAL: como 5 es igual a 5, nos devuelve FALSE 


# Operaciones con texto-------------------------------------------------------
aa <- "Mi nombre es"
bb <- "Pedro"
paste(aa, bb)
paste(aa, bb, sep = " ... ")

# Prueba tú mismo que hace la función paste0()

# Algunas otras “operaciones” que se pueden hacer con variables de texto:
toupper(aa)
tolower(aa)
nchar(bb)                    #- nchar() nos devuelve el número de caracteres de un string
substring(bb, 2, nchar(bb))  #- substring() extrae caracteres de un string



# Operaciones lógicas ----------------------------------------------------------
(4 > 3) & (3 < 2)     #- Y: como se cumplen las dos condiciones nos devuelve TRUE
(1==2) | (2 >3)       #- O: Como no se cumple ninguna de las 2 condiciones nos devuelve FALSE
!(4 > 3)              #- NOT: 4 es mayor que 3 es TRUE, pero el ! delante de esa condición la niega y pasa a FALSE
!!(4 > 3)             #- si niegas dos veces, vuelves al principio: TRUE

xor(10 < 1, 10 >1 ) #- se cumple 1 de las dos condiciones, entonces TRUE
xor(10 > 1, 10 >1 ) #- se cumplen las 2 condiciones, entonces FALSE
xor(10 < 1, 10 <1 ) #- no se cumple ninguna de las 2 condiciones: FALSE



# FUNCIONES - FUNCIONES --------------------------------------------------------
sqrt()

sqrt(9)

?sqrt()
sqrt(9, 4)    # no funciona porque sqrt() solo admite un argumento
sqrt("9")     # no funciona, solo hemos puesto un argumento pero es textual, y ha de ser numérico

help(sqrt)

#- Lo correct-correcto es poner el nombre y el valor de los argumentos de una función
sqrt(x = 9)
sqrt(x = 4)

#- PERO, muchas veces se omite el nombre de los argumentos xq es más rápido de escribir
sqrt(9)
sqrt(4)


# A ver si consigues diferenciar, en una función, entre el nombre de un argumento y su valor
x <- 25

sqrt(9)

sqrt(x)

sqrt(x = x)    #- Pufff


#- Veamos OTRA FUNCION ---------------------------------
help(log)

log(x = 1000, base = 10)

log(1000)  #- como no especificamos el valor del argumento "base", R lo fija por defecto base = exp(1) y toma logaritmos naturales

log(1000, base = 10) #- ahora si estamos calculando logaritmo en base 10

log(1000, bas = 10)   #- funciona, pero ...
log(1000, 10)         #- esto sí es muy habitual verlo

#- que pasa aquí
log(10, 1000)


#- Otra FUNCIÓN: seq() -----------------------------------------------
seq(from = 0, to = 10)
seq(0, 10)
seq(10, 0)
seq(0, 10, 3)
seq(0, 10, length.out = 3)


#- la función args() nos ayuda tb a entender como funciona una función, concretamente a ver sus argumentos
args(sqrt)       #- sqrt() solo tiene un argumento, x
args(log)        #- log() tiene 2 argumentos: x y base. Además base tiene un valor por defecto: exp(1)
args(args)       #- args() solo tiene un argumento, llamado name.


#- VECTORES - VECTORES --------------------------------------------------------

#- podemos crear vectores con la función c()
aa <- c(3, 22, 6)
aa
is.vector(aa)
typeof(aa)


#- Creemos ahora un vector con datos textuales o caracteres:
aa <- c("Hola", "número", "9")
is.vector(aa)
typeof(aa)


#- Coerción: ¿qué ocurre si un vector tiene elementos de distinto tipo?
aa <- c(4, 6, "Hola")
is.vector(aa)
typeof(aa)
aa    #- ¿qué ha pasado?

#- vamos a ver si entendemos la coerción
aa <- c(TRUE, 4L, 4, "Hola")
typeof(aa)
aa <- c(TRUE, 4L, 4)
typeof(aa)
aa <- c(TRUE, 4L)
typeof(aa)


#- coerción explícita ---
aa <- c(1:4)
aa
aa <- as.character(aa)
aa
#-tb existen: as.character(), as.logical(), as.numeric()   


# Propiedades de los vectores ---------------------------
aa <- c(1:10)
typeof(aa)
length(aa)
attributes(aa)

#- podemos añadir atributos a un vector
aa <- c(1:3)
attributes(aa)
attr(aa, "atributo_1") <- "This is a vector"
attributes(aa)
attr(aa, "atributo_2") <- c("primero", "segundo", "tercero")
aa



#-Un atributo que a veces se usa es poner nombres a los elementos de un vector, se puede hacer directamente al crear el vector o después con `setNames()` o con `set_names()`
aa <- c(a = 1, b = 2, c = 4)

aa <- c(1,2,4)
aa <- setNames(aa, letters[1:3])       
aa                                      

aa <- c(1,2,4)
aa <- rlang::set_names(aa, c("a", "b", "c"))
aa                                      



#- Subsetting con vectores ----------------------------------------------------

# Positive Index: podemos seleccionar por posición.
aa <- c(10:1)
aa[c(1:2)]        #- primer y segundo elemento del vector
aa[c(1,2,9,10)]   #- dos primeros y 2 últimos
aa[c(1,1,10,10)]  #- si repites el indice se repite el elemento del vector

# Negative index: eliminamos elementos del vector. 
aa <- c(10:1)
aa[- c(1,2, 9:10)]

# Logical index: se seleccionan aquellas posiciones marcadas con TRUE.
aa <- 1:10
aa <- aa[aa >= 7]
aa


#- Si no acabas de entenderlo, corre las siguientes lineas de código:
aa <- 1:10
aa <= 4
aa[aa <= 4]
aa <- aa[aa <= 4]


#- Modificando elementos de un vector ----------------------------------------
aa <- c(1:10)
aa[4] <- 88             #- el segundo elemento de aa tomará el valor 88
aa <- c(aa, 111, 112)   #- añadimos 2 elementos al vector aa

#- Los vectores se pueden concatenar
aa <- c(1:5)
bb <- c(100:105)
cc <- c(aa, bb)


#- SECUENCIAS ----------------------------------------------------------------
1:10
#- Pero la función `seq()` nos ofrecen más posibilidades:
seq(1, 10, 2.5)
seq(from = 1, to = 10, by = 2.5)


#- Tb tenemos la función rep()
aa <- 1:3
rep(aa, 2)
rep(aa, each = 2)     
rep(aa, c(2,2,4))
rep(aa, each = 2, len = 10)   
rep(aa, each = 2, times = 3)  



#- Operaciones con vectores ---------------------------------------------------
# podemos sumar vectores
aa <- 1:10
bb <- 1:10
aa + bb

#- Reciclado
aa <- 1:10
aa + 1

#- otro ejemplo de reciclado
aa <- 1:6
bb <- 1:2
aa + bb

#- generalmente las funciones están vectorizadas
aa <- c(4, 9, 25)
sqrt(aa)

#- Operaciones de comparación
aa <- 1:3
bb <- 3:1

aa == bb
aa >= bb
aa != bb

#- en las comparaciones tb aplica el recicling
aa <- 1:3
bb <- 2

aa == bb
aa >= bb
aa != bb


#- operaciones de conjuntos
aa <- 1:4
bb <- c(1:2, 99)

union(aa, bb)            
intersect(aa, bb)

setdiff(aa, bb)       #- Elementos de aa que no estan en bb
setequal(aa,bb)       #- chequea si dos vectores son iguales
setequal(1:4, 1:4)    #- chequea si dos vectores son iguales

# Funciones útiles con vectores -----------------------------------------------

#- length(): nos da el orden o número de elementos de un vector. Ya la vimos.
aa <- 1:4
length(aa)


#- sum(): devuelve la suma de los valores de un vector.

aa <- 1:4
sum(aa)

#- cumsum()
aa <- 1:4
cumsum(aa)


#- mean()
aa <- 1:4
mean(aa)

#- sort()
aa <- c(2, 1, 4, 3)
sort(aa)

#- order()
aa <- c(20, 10, 7, 30)
order(aa)


# Matrices --------------------------------------------------------------------

# creamos matrices con matrix()
(aa <- matrix(1:6, ncol = 2, nrow = 3))     #- creamos una matriz 3x2

# Las matrices también se pueden crear concatenando vectores
aa <- c(1:3)
bb <- c(11:13)
cc <- cbind(aa, bb)  #- agrupamos los vectores por columnas con cbind()
dd <- rbind(aa, bb)  #- agrupamos los vectores por filas con rbinb()


#- Subsetting con matrices
aa <- matrix(1:9, nrow = 3, ncol = 3) #- creamos una matriz 3x3

bb <- aa[2, 3]          #- seleccionamos el elemento (2,3) de la matriz
bb <- aa[ , 2]          #- seleccionamos la segunda columna (devuelve un vector)
bb <- aa[ , c(2,3)]     #- selecionamos la segunda y tercera columna
bb <- aa[c(2,3), ]      #- selecionamos la segunda y tercera FILAS

bb <- aa[-2, ]          #- eliminamos la segunda fila
bb <- aa[-2, -c(1,2)]   #- eliminamos la segunda fila y la primera y segunda Columnas


#- Nombrar las filas y columnas ----
aa <- matrix(1:6, nrow = 2, ncol = 3) #- creamos una matriz 2x3
aa

colnames(aa) <- c("col_1", "col_2", "col_3")    
rownames(aa) <- paste("fila", 1:2, sep = "_")    
aa



#- Funciones para matrices-----------------------------------------------------
aa <- matrix(1:6, nrow = 3, ncol = 2)  #- matriz 3x2
dim(aa)     #- devuelve un vector con las dimensiones de la matriz
t(aa)          #- transpone la matriz



#- arrays: son matrices multidimensionales. NO las usaremos -------------------
(aa <- array(1:12, c(2, 3, 2)) )



#- FACTORES -------------------------------------------------------------------
aa <- c("lunes", "martes", "jueves", "lunes", "martes")
aa

aa_factor <- as.factor(aa) #- creamos un factor
is.factor(aa_factor)

aa_factor  #- vemos q tiene levels (es un atributo de los factores)

levels(aa_factor)

aa_factor
typeof(aa_factor)     #- internamente lo almacena como enteros !!


#- El orden de los `levels` (por defecto alfabéticamente)
levels(aa_factor)

relevel(aa_factor, "martes")  3- pero podemos reordenar los levels


#- También podemos crear el factor directamente y poner el oreden q queramos
aa_factor_2 <- factor(aa, levels = c("lunes", "martes", "jueves"))
aa_factor_2


#- Ya dije que un factor es un vector con atributos. Veámoslo:
aa <- 1:10
attributes(aa)

aa_factor_2 <- factor(aa, levels = c("lunes", "martes", "jueves"))
attributes(aa_factor_2)


#- LISTAS ----------------------------------------------------------------------

# defino 3 vectores y una matriz
vec_numerico <- c(1:8)
vec_character <- c("Pedro", "Rebeca", "Susana")
vec_logic <- c(TRUE, FALSE, TRUE)
matriz <- matrix(1:6, nrow = 2, ncol = 3)

# creo una lista con cuatro elementos. Para ello uso la función list()
my_list <- list(vec_numerico, vec_character, vec_logic, matriz)
my_list

#- Puedes añadir nombres a los elementos de una lista
my_list <- list(slot_1 = vec_numerico, slot_2 = vec_character, slot_3 = vec_logic, slot_4 =matriz)
my_list

#- Las listas no tienen dimensiones tienen `length()`
length(my_list) #- nuestra lista tiene 4 slots, 4 elementos

#- Las listas son sumamente flexibles porque un elemento de una lista puede ser otra lista.
my_list_2 <- list(primer_slot = c(44:47), segundo_slot = my_list)
my_list_2


# Subsetting en listas ---------------------------------------------------------

my_list[2]  #- seleccionamos el segundo elemento de la lista. Nos devuelve una lista con un solo slot

my_list[c(2,3)]  #- seleccionamos el segundo y tercer elemento de la lista. Nos devuelve una lista con dos slots

my_list["slot_2"]  #- seleccionamos el segundo elemento de la lista. Nos devuelve una lista con un solo slot
my_list[c("slot_2", "slot_3")]  #- seleccionamos el segundo y tercer elemento de la lista. Nos devuelve una lista con dos slots


#- subsetting listas con `[[`. NO devuelve una lista, nos devuelve el objeto que hay en el slot seleccionado

my_list[[2]]  #- seleccionamos el segundo elemento de la lista. Nos devuelve el elementoq ue hay en el segundo slot; es decir un vector, vec_character

#- - subsetting, por nombre, con `$`. No devuelve una lista, sino un elemento de la lista
my_list$slot_4  #- seleccionamos el cuarto elemento de la lista, cuyo nombre es `slot_4`; es decir, nos devuelve una matriz.

#- se puede usar `[[` para hacer subsetting por nombre,
my_list[["slot_4"]]  #- seleccionamos el cuarto elemento de la lista, cuyo nombre es `slot_4`; es decir, nos devuelve una matriz.

#- las listas son flexibles: uno de sus elementos puede ser el mismouna lista
my_list_2 <- list(primer_slot = c(44:47), segundo_slot = my_list)
my_list_2

my_list_2[[2]][[4]]
my_list_2$segundo_slot$slot_4


# DATA FRAMES ------------------------------------------------------------------

aa <- c(4, 8, 6, 3)
bb <- c("Juan", "Paz", "Adrian", "Marquitos")
cc <- c(FALSE, TRUE, TRUE, FALSE)
df <- data.frame(aa, bb, cc)     #- creamos un df
df

#- generalmente las columnas de un df tienen nombre
df <- data.frame(Nota = aa, Nombre = bb, Aprobado = cc)
names(df)  #- con names() podemos ver los nombres de las variables del df

(names(df) <- c("Grade", "Name", "Pass"))


#- Subsetting en data.frames ---------------------------------------------------

#- Subsetting como si fuera una matriz. Con  `[`.
df_s <- df[,1]       #- seleccionamos la primera columna. devuelve un vector !!!
df_s <- df[,c(2,3)]  #- seleccionamos la segunda y tercera columna. devuelve un df
df_s <- df[1, ]      #- seleccionamos primera fila de todas las variables. devuelve un df. ¿xq no devuelve un vector? Preguntad si no lo sabeis
df_s <- df[c(1,4), ]  #- seleccionamos primera y cuarta fila. devuelve un df
df_s <- df[2, 3]      #- seleccionamos segunda observación de la tercera variable. Devuelve un vector.

#- Subsetting como si fuera una lista. De hecho un df es una clase especial de lista. Podemos usar 3 operadores: `[`, `[[` y `$`.

#- subsetting con `[`  como si fuera una lista 
df_s <- df[3]        #- devuelve un df. Good!!
df_s <- df[c(1,2)]

#- también se puede hacer por nombre
df_s <- df["Name"]                #- devuelve un df
df_s <- df[c("Name", "Grade")]   

#- subsetting con `[[` como si fuera una lista
df_s <- df[[2]]   #- Extraemos la segunda columna. Devuelve un vector, concretamente un factor. Ahhhh!!!!!

#- subsetting con `$`. Como si fuera una lista (por nombre
df_s <- df$Name   #- Extraemos la columna con nombre "Name". Devuelve un vector, concretamente un factor. Ahhhh!!!!!
df_s <- df$Grade  #- Extreamos la columna con nombre "Grade". Devuelve un vector numérico


#- con `[` podemos, al igual que en los vectores y matrices, hacer subsetting lógico:
df_s <- df[df$Grade >= 5, ]   #- selecciono filas que cumplan que el valor de la columna grade sea >= a 5
df_s <- df[!df$Grade >= 5, ]  #- los que NO han sacado igual o mas  de 5
df_s <- df[df$Grade == 8 | df$Grade < 5, ]  #- los que han sacado exactamente 8 ó menos de 5


#- funciones útiles con df's
names(df)    #- devuelve un vector con los nombre de las columnas/variables del df
nrow(df)     #- devuelve el nº de filas
ncol(df)     #- nº de columnas
length(df)   #- la longitud de las columnas/vectores que componen el df; osea devuelve otra vez el nº de filas

#- Podemos añadir columnas a nuestro df:
aa <- 101:104
df$new_v <- aa

df_new <- cbind(df, aa)

#- Con la función `as.data.frame()`, podemos convertir un vector en data.frames.
aa <- 1:5
df_new <- as.data.frame(aa)  #- df con una sola columna


#- Un resumen del dataframe con `summary()`
summary(df)


#- PAQUETES/PACKAGES -----------------------------------------------------------
install.packages("eurostat")
library(eurostat)
help(package = eurostat)  #- abrimos en RStudio la ayuda del pkg eurostat

#- Obtener un listado de las funciones de un pkg
library(tidyverse)
aa <- as.data.frame(ls("package:readr", all = TRUE))


#- Algunas funciones útiles ----------------------------------------------------

#- `%in%`: retorna un vector de booleans (TRUE or FALSE) para cada uno de los valores del vector a la izquierda dependiendo de si el valor se encuentra o no en el vector de la derecha.
?`%in%`  #- para ver la ayuda del operador
1:10 %in% c(1,3,5,9)

#- `str()`: muestra la estructura de un objeto
str(iris)



#- NA's y valores especiales --------------------------------------------------

#- `NULL`: representa el objeto vacio en R. No se propaga.
c()
sum(2, 2, NULL)
mean(c(2 ,4, NULL))

#- `NA`: Un valor no disponible. Sí se propaga,
sum(2, 2, NA)
mean(c(2 ,4, NA))
mean(c(2, 4, NA), na.rm = TRUE)


#- `NaN`: Not a number. Se propaga
0/0
sum(2, 2, NaN)
mean(c(2 ,4, 0/0))


#- `Infinito`: 
1/0
-1/0
sum(2, 2, Inf)


#- Secuencias -----------------------------------------------------------------

1:3
c(1:4)
-2:3
4:-1

seq(from = 0, to = 5, by = 1)
seq(-5, 5, 2)

seq(0, 1, length.out = 3)
seq(0, 1, length.out = 5)
seq(0, 1, 5)

rep(2, times= 3)
rep(1:3, 2)
rep(1:3, each = 2)       # not the same.
rep(1:3, times = 3, each = 2)
rep(1:2, length.out = 9)



#- ALGUNOS CHUNKS --------------------------------------------------------------
aa <- 1
bb <- 2
cc <- 3
dd <- 4
quiero_dejar_estos <- c("cc", "dd")                #- fijate que los nombres de los objetos están entre comillas
rm(list = ls()[!(ls() %in% quiero_dejar_estos)])   #- remueve todo excepto quiero_dejar_estos

#- Función para comparar los elementos de dos vectores (!!!!!!)
my_f_compare <- function(x, y){
  list(
  "Valores de X q. no están en Y:" = setdiff(x, y),
  "Valores de Y q. no están en X:" = setdiff(y, x),
  "Valores comunes en X e Y:" = intersect(x, y),
  "La unión de X e Y sería:" = union(x,y), 
  "Si juntamos X e Y obtenemos:" = c(x, y) )
}

XX <- c(1:4)
YY <- c(3:6)
aa <- my_f_compare(XX, YY)
names(aa)
aa
