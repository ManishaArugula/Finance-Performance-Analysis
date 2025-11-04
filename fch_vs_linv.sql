use fin_data;

select * from fch;
select * from linv;

#COST MANAGMENT & EXPENSES
#1. What is the operationg efficiency between fch and lnv and how much is the operating efficiency gap?
select *, round(fch_op_eff -  lnv_op_eff, 2) as efficiency_gap from (
#calculate the operating efficiency
select year, round(fch_op_exp/fch_rev ,2) as fch_op_eff , round(lnv_op_exp/ lnv_rev ,2)
 as lnv_op_eff
 from (
#collect the necessary columns needed to calculte the operating efficinecy  
select f.year ,f.operating_expense as fch_op_exp, f.total_revenue as fch_rev, 
l.operating_expense as lnv_op_exp,
l.total_revenue as lnv_rev from fch as f
join linv as l on f.year =l.year
 ) as a 
 order by year
 ) as b;
 #result: FCH has spend more % age of revneue on operating expenses than LINV. LINV gradually increase the OpEX to 0.52 by yr 2024, whereas FCH las always had 0.50-0.55 op efficiency.
 
 #2. What is the difference in cost structure of FCH and LINV?
select *, round(fch_cost_ratio - lnv_cost_ratio,2 ) as difference  from (
#calculate the cost managment ratio
select year, round((fch_op_exp + fch_cogs)/ fch_rev,2) as fch_cost_ratio,
 round((lnv_op_exp + lnv_cogs)/ lnv_rev,2) as lnv_cost_ratio
 from (
 #collect the necessary columns needed to calculte the cost managment 
select f.year ,f.operating_expense as fch_op_exp, f.total_revenue as fch_rev, f.cost_of_revenue as fch_cogs,
l.operating_expense as lnv_op_exp,l.total_revenue as lnv_rev , l.cost_of_revenue as lnv_cogs
from fch as f
join linv as l on f.year =l.year
) as a
) as b
order by year;
#For every £1 Funding Circle earns in revenue, it spends £1.08 in total costs in 2022-2023.
#result: fch had higher cost ratio in 2022-2023. 2023 shows that FCH last spent 31% more then linv but LINV shows slight increase in cost expenses 
#total costs 11% points higher than FCH related to revneue, and FCH shows slight improvement.

#PROFITABILITY
#3.Does FCH has higher profit margin than LINV?
select year, round(fch_income/ fch_rev *100, 2) as fch_profit_margin,
 round(lnv_income/ lnv_rev *100, 2) as lnv_profit_margin from (
 #collect the necessary columns needed to calculte the profit margin
select f.year ,f.Net_Income as fch_income, f.total_revenue as fch_rev, 
l.Net_Income as lnv_income ,l.total_revenue as lnv_rev 
from fch as f
join linv as l on f.year =l.year
order by year
) as a ;
# result: Already negative income for 2022-2023 for fch shows loss and 2024 for linv, Between 2022–2024, Funding Circle and LendInvest exhibited opposite profitability trajectories.
# 2023 worse for fch lossing 0.29 cent for 1 pound where as profitable for lnv gaining 0.14 cent for 1 pound, shows highest profitability in 2023 
# 2024 recovery for fch , whereas huge loss for linv by 0.30. Maybe be exprenses were more or less revenue could be generated.

#4. How do yearly changes in profit margin align with stock price and trading volume?

select year, round(fch_income/ fch_rev *100, 2) as fch_profit_margin, fch_close_price, fch_vol,
 round(lnv_income/ lnv_rev *100, 2) as lnv_profit_margin ,lnv_close_price, lnv_vol 
 from (
 #collect the necessary columns needed to calculte the profit margin
select f.year ,f.Net_Income as fch_income, f.total_revenue as fch_rev, round(f.avg_close_price,2) as fch_close_price, f.Total_Volume as fch_vol,
l.Net_Income as lnv_income ,l.total_revenue as lnv_rev , round(l.avg_close_price,2) as lnv_close_price, l.Total_Volume as lnv_vol
from fch as f
join linv as l on f.year =l.year
order by year
) as a ;
#result: There seems to be a direct relation between profit and stock price value
# As the profit_margin drecreases the stock value reduced from 60 go 58 in the year 2022-2023 for fch and same for linv reduced the close price from 60-27 from 2023-2024

#5. Does the yoy growth rate of FCH beat LINV?
 #collect the necessary columns needed to calculte the profit margin

