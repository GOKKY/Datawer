-- А Розглядаючи тільки українські маршрути, для кожної категорії товарів і для кожного року виберіть середньоденний дохід за кожен місяць і загальний місячний дохід з початку року.

SELECT
month_id,
category,
years,
AVG(income / days_of_the_month) AS avg_daily_income,
SUM(income) AS total_income
FROM
Fact_property p, Dim_Month m, Dim_Analysis_of_product_flows a

WHERE
Type_transportation_id IN ('air', 'rail', 'sea') AND
Location_id IN (SELECT id FROM Location WHERE country = 'Україна')
GROUP BY
month_id,
category,
years;

-- C) У 2022 році для кожного маршруту в розрізі області відправлення та призначення вибрати середньомісячний дохід на одиницю ваги (у кг) доставленого вантажу та середньоденний дохід за кожен місяць для вантажу, доставленого на цьому маршруті.

SELECT
appointment,
departure,
region,
category,
month_id,
AVG(income / Analysis_of_product_flows.weight_in_kg) AS avg_monthly_income_per_unit_weight,
AVG(income / Month.days_of_the_month) AS avg_daily_income
FROM
Fact_property p,
Dim_Analysis_of_product_flows a,
Dim_Month m,
Dim_Location l
WHERE
years = '2022'
GROUP BY
region,
category,
month_id;


-- D) Для кожного району відділення та типу перевізника виберіть загальний дохід за кожен місяць і загальний обсяг товарів, доставлених за кожен місяць. Розташуйте результати відповідно до загального місячного обсягу (найвищий 1-й).

SELECT
district,
type_transportation,
month_id,
SUM(income) AS total_income,
SUM(Analysis_of_product_flows.weight_in_kg) AS total_weight
FROM
Fact_property p,
Dim_Analysis_of_product_flows a,
Dim_Type_Transportation.id t,
Dim_Location l
GROUP BY
district,
Type_Transportation.id,
month_id
ORDER BY
SUM(Analysis_of_product_flows.weight_in_kg) DESC;
