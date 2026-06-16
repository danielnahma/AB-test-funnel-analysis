-- basic inspect

select * from control_group
union
select * from test_group;

-- check time frame

select min(Date) as 'min' , max(Date) as 'max' 
from control_group

select min(Date) as 'min' , max(Date) as 'max' 
from test_group

-- remove the null column date in both tables


delete 
from control_group
where [Date] = '2019-08-05' 

delete 
from test_group
where [Date] = '2019-08-05' 

--unite table

-- create table
SELECT * INTO all_groups 
FROM control_group;
-- insert the second table
Insert INTO all_groups 
select * FROM test_group;

--explore the data
select * from all_groups;

-- summary table
with totals as(
select Campaign_Name,
sum(Spend_USD) as total_spend,
sum(Impressions) as total_Impressions,
sum(Reach) as total_Reach,
sum(Website_Clicks) as total_Website_Clicks,
sum(Searches) as total_Searches,
sum(View_Content) as total_View_Content,
sum(Add_to_Cart) as total_Add_to_Cart,
sum(purchase) as total_purchase
from all_groups
group by Campaign_Name
)
-- KPIs 
select Campaign_Name,
total_Website_Clicks*100.0/total_Impressions as CTR,
total_spend*1.0/total_Website_Clicks as CPC,
total_spend*1.0/total_purchase  as CPA,
total_spend*1.0/total_Impressions*1000.0  as CPM
from totals;


--funnels conversion
select Campaign_Name,Date,
sum(Spend_USD) as daily_spend,
sum(purchase) as daily_purchase
from all_groups
group by Campaign_Name,Date 
order by Campaign_Name,Date

-- compare daily
with daily as(
select Campaign_Name,Date,
sum(Spend_USD) as daily_spend,
sum(purchase) as daily_purchase
from all_groups
group by Campaign_Name,Date 
), daily_compare as(
select *,
sum(daily_spend) over(partition by Campaign_Name order by Date)as rolling_daily_spend,
lag(daily_purchase) over(partition by Campaign_Name order by Date)as compare_daily_purchase
from daily
)
select *,(daily_purchase-compare_daily_purchase)*100.0/compare_daily_purchase as percent_change from daily_compare

