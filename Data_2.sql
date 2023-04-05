--A) Розглядаючи тільки українські маршрути, для кожної категорії товарів і для кожного року виберіть середньоденний дохід за кожен місяць і загальний місячний дохід з початку року.
SELECT
  Fact_Property.category,
  Dim_Month.years,
  Dim_Month.months,
  AVG(Fact_Property.analysis_id) as average_daily_income,
  SUM(Fact_Property.analysis_id) as monthly_income
FROM 
  Fact_Property
  JOIN Dim_Location ON Fact_Property.location_id = Dim_Location.id
  JOIN Dim_Month ON Fact_Property.month_id = Dim_Month.id
  JOIN Dim_Type_Transportation ON Fact_Property.type_transportation_id = Dim_Type_Transportation.id
  JOIN Dim_Analysis_of_product_flows ON Fact_Property.analysis_id = Dim_Analysis_of_product_flows.id
WHERE
  Dim_Location.country = 'Україна'
GROUP BY
  Fact_Property.category,
  Dim_Month.years,
  Dim_Month.months;



--C) У 2022 році для кожного маршруту в розрізі області відправлення та призначення вибрати середньомісячний дохід на одиницю ваги (у кг) доставленого вантажу та середньоденний дохід за кожен місяць для вантажу, доставленого на цьому маршруті.C) У 2022 році для кожного маршруту в розрізі області відправлення та призначення вибрати середньомісячний дохід на одиницю ваги (у кг) доставленого вантажу та середньоденний дохід за кожен місяць для вантажу, доставленого на цьому маршруті.
SELECT
  Fact_Property.route_id,
  Dim_Location.region as origin_region,
  Dim_Location_2.region as destination_region,
  Dim_Month.months,
  AVG(Dim_Analysis_of_product_flows.income / Dim_Analysis_of_product_flows.weight_in_kg) as average_income_per_kg,
  AVG(Dim_Analysis_of_product_flows.income) as average_daily_income
FROM 
  Fact_Property
  JOIN Dim_Location ON Fact_Property.location_id = Dim_Location.id
  JOIN Dim_Location as Dim_Location_2 ON Fact_Property.location_id = Dim_Location_2.id
  JOIN Dim_Month ON Fact_Property.month_id = Dim_Month.id
  JOIN Dim_Analysis_of_product_flows ON Fact_Property.analysis_id = Dim_Analysis_of_product_flows.id
WHERE
  Dim_Month.years = '2022'
GROUP BY
  Fact_Property.route_id,
  Dim_Location.region,
  Dim_Location_2.region,
  Dim_Month.months;

-- D) Для кожного району відділення та типу перевізника виберіть загальний дохід за кожен місяць і загальний обсяг товарів, доставлених за кожен місяць. Розташуйте результати відповідно до загального місячного обсягу (найвищий 1-й).
SELECT 
  Fact_property.category, 
  Fact_property.type_transportation_id, 
  Dim_Location.district,
  Dim_Month.months,
  SUM(Fact_property.analysis_id * Fact_property.weight_in_kg) AS total_income,
  SUM(Fact_property.analysis_id * Fact_property.the_volume_of_delivered_goods) AS total_volume
FROM 
  Fact_property 
  JOIN Dim_Location ON Fact_property.location_id = Dim_Location.id 
  JOIN Dim_Type_Transportation ON Fact_property.type_transportation_id = Dim_Type_Transportation.id 
  JOIN Dim_Month ON Fact_property.month_id = Dim_Month.id 
GROUP BY 
  Fact_property.category, 
  Fact_property.type_transportation_id, 
  Dim_Location.district, 
  Dim_Month.months 
ORDER BY 
  total_volume DESC;
