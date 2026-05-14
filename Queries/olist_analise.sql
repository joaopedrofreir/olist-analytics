-- 1. CRIAÇÃO DA TABELA

CREATE TABLE olist_master (
    order_id                      TEXT,
    customer_id                   TEXT,
    order_status                  TEXT,
    order_purchase_timestamp      TIMESTAMP,
    order_approved_at             TIMESTAMP,
    order_delivered_carrier_date  TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP,
    delivery_days                 NUMERIC,
    on_time                       NUMERIC,
    order_year                    NUMERIC,
    order_month                   NUMERIC,
    order_yearmonth               TEXT,
    state                         TEXT,
    city                          TEXT,
    n_items                       NUMERIC,
    total_price                   NUMERIC,
    total_freight                 NUMERIC,
    total_revenue                 NUMERIC,
    main_category                 TEXT,
    pay_value                     NUMERIC,
    pay_type                      TEXT,
    installments                  NUMERIC,
    rating                        NUMERIC
);


-- 2. FATURAMENTO MENSAL
-- excluí set/16, dez/16 e set/18 pois são meses com poucos registros
-- e distorciam a análise

SELECT
    order_yearmonth,
    COUNT(order_id)          AS pedidos,
    ROUND(SUM(pay_value), 2) AS faturamento,
    ROUND(AVG(pay_value), 2) AS ticket_medio
FROM olist_master
WHERE order_yearmonth NOT IN ('2016-09', '2016-12', '2018-09')
GROUP BY order_yearmonth
ORDER BY order_yearmonth;


-- 3. TOP 10 CATEGORIAS
-- queria entender quais categorias movem mais dinheiro
-- e se as mais vendidas também têm boa avaliação

SELECT
    main_category,
    COUNT(order_id)          AS pedidos,
    ROUND(SUM(pay_value), 2) AS faturamento,
    ROUND(AVG(pay_value), 2) AS ticket_medio,
    ROUND(AVG(rating), 2)    AS avaliacao_media
FROM olist_master
WHERE main_category IS NOT NULL
GROUP BY main_category
ORDER BY faturamento DESC
LIMIT 10;


-- 4. DESEMPENHO POR ESTADO
-- além do faturamento, incluí prazo médio e % no prazo
-- para ver se estados mais distantes sofrem mais com atraso

SELECT
    state,
    COUNT(order_id)              AS pedidos,
    ROUND(SUM(pay_value), 2)     AS faturamento,
    ROUND(AVG(pay_value), 2)     AS ticket_medio,
    ROUND(AVG(delivery_days), 1) AS prazo_medio_dias,
    ROUND(AVG(on_time) * 100, 1) AS entrega_no_prazo_pct
FROM olist_master
WHERE state IS NOT NULL
GROUP BY state
ORDER BY faturamento DESC;


-- 5. VARIAÇÃO MÊS A MÊS
-- usei LAG para puxar o faturamento do mês anterior
-- e calcular a variação percentual sem precisar fazer self join

WITH mensal AS (
    SELECT
        order_yearmonth,
        COUNT(order_id)          AS pedidos,
        ROUND(SUM(pay_value), 2) AS faturamento
    FROM olist_master
    WHERE order_yearmonth NOT IN ('2016-09', '2016-12', '2018-09')
    GROUP BY order_yearmonth
)
SELECT
    order_yearmonth,
    pedidos,
    faturamento,
    LAG(faturamento) OVER (ORDER BY order_yearmonth) AS faturamento_mes_anterior,
    ROUND(
        (faturamento - LAG(faturamento) OVER (ORDER BY order_yearmonth))
        / LAG(faturamento) OVER (ORDER BY order_yearmonth) * 100
    , 1) AS variacao_pct
FROM mensal
ORDER BY order_yearmonth;


-- 6. CATEGORIA DOMINANTE POR ESTADO
-- RANK com PARTITION BY para ranquear as categorias dentro de cada estado
-- dá pra ver que o mix de produtos varia bastante por região

WITH categorias_por_estado AS (
    SELECT
        state,
        main_category,
        COUNT(order_id)          AS pedidos,
        ROUND(SUM(pay_value), 2) AS faturamento,
        ROUND(AVG(rating), 2)    AS avaliacao_media
    FROM olist_master
    WHERE main_category IS NOT NULL
    GROUP BY state, main_category
)
SELECT
    state,
    main_category,
    pedidos,
    faturamento,
    avaliacao_media,
    RANK() OVER (PARTITION BY state ORDER BY faturamento DESC) AS rank_no_estado
FROM categorias_por_estado
ORDER BY state, rank_no_estado;


-- 7. VIEW PARA O POWER BI
-- criei essa view para conectar direto no Power BI
-- já traz os KPIs mensais calculados com a variação mês a mês

CREATE VIEW vw_resumo_mensal AS
WITH mensal AS (
    SELECT
        order_yearmonth,
        COUNT(order_id)              AS pedidos,
        ROUND(SUM(pay_value), 2)     AS faturamento,
        ROUND(AVG(pay_value), 2)     AS ticket_medio,
        ROUND(AVG(rating), 2)        AS avaliacao_media,
        ROUND(AVG(on_time) * 100, 1) AS entrega_no_prazo_pct
    FROM olist_master
    WHERE order_yearmonth NOT IN ('2016-09', '2016-12', '2018-09')
    GROUP BY order_yearmonth
)
SELECT
    order_yearmonth,
    pedidos,
    faturamento,
    ticket_medio,
    avaliacao_media,
    entrega_no_prazo_pct,
    LAG(faturamento) OVER (ORDER BY order_yearmonth) AS faturamento_mes_anterior,
    ROUND(
        (faturamento - LAG(faturamento) OVER (ORDER BY order_yearmonth))
        / LAG(faturamento) OVER (ORDER BY order_yearmonth) * 100
    , 1) AS variacao_pct
FROM mensal
ORDER BY order_yearmonth;