### TASK 2
### Task 2.1 - Set Up

use teamproject;

### Test and checking the data
select *
from green_totalscores g
join population_index p
on g.country_id = p.country;

select *
from carbon_emissions c
join clean_innovation
using (country_id);

### Task 2.2 - Queries and Recommendation
### QUERIES
# QUERY 1
# The average carbon emissions score gouped by continent
select c.continent, avg(ce.carbon_emissions) as total_carbon_emissions
from carbon_emissions ce
join continent_list c 
using (country_id)
group by c.continent
order by total_carbon_emissions desc;

# QUERY 2
# Comparison of renewable energy consumption score to the total energy investement score (= investments in clean enerygy)
# Example: Singapore is not using renewable energy, but they are investing a lot in clean energy
# --> top 10 worst performing countries in sustainable energy transition (if both values are low)
select et.country_id, et.renewable_contribution, ci.energy_investment
from energy_transition et
join clean_innovation ci
using (country_id)
where et.renewable_contribution > 0
order by et.renewable_contribution asc
limit 10;

# QUERY 3
# This query shows the top 5 countries with the highest carbon growth rates and whether they have implemented carbon pricing initiatives
# --> enables to see how effective the pricing policies may be in carbon emissions.
# Carbon Growth: score of 10 = really good
# Anormaly for Ukraine. Their commitment on carbon growth effort is self-commited
select cp.country_id as Country, ce.carbon_growth as Carbon_Growth,
       cp.carbon_pricing as Carbon_Pricing_Initiatives
from carbon_emissions ce
join climate_policy cp using (country_id )
where ce.carbon_growth > 5
order by ce.carbon_growth desc
limit 5;

# QUERY 4
# Countries ranked by food tech investment and their corresponding meat and diary consumption
# FoodTech => vegan, vegetable meat, other alternatives to meat and diary
# rank 1 = best investment in Food Tech
select sub.continent, sub.avg_meat_diary_consume,
    rank() over (order by sub.avg_foodtech_investment desc) as FoodTech
from (
    select c.continent,
        avg(gre.meat_diary_consume) as avg_meat_diary_consume,
        avg(inno.foodtech_investment) as avg_foodtech_investment
    from green_society gre
    join clean_innovation inno USING (country_id)
    join continent_list c
    using (country_id)
    group by c.continent
) as sub;
