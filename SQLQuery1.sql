Use Blinkit
go
select * from Blinkit_data;

---Count the total number of rows?
select count(*) as Rows from Blinkit_data;

---What are the Top 10 selling items by their total sales?
select Top 10
    Item_Type,
	sum(Item_Outlet_Sales) as Total_Sales
from Blinkit_data
group by Item_Type 
order by Total_Sales desc;

---What is the total revenue generated by each outlet?
select Outlet_Identifier,Outlet_Type ,
       round(sum(Item_Outlet_Sales),2) as Total_Revenue 
from Blinkit_data
group by Outlet_Type,Outlet_Identifier
order by Total_Revenue desc;

---How do different Price_Tiers impact the Item_Outlet_Sales?
select Price_Tier,
       round(sum(Item_Outlet_Sales),2) as Total_Sales,
	   round(AVG(Item_Outlet_Sales),2) as Avg_total_Sales,
	   Count(*) as Total_Transaction
from Blinkit_data
group by Price_Tier
order by Total_Sales;

---What is the average sales per Outlet_Size?
select Outlet_Size,round(AVG(Item_Outlet_Sales),3) as Avg_Sales
from Blinkit_data
group by Outlet_Size;

---Which Item_Type generates the highest revenue per unit?
select Top 5
      Item_Type,
	  round(sum(Sales_Per_Item),3) as Revenue
from Blinkit_data
group by Item_Type
order by Revenue desc;

---What is the total sales trend for outlets based on their Outlet_Establishment_Year?
select Outlet_Establishment_Year,
       round(sum(Item_Outlet_Sales),3) as Total_Sales,
	   round(AVG(Item_Outlet_Sales),3) as Avg_Sales_Per_Outlet,
	   Count(Outlet_Identifier) as Total_Outlets         
from Blinkit_data
group by Outlet_Establishment_Year
order by Outlet_Establishment_Year desc;

---How are sales distributed by Outlet_Location_Type?
select Outlet_Location_Type,
       round(Sum(Item_Outlet_Sales),3) as Sales_Per_Location 
from Blinkit_data 
group by Outlet_Location_Type 
order by Sales_Per_Location desc;

---Does Item_Visibility significantly affect Item_Outlet_Sales?
select 
   (Case when Item_Visibility between 0 and 0.05 then 'Low_Visibility'
        when Item_Visibility between 0.05 and 0.15 then 'Medium_Visibility' 
		else 'High_Visibility'
   End) as Item_Visibility,
	round(sum(Item_Outlet_Sales),3) as Item_Outlet_Sales,
	count(*) as Total_Items
from Blinkit_data
group by (Case
         when Item_Visibility between 0 and 0.05 then 'Low_Visibility'
         when Item_Visibility between 0.05 and 0.15 then 'Medium_Visibility' 
		 else 'High_Visibility'
         End)
order by Item_Outlet_Sales desc;

---Are Low tier-priced items selling more compared to High tier-priced items?
select
    Price_Tier,
    Count(*) as Total_Items_Sold,
    sum(Item_Outlet_Sales) as Total_Sales,
    round((sum(Item_Outlet_Sales))/ 
          (select sum(Item_Outlet_Sales) 
           from Blinkit_data 
           where Price_Tier in ('Low', 'High'))*100, 2) as Sales_Contribution_Percentage
from Blinkit_data
where Price_Tier in ('Low', 'High')
group by Price_Tier
order by Price_Tier;

---What is the difference in sales between Low Fat and Regular items?
select 
    Item_Fat_Content,
	count(*) as Total_Items_Sold,
	round(sum(Item_Outlet_Sales),3) as Sales,
	round(AVG(Item_Outlet_Sales),3) as Avg_Sales,
	ABS(round((sum(Item_Outlet_Sales) - lag(sum(Item_Outlet_Sales)) over (Order by Item_Fat_Content)),2)) as Sales_Difference
from Blinkit_data
group by Item_Fat_Content
Order by Sales desc;

---Which items have inconsistent sales across outlets?
select 
    Item_Identifier,
	count(distinct Outlet_Identifier) as Outlets_Sold_In,
	round(AVG(Item_Outlet_Sales),3) as Avg_Sales_Per_Outlet,
	round(Max(Item_Outlet_Sales) - Min(Item_Outlet_Sales),3) as Sales_Variance
from Blinkit_data
group by Item_Identifier
Having count(distinct Outlet_Identifier)>1
order by Sales_Variance  desc;








