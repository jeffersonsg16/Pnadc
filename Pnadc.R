
check.packages <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg)) 
    install.packages(new.pkg, dependencies = TRUE)
  sapply(pkg, require, character.only = TRUE)
}

pacotes <-c("")
check.packages(pacotes)

# Defina o seu projeto no Google Cloud
set_billing_id("ferrous-octane-207119")

# Para carregar o dado direto no R

db <-  read_sql("SELECT V1008 FROM `basedosdados.br_ibge_pnadc.microdados`")
