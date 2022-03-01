** Rodando Regressão de Efeitos Fixos para PNADc 
** Artigo 3: Efeito da Covid-19 nas Trabalhadoras Domésticas
** Date 02.28.2022

* Definindo diretório
cd "C:\Users\DELL\OneDrive\Documents\Domesticas\Domesticas"

* Abrindo base de dados apenas para domésticas
use "C:\Users\DELL\OneDrive\Documents\Domesticas\Domesticas\pnadc_2019_2020.dta", clear

describe
summarize

* Renomeando algumas variáveis
rename V2007 sexo
rename V2009 idade
rename V2010 cor 
rename V4024 num_domic
rename V4029 carteira
rename V4032 contribui
rename V403312 rend_dinh
rename V4039 horas

summarize idade

* Label de algumas variáveis
label define TraduzindoSexo 1 "homem" 2 "mulher"
label values sexo TraduzindoSexo

label define TraduzindoCor 1 "branca" 2 "preta" 3 "amarela" 4 "parda" 5 "indígena" 9 "ignorado"
label values cor TraduzindoCor

tabulate sexo cor

* Criar uma dummy para lockdown

	gen lockdown = (Ano > 2019 & Trimestre > 1)
	
* Criar Dummy para diarista e mensalista (num_domic)

	destring num_domic, replace
	gen diarista = (num_domic == 1)
	gen mensalista = num_domic == 2

* Dummy para carteira assinada
	destring carteira, replace
	replace carteira = 0 if carteira == 2
	
* Dummy para contribuição ao INSS 
	destring contribui, replace
	*replace contribui = 0 if contribui == 2 (não deu certo pq tem NA)

* Criando histogramas para analisar algumas variáveis

histogram idade if Ano == 2019, percent title(Histograma da Idade)

graph bar (mean) idade if sexo==2 &  UF==26, over(cor) ytitle("Média de Idade das Empregadas Domésticas Mulheres em Pernambuco po Cor")

*** Criando o painel

* Para criar o painel, precisamos criar uma variável de tempo, já que a do R não funcionou
* Também preciso mudar a forma de identificar os indivíduos. 

xtset idpessoas tempo 

* Rodar regressão de efeitos fixos 

	* Efeito do lockdown na carteira assinada (significativo!)
	logout, save(Resultados) word excel tex replace: xtreg carteira lockdown, fe vce(cluster idpessoas)
	
	* Efeito lockdown nas horas de trabalho (significativo!)
	logout, save(Horas) tex replace: xtreg horas lockdown, fe 
	
	* Efeito lockdown no rendimento (significativo)
	logout, save(Rendimento) word excel tex replace: xtreg rend_dinh lockdown, fe
	
	* Efeito lockdown na contribuição para a previdência
	

	
* Substituição entre mensalista para diarista 












