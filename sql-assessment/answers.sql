-- 1.
select md.datetime, sum(md.impressions) as daily_impressions
from marketing_data md
group by md.datetime

-- 2.
select top(3) wr.state, sum(wr.revenue) as total_rev
from website_revenue wr
group by wr.state
order by total_rev desc
-- the third best state (OH) generated $37,577 of revenue

-- 3.
select 
		ci.name, 
		sum(md.cost) as total_cost,
		sum(md.impressions) as total_impressions,
		sum(md.clicks) as total_clicks,
		sum(wr.revenue) as total_revenue
from campaign_info ci
join marketing_data md on ci.id = md.campaign_id
join website_revenue wr on ci.id = wr.campaign_id
group by ci.name

-- 4.
select wr.state, sum(md.conversions) as conversions_by_state
from website_revenue wr
join campaign_info ci on wr.campaign_id = ci.id
join marketing_data md on ci.id = md.campaign_id
where ci.name = 'Campaign5'
group by wr.state
order by conversions_by_state desc

--5. 
-- I believe Campaign 4 was the most efficient campaign.
-- Campaign had the following:
    --  Highest revenue/cost ratio (revenue was 41x cost) (second highest was campaign2 at 38x)
    --  Lowest impression-to-conversion ratio, but this campaign may have been for a more niche item. 
    --  Highest profit per conversion. Despite lower conversion, this campaign got converted customers to spend more than other campaigns
    --  Lowest cost per impression. Campaign4 was able to get in front of more people than other campaigns. This contributes to why the lower conversion rate did not hurt the profitability of this campaign
-- Campaign 4 outperformed the other campaigns in terms of efficiency
-- Lowest cost, second highest number of impressions, second highest revenue
-- This is with campaign 3 acting as an outlier because it was 3x the size of the other campaigns.

select 
		ci.name, 
		sum(md.cost) as total_cost,
		sum(md.impressions) as total_impressions,
		sum(md.clicks) as total_clicks,
		sum(wr.revenue) as total_revenue,
		SUM(wr.revenue)/SUM(md.cost) as cost_ratio,
		sum(md.cost)/sum(md.impressions) as cost_per_impression,
		sum(wr.revenue)/sum(md.clicks) as click_spend,
		sum(md.clicks)/sum(md.impressions) as conversion

from campaign_info ci
join marketing_performance_new md on ci.id = md.campaign_id
join website_revenue wr on ci.id = wr.campaign_id
group by ci.name

-- 6.
select 
		wt.day_of_the_week,
		sum(md.conversions)/sum(md.impressions) as conversion_rate,
		sum(wr.revenue)/sum(md.cost) as revenue_per_cost
from (
		select 
		distinct md_in.date as inner_date,
		DateName(weekday, md_in.date) as day_of_the_week
		from marketing_performance_new md_in) as wt
join marketing_data md on wt.inner_date = md.date
join website_revenue wr on wt.inner_date = wr.date
group by day_of_the_week
order by conversion_rate desc


