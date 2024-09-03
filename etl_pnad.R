
check.packages <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg)) 
    install.packages(new.pkg, dependencies = TRUE)
  sapply(pkg, require, character.only = TRUE)
}


#Incluir demais pacotes a serem utilizados

pacotes <-c("PNADcIBGE")


check.packages(pacotes)


#Incluir variáveis de interesse

vars <- c("")


dados <- get_pnadc(year = i, quarter = trimestre, design = FALSE, labels = TRUE, deflator = TRUE, vars = vars)
  
