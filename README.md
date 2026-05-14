# Análise de E-commerce com Python, SQL e Power BI

## 📊 Sobre o projeto

Este projeto realiza uma análise completa de dados reais de e-commerce da Olist, uma plataforma brasileira que conecta pequenos lojistas a grandes marketplaces. O objetivo é passar por todo o fluxo de dados, desde a limpeza com Python até a visualização no Power BI, respondendo perguntas de negócio a partir dos dados.

## 🛠 Tecnologias utilizadas

* **Python** — limpeza e tratamento dos dados com pandas
* **PostgreSQL** — queries analíticas, CTEs e window functions
* **Power BI** — dashboard interativo com KPIs e variações período a período
* **Git & GitHub** — versionamento

## 📂 Estrutura do projeto

* `Analise/etl_olist.ipynb` → limpeza, merge das tabelas e EDA
* `Queries/olist_analise.sql` → queries analíticas e view para o Power BI
* `data/processed/` → bases tratadas geradas pelo ETL
* `outputs/plots/` → gráficos gerados na EDA
* `olist_dashboard.pbix` → dashboard Power BI

## 📥 Dados

Dataset público com ~100k pedidos reais entre 2016 e 2018, disponível no Kaggle.

🔗 [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

Os dados brutos não estão no repositório por conta do tamanho dos arquivos. Para rodar o projeto localmente, baixe os CSVs pelo link acima e coloque dentro de `data/raw/`.

## 🔎 Perguntas analisadas

1. Como evoluiu o faturamento mês a mês?
2. Quais categorias de produto geram mais receita?
3. Quais estados concentram o maior volume de vendas?
4. Estados mais distantes sofrem mais com atraso na entrega?
5. Qual foi a variação percentual do faturamento entre os meses?
6. Qual categoria lidera em cada estado?
7. Qual forma de pagamento é mais utilizada?
8. A avaliação dos clientes varia conforme a categoria do produto?

## 🎯 Objetivo

Demonstrar habilidades em:

* Tratamento e limpeza de dados com Python
* Análise exploratória com visualizações
* Manipulação de dados com SQL
* Criação de dashboards no Power BI
* Responder perguntas de negócio com dados

## 📈 Principais insights

* SP concentra 37,4% do faturamento total, seguido por RJ (13,3%) e MG (11,8%).
* A categoria health_beauty lidera em faturamento, seguida por watches_gifts e bed_bath_table.
* Estados do Norte e Nordeste chegam a ter 3x mais tempo de entrega que SP, RR lidera com 29 dias contra 8 dias de SP.
* Mais de 78% dos pagamentos são feitos com cartão de crédito.
* A avaliação média geral é 4,16 ★, com 57% dos pedidos recebendo nota 5.

## 📊 Resultados do ETL

| Métrica | Valor |
|---|---|
| Total de pedidos | 96.478 |
| Faturamento total | R$ 15.422.461 |
| Ticket médio | R$ 159,86 |
| Avaliação média | 4,16 ★ |
| Entrega no prazo | 92,1% |
| Prazo médio de entrega | 12,5 dias |

## 👤 Autor

João Pedro Freire — [LinkedIn](https://linkedin.com/in/joaopedrofreirebm) · [GitHub](https://github.com/joaopedrofreir)