select year, round(((fch_rev- fch_prev_rev)/ fch_prev_rev ) *100, 2) as fch_yoy_revenue_growth,
round(((lnv_rev- lnv_prev_rev)/ lnv_prev_rev ) *100, 2) as lnv_yoy_revenue_growth
from (
#Use Lag to get the previous revenue
select *, lag(fch_rev) over(order by year) as fch_prev_rev,
lag(lnv_rev) over (order by year) as lnv_prev_rev
 from (
select f.year ,f.total_revenue as fch_rev, l.total_revenue as lnv_rev 
from fch as f
join linv as l on f.year =l.year
) as a
) as b;
#result: FCH had decline in revenue by 18% at 2023 followed by a strong recovery in 2024 by 25%. LINV has flat growth with stagnation (0.9). Maybe FCH improved int their opex 

#6. What is the capital expenditure analyse more on how the income, profit and reveneu growth improved for FCH but remained stagnent for LINV
select year, round(fch_capex/fch_rev,2) as fch_capex_ratio, round(lnv_capex/lnv_rev,2) as lnv_capex_ratio
  from (
select f.year ,abs(f.capital_expenditure) as fch_capex, f.total_revenue as fch_rev,
 abs(l.capital_expenditure) as lnv_capex, l.total_revenue as lnv_rev
from fch as f
join linv as l on f.year =l.year
order by f.year
) as a;
# FCH has improved in their capital spending which might be the reason for their recovery in 2024. LINV had also reduced ther expenses but still had a lose in this period, the reason could be more different. Both of the companies have a capital-light , lesser investments fo most expenses are from opEX

#7. Which company has stronger short-term financial sustainability, and how does cash efficiency relate to operating performance?
select year, round(fch_assets/fch_liabilities,2) as fch_current_ratio,
round(lnv_assets/lnv_liabilities,2) as lnv_current_ratio from (
select f.year ,f.current_assets as fch_assets, f.current_liabilities as fch_liabilities,
 l.current_assets as lnv_assets, l.current_liabilities as lnv_liabilities
from fch as f
join linv as l on f.year =l.year
) as a ;
#result: An overall healthy liquidity for FCH >2. The LINV shows an unsually high liquidity > 20 -50 maybe due to lower liabilities which suggest maybe company has not leverage this properly 

#8. Cash burn and runaway
#calculate cash_burn_monthly
select year, round(abs(fch_cash_flow)/12,2) as fch_monthly_cash_burn, round(fch_cash/(abs(fch_cash_flow)/12),0) as fch_runaway,
round(abs(lnv_cash_flow)/12,2) as lnv_monthly_cash_burn, round(lnv_cash/(abs(lnv_cash_flow)/12),0)  as lnv_runaway
  from (
select f.year ,f.operating_cash_flow as fch_cash_flow, f.cash_available as fch_cash,
 l.operating_cash_flow as lnv_cash_flow, l.cash_available as lnv_cash
from fch as f
join linv as l on f.year =l.year
order by f.year
) as a;
#result: Funding Circle maintained superior liquidity across all three years, with a consistent multi-year cash runway — signalling disciplined cash management and strong financing structure. wit runaway more than 24 months
#LendInvest, in contrast, exhibited far higher cash burn and volatile runway trends, indicating aggressive operational scaling followed by rapid cost correction in 2024 where runaway is 8 months in 2022 , ad due to high op ex activities in 2023 reduced to 3months, followed by corrections in 2024

#9. Overall health_index for FCH and LINV on total_revneue, profit_margin, operating_efficiency
with cte_fch as (
select year, round((net_income /total_revenue)*0.4 + (1-(operating_expense/total_revenue))*0.3 
+((total_revenue-cost_of_revenue)/total_revenue)*0.3,2) as fch_health_index
 from fch
 ),
 cte_lnv as (
select year, round((net_income /total_revenue)*0.4 + (1-(operating_expense/total_revenue))*0.3 
+((total_revenue-cost_of_revenue)/total_revenue)*0.3,2) as lnv_health_index
 from linv
 )
 
 select * from cte_fch join cte_lnv on
 cte_fch.year =cte_lnv.year;
 #result:health index is 0.34 highest in 2024 for FCH, and 0.38 hightest for LINV in 2023
 
 #10. On various criteria show if fch or linv was better
 SELECT 
    f.year,
    CASE WHEN f.total_revenue> l.total_revenue THEN 1 ELSE 0 END as fch_revenue,
    CASE WHEN f.net_income/f.total_revenue > l.net_income/l.total_revenue THEN 1 ELSE 0 END as fch_profit_margin,
	CASE WHEN f.operating_cash_flow > l.operating_cash_flow THEN 1 ELSE 0 END as fch_op_cash_flow,
    CASE WHEN f.operating_expense/f.total_revenue < l.operating_expense/l.total_revenue THEN 1 ELSE 0 END as fch_op_efficiency,
	CASE WHEN (f.total_revenue-f.cost_of_revenue)/f.total_revenue > (l.total_revenue-l.cost_of_revenue)/l.total_revenue THEN 1 ELSE 0 END as fch_gross_profit_margin,
    CASE WHEN (f.capital_expenditure/f.total_revenue)< (l.capital_expenditure/l.total_revenue) then 1 else 0 end as fch_capEX,
    CASE WHEN (f.current_assets / f.current_liabilities) > (l.current_assets / l.current_liabilities) THEN 1 ELSE 0 END AS fch_current_ratio
