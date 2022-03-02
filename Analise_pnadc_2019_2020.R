
## Analise descritiva PNADc 
## Input: pnadc_2019_2020.csv
## Data: 02.26.2022


# Pacotes
library("tidyverse")
library("tidylog")
library("sf")
library("dplyr")
library("readxl")
library("zoo") # para trimestralizar as datas
library(haven)
library(foreign)
library(data.table)

# Chamar base criada em .csv

pnad_2019_2020 <- read_delim("pnadc_2019_2020_csv.csv", delim = ",")

# Renomear variáveis selecionadas:

pnad_19_20 <- 
  
pnad_19_20 %>%
  rename(sexo = V2007, idade = V2009, cor = V2010, n_domic = V4024) %>%
  mutate(sexo = case_when(sexo == 1 ~ "homem",
                          sexo == 2 ~ "mulher")) %>%
  mutate(cor = case_when(cor == 1 ~ "branca",
                         cor == 2 ~"preta",
                         cor == 3 ~"amarela",
                         cor == 4 ~"parda",
                         cor == 5 ~ "indígena",
                         cor == 9 ~"ignorado")) 



# Número de domésticas por sexo, por ano
pnad_19_20 %>%
  ggplot() + 
    geom_bar(aes(x = sexo, fill = n_domic)) +
    facet_grid(cols = vars(Ano))

pnad_19_20 %>%
  filter(cor %in% c("branca", "preta", "parda")) %>%
  ggplot() + 
  geom_bar(aes(x = cor), fill = "orange", color = "orange", alpha = 0.6) +
  facet_grid(cols = vars(Ano)) +  
  ggtitle("Proporção de Domésticas por Raça por Ano") +
  ylab("População") +
  xlab("cor") +
  theme_minimal()

pnad_19_20 %>%
  filter(cor %in% c("branca", "preta", "parda")) %>%
  mutate(n_domic = case_when(n_domic == 1 ~ "Diaristas",
                              n_domic == 2 ~ "Mensalistas")) %>%
  ggplot() + 
  geom_bar(aes(x = n_domic), fill = "orange", color = "orange", alpha = 0.6) +
  facet_grid(cols = vars(Ano)) +  
  ggtitle("Proporção de Domésticas por Número de Domicílios que trabalha") +
  ylab("População") +
  xlab("domicílios") +
  theme_minimal()

pnad_19_20 %>%   ### NÃO FUNCIONOU
  filter(cor %in% c("branca", "preta", "parda")) %>%
  mutate(n_domic = case_when(n_domic == 1 ~ "Diaristas",
                             n_domic == 2 ~ "Mensalistas")) %>%
  group_by(tempo, n_domic) %>%
  tally() %>%
  ggplot() + 
  geom_line(aes(x = tempo, y = n), color = "orange") +
  ggtitle("Proporção de Domésticas por Número de Domicílios que trabalha") +
  ylab("População") +
  xlab("domicílios") +
  theme_minimal()

pnad_19_20 %>%
  filter(cor %in% c("branca", "preta", "parda")) %>%
  mutate(n_domic = case_when(n_domic == 1 ~ "Diaristas",
                             n_domic == 2 ~ "Mensalistas")) %>%
  mutate(Carteira = case_when(V4029 == 1 ~ "sim",
                             V4029 == 2 ~ "não")) %>%
  ggplot() + 
  geom_bar(aes(x = n_domic, fill = Carteira), alpha = 0.6) +
  facet_grid(cols = vars(Ano)) +  
  ggtitle("Proporção de Domésticas com Carteira por Tipo") +
  ylab("População") +
  xlab("Modalidade") +
  theme_minimal()

pnad_19_20 %>%
  filter(cor %in% c("branca", "preta", "parda")) %>%
  mutate(n_domic = case_when(n_domic == 1 ~ "Diaristas",
                             n_domic == 2 ~ "Mensalistas")) %>%
  mutate(Previdência = case_when(V4032 == 1 ~ "sim",
                              V4032 == 2 ~ "não")) %>%
  ggplot() + 
  geom_bar(aes(x = n_domic, fill = Previdência), alpha = 0.6) +
  facet_grid(cols = vars(Ano)) +  
  ggtitle("Proporção de Domésticas que Contribuem para a Previdência") +
  ylab("População") +
  xlab("Modalidade") +
  theme_minimal()


pnad_19_20 %>%   #### não tá funcionando! 
  filter(cor %in% c("branca", "preta", "parda")) %>%
  mutate(n_domic = case_when(n_domic == 1 ~ "Diaristas",
                             n_domic == 2 ~ "Mensalistas")) %>%
  group_by(tempo) %>%
  mutate(Rendimento = mean(V403312)) %>%
  group_by(tempo, n_domic) %>%
  ggplot() + 
  geom_col(aes(x = tempo, y = Rendimento , fill = n_domic), alpha = 0.6) +
  ggtitle("Proporção de Domésticas que Contribuem para a Previdência") +
  ylab("População") +
  xlab("Modalidade") +
  theme_minimal()

# Distribuição de idades por ano
pnad_19_20 %>% 
  ggplot() +
  geom_density(aes(x = idade)) +
  facet_grid(cols = vars(Ano))  +
  theme_minimal()
  






