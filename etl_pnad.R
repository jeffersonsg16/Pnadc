rm(list=ls())

check.packages <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg)) 
    install.packages(new.pkg, dependencies = TRUE)
  sapply(pkg, require, character.only = TRUE)
}


pacotes <-c("stringr", "PNADcIBGE", "dplyr", "openxlsx")

check.packages(pacotes)


vars <- c("Ano","UF","V1028","V2007","V2010", "V2009", 
          "VD3004", "V4039", "VD4002", "V4013",
          "V4010", "VD4016", "VD4009", "VD4011", "V4019")


dfs <- list()


for (i in 2012:2024) {
  
  
  df <- get_pnadc(year = i, quarter = ifelse(i == 2024, 1, 4), design = FALSE, labels = TRUE, deflator = TRUE, vars = vars) %>%
    select(vars, Habitual)
  
  
  dfs[[i]] <- df
  
  rm(df)
  
}  


dados <- do.call(rbind, dfs)
saveRDS(dados, "dados.rds")

dados_tratados <- dados %>%
  filter(VD4002 == 'Pessoas ocupadas' & 
           V4013 %in% c('41000', '42000', '43000')) %>%
  mutate(Renda = VD4016 * Habitual,
         Formalidade = case_when(
           Ano > 2014 & 
             (VD4009 %in% c("Empregado no setor privado com carteira de trabalho assinada",
                            "Trabalhador doméstico com carteira de trabalho assinada",
                            "Empregado no setor público com carteira de trabalho assinada",
                            "Militar e servidor estatutário") |
                (VD4009 %in% c("Conta-própria", "Empregador") & V4019 == "Sim")) ~ "Formal",
           
           Ano > 2014 & 
             (VD4009 %in% c("Empregado no setor privado sem carteira de trabalho assinada",
                            "Trabalhador doméstico sem carteira de trabalho assinada",
                            "Empregado no setor público sem carteira de trabalho assinada",
                            "Trabalhador familiar auxiliar") |
                (VD4009 %in% c("Conta-própria", "Empregador") & V4019 == "Não")) ~ "Informal",
           
           Ano <= 2014 ~ "Não Aplicável",
           
           TRUE ~ NA_character_  # Para qualquer outro caso
         )) %>%
  select(-VD4016, -Habitual) 

write.xlsx(dados_tratados, "Dados_PNAD.xlsx")

  