FROM fch f
JOIN linv l ON f.year = l.year
order by f.year;
 # result: In terms of revenue and ,business expansion FCH definelty beats LINV for 3 years consequently . In 2024 FCH seems to be doing better in  profitability, operating efficiency as well
 
 #What ifs?
 #1.If LINV had grown 20% more each year, would it have beaten FCH’s revenue?
 #100%+20% =120 =1.20
 SELECT l.year,
       l.total_revenue AS lnv_revenue,
       ROUND(l.total_revenue * 1.20,2) AS lnv_revenue_plus5pct,
       f.total_revenue AS fch_revenue,
       CASE 
           WHEN l.total_revenue * 1.20 > f.total_revenue THEN 'LINV beats FCH'
           ELSE 'FCH still higher'
       END AS outcome
FROM linv l
JOIN fch f on l.year =f.year
ORDER BY l.year;
#result: Even if 20% in currrent reveneu will not be able to beat FCH

#by what %age is  fch revenue greater than lnv
SELECT l.year,
       l.total_revenue AS lnv_revenue,
       f.total_revenue AS fch_revenue,
       round(((f.total_revenue - l.total_revenue)/l.total_revenue)*100,2)   as fch_revenue_greater_linv
FROM linv l
JOIN fch f on l.year =f.year
ORDER BY l.year;
#result: FCH consistently earned more than LINV, with the gap narrowing in 2023 and widening again in 2024.

 #2. Monotory Analaysis: How much monwy would FCH saved if its operating efficency was same as LINV?
 #copy above code just multiply the eff_gap with the year reveneu of FCH
 with cte as(
 select *, round(fch_op_eff -  lnv_op_eff, 2) as efficiency_gap from (
#calculate the operating efficiency
select year, round(fch_op_exp/fch_rev ,2) as fch_op_eff , round(lnv_op_exp/ lnv_rev ,2)
 as lnv_op_eff
 from (
#collect the necessary columns needed to calculte the operating efficinecy  
select f.year ,f.operating_expense as fch_op_exp, f.total_revenue as fch_rev, 
l.operating_expense as lnv_op_exp,
l.total_revenue as lnv_rev from fch as f
join linv as l on f.year =l.year
 ) as a 
 order by year
 ) as b )
 
 select c.year,fch_op_eff, lnv_op_eff, efficiency_gap ,(efficiency_gap*f.total_revenue) as cost_saved  from cte as c
 join fch f on c.year = f.year;
 # result: if fch had same op efficiency as LINV then it would have saved 17M in 2022, 15M in 2023
 
 #3. FCH seemed to have lower gross margin rate comapred to LINV. what if cogs is reduced by 10%
 #and revnue was improved by 10% will FCH gross profit margin improve than LINV
 USE fin_data;

WITH metrics AS (
    SELECT
        f.year,
        f.total_revenue AS fch_revenue,
        f.cost_of_revenue AS fch_cogs,
        l.total_revenue AS lnv_revenue,
        l.cost_of_revenue AS lnv_cogs
    FROM fch f
    JOIN linv l ON f.year = l.year
),
gross_margin_comparison AS (
    SELECT
        year,
        ROUND((fch_revenue - fch_cogs)/fch_revenue, 2) AS fch_gross_margin,
        ROUND((lnv_revenue - lnv_cogs)/lnv_revenue, 2) AS lnv_gross_margin_orig,
        ROUND(((fch_revenue*1.10) - fch_cogs*0.9)/(fch_revenue*1.10), 2) AS fch_gross_margin_optim
    FROM metrics
)
SELECT *
FROM gross_margin_comparison
ORDER BY year;
# result: 2022 0.43 -> .52 similar to linv, so major improvment, 0.47->0.57 in 2023, does not compare to linv 0.66