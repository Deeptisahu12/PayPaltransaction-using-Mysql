select * from merchants;
select * from currencies;
select * from countries;
select * from transactions;
select * from users;


/** 1st question:- As a financial analyst at PayPal, you are tasked with analyzing transaction data to identify key markets.
Determine the top 5 countries by total transaction amount for both sending and 
receiving funds in the last quarter of 2023 (October to December 2023). 
Provide separate lists for the countries that sent the most funds and those that received the most funds. 
Additionally, round the totalsent and totalreceived amounts to 2 decimal places.
**/

select c.country_name,round(sum(t.transaction_amount),2) as total_sent from countries as c
join users as u on c.country_id=u.country_id
join transactions as t on u.user_id=t.sender_id
where date_format(t.transaction_date,'%Y-%m-%d') between "2023-10-01" and "2023-12-31"
group by c.country_name
order by total_sent desc
limit 5;
select c.country_name,round(sum(t.transaction_amount),2) as total_sent from countries as c
join users as u on c.country_id=u.country_id
join transactions as t on u.user_id=t.recipient_id
where date_format(t.transaction_date,'%Y-%m-%d') between "2023-10-01" and "2023-12-31"
group by c.country_name
order by total_sent desc
limit 5;

/** 2nd question :- To effectively manage risk, it's crucial to identify and monitor high-value transactions.
Find transactions exceeding $10,000 in the year 2023 and include 
transaction ID, sender ID, recipient ID (if available), transaction amount, and currency used. **/

select * from merchants;
select * from currencies;
select * from countries;
select * from transactions;
select * from users;

select transaction_id,sender_id,recipient_id,transaction_amount,currency_code from transactions
where transaction_amount>10000 and year(transaction_date)=2023;

/** 3rd question :- The sales team is interested in identifying the top-performing merchants based on 
the number of payments received. The analysis will help the sales team to better 
understand the performance of these key merchants during the specified timeframe.
Your task is to analyze the transaction data and determine the top 10 merchants, 
sorted by the total transaction amount they received, within the period from November 2023 to April 2024.
 For each of these top 10 merchants, provide the following details: merchant ID,
 business name, the total transaction amount received, and the average transaction amount.
 **/
 
 select * from transactions;
 select * from merchants;
 
 select m.merchant_id,m.business_name,sum(t.transaction_amount) as total_received,avg(t.transaction_amount) as average_transaction
 from transactions as t 
 join merchants as m on t.recipient_id=m.merchant_id
 where date_format(t.transaction_date,'%Y-%m-%d') between "2023-11-01" and "2024-04-30"
 group by m.merchant_id,m.business_name
 order by total_received desc
 limit 10;

/** 4th question :- The finance team wants to analyze the company's exposure to currency risks.
Analyze currency conversion trends from 22 May 2023 to 22 May 2024.
 Calculate the total amount converted from each source currency to the top 3 most popular destination currencies.
 **/
 
 select * from merchants;
select * from currencies;
select * from countries;
select * from transactions;
select * from users;

select currency_code,sum(transaction_amount) as total_converted from transactions
where date(transaction_date) >= "2023-05-22" and date(transaction_date)< "2024-05-22"
group by currency_code
order by total_converted desc
limit 3;

/** 5th question :- The finance team is evaluating transaction classifications.
Categorize transactions as 'High Value' (above $10,000) or 'Regular' (below $10,000) 
and calculate the total amount for each category for the year 2023.
**/

select * from transactions;

select case
       when transaction_amount>10000 then "High value"
       else "Regular"
       end as transaction_category,
       sum(transaction_amount)
       from transactions
	where year(transaction_date)=2023
    group by transaction_category;
    
/** 6th question :- To meet compliance requirements, the finance team needs to identify 
the nature of transactions conducted by the company. Specifically, 
you are required to analyze transaction data for the first quarter of 2024 (January to March).
Your task is to create a new column in the dataset that indicates whether each transaction is 
international (where the sender and recipient are from different countries) or domestic 
(where the sender and recipient are from the same country). Additionally,
 provide a count of the number of international and domestic transactions for this period.
 This classification will assist in ensuring compliance with relevant regulations and 
 provide insights into the distribution of transaction types. 
 Please include a detailed summary of the counts for each type of transaction.   **/
 
 select * from users;
 select * from transactions;
 
 SELECT 
    CASE
        WHEN sender.country_id = recipient.country_id THEN 'Domestic'
        ELSE 'International'
    END AS transaction_type,
    COUNT(*) AS transaction_count
FROM transactions as t
JOIN users as sender ON t.sender_id = sender.user_id
JOIN users as recipient ON t.recipient_id = recipient.user_id
WHERE date(t.transaction_date) BETWEEN '2024-01-01' AND '2024-03-31'
GROUP BY transaction_type;

/** 7th question:-
To improve user segmentation, the finance team needs to analyze user transaction behavior.
Your task is to calculate the average transaction amount per user for the past six months, 
covering the period from November 2023 to April 2024. Once you have the average transaction amount for each user, 
identify and list the users whose average transaction amount exceeds $5,000.
This analysis will help the finance team to better understand high-value users and tailor strategies to meet their needs.
**/

select * from transactions;
select * from users;

select u.user_id,u.email,avg(t.transaction_amount) as avg_amount from transactions as t
join users as u on t.sender_id=u.user_id
where date(t.transaction_date) between "2023-11-01" and "2024-04-30"
group by u.user_id,u.email
having avg_amount>5000
order by u.user_id;

/** 8th question :- As part of the financial review, 
the finance team requires detailed monthly transaction reports for the year 2023.
Your task is to extract the month and year from each transaction date and then calculate 
the total transaction amount for each month-year combination. 
This will involve summarizing the total transactions on a monthly basis 
to provide a clear view of financial activities throughout the year.
 Please ensure that your report includes a breakdown of the total transaction 
 amounts for each month and year combination for 2023, 
 helping the finance team to review and analyze the company's monthly financial performance comprehensively.
 **/
 
 select * from transactions;
 
 select year(transaction_date) as transaction_year,month(transaction_date) as transaction_month,sum(transaction_amount) as total_amount
 from transactions
 group by transaction_year,transaction_month
 having transaction_year=2023
 order by transaction_year,transaction_month;
 
/** 9th question :- As part of identifying top customers for a new loyalty program, 
the finance team needs to find the most valuable customer over the past year. 
Specifically, your task is to determine the user who has the highest 
total transaction amount from May 22, 2023, to May 22, 2024.
Please provide the details of this user, including their user ID, 
name, and total transaction amount. This information will help the
 finance team to select the most deserving customer for the loyalty 
 program based on their transaction behavior over the specified period. **/
 
 select * from users;
 select * from transactions;
 
 select u.user_id,u.email,u.name,sum(t.transaction_amount) as total_amount from users as u
 join transactions as t on u.user_id=t.sender_id
 where date_format(t.transaction_date,'%Y-%m-%d') between '2023-05-22' and '2024-05-22'
 group by u.user_id,u.email,u.name
 order by total_amount desc;
 
 /** 10th question :-  
 The finance team is analyzing currency conversion trends to manage exposure to currency risks. 
 Which currency had the highest transaction amount from in the past one year up to today indicating 
 the greatest exposure? (assume today is 22-05-2024) **/
 
 select * from transactions;
 
 select currency_code,sum(transaction_amount) as total from transactions
 where date(transaction_date) between '2023-05-22' and '2024-05-22'
 group by currency_code
 order by total desc;
 
 /** 11th question:- The sales team wants to identify top-performing merchants.
 Which merchant should be considered as the most successful in terms of total 
 transaction amount received between November 2023 and April 2024? **/
 
 select * from users;
 select * from merchants;
 select * from transactions;
 select * from countries;
 
 select m.business_name,sum(t.transaction_amount) as total from merchants as m
 join transactions as t on m.merchant_id=t.recipient_id
 where date(transaction_date) between '2023-11-01' and '2024-04-30'
 group by m.business_name
 order by total desc;
 
 /** 12th question:- As part of a financial analysis, the team needs to categorize transactions 
 based on multiple criteria. Create a report that categorizes transactions into 
 'High Value International', 'High Value Domestic', 'Regular International', 
 and 'Regular Domestic' based on the following criteria:
High Value: transaction amount > $10,000
International: sender and recipient from different countries
Write a query to categorize each transaction and count the number
 of transactions in each category for the year 2023. **/
 
 select * from users;
 select * from transactions;
 
 select case
      when sender.country_id=reciver.country_id and t.transaction_amount <10000 then "Regular Domestic"
      when sender.country_id=reciver.country_id and t.transaction_amount >10000 then "High value Domestic"
      when sender.country_id!=reciver.country_id and t.transaction_amount <10000 then "Regular international"
      else "High value interbantional"
      end as transaction_category,
      count(*) as transaction_count from transactions as t
      join users as sender on t.sender_id=sender.user_id
      join users as reciver on t.recipient_id=reciver.user_id
      where year(t.transaction_date) =2023
      group by transaction_category
      order by transaction_count desc;
      
/** 13th question :- The finance department requires a comprehensive monthly 
report for the year 2023 that segments transactions by type and nature. 
Specifically, the report should classify transactions into 
'High Value' (above $10,000) and 'Regular' (below $10,000), 
and further differentiate them as either 'International' 
(sender and recipient from different countries) or
 'Domestic' (sender and recipient from the same country).

Your task is to write a query that groups transactions by 
year, month, value_category, location_category, 
and then calculates both the total transaction amount
 and the average transaction amount for each group.
 This detailed analysis will provide valuable insights 
 into transaction patterns and help the finance department 
 in their review and planning processes. **/
 
 select year(t.transaction_date) as transaction_year,month(t.transaction_date) as transaction_month,
     case
        when t.transaction_amount>10000 then "High Value"
        else "Regular"
        end as value_category,
    case 
        when sender.country_id =reciver.country_id then "Domestic"
        else "International"
        end as location_category,
        sum(t.transaction_amount) as total_amount,
        avg(t.transaction_amount) as average_amount
        from transactions as t
        join users as sender on t.sender_id=sender.user_id
        join users as reciver on t.recipient_id=reciver.user_id
        where year(t.transaction_date)=2023
        group by transaction_year,transaction_month,value_category,location_category
        order by transaction_year,transaction_month,value_category,location_category;

/** 14th question :- The sales team wants to evaluate the performance of merchants 
by creating a score based on their transaction amounts. The score is calculated as follows:
If total transactions exceed $50,000, the score is 'Excellent'
If total transactions are greater than $20,000 and lesser than or equal to $50,000, the score is 'Good'
If total transactions are greater than $10,000 and lesser than or equal to $20,000, the score is 'Average'
If total transactions are lesser than or equal to $10,000, the score is 'Below Average'
Write a query to assign a performance score to each merchant and calculate the average 
transaction amount for each performance category for the period from November 2023 to April 2024.
**/

select * from transactions;
select * from merchants;

select m.merchant_id,m.business_name,sum(t.transaction_amount) as total_received,
   case
    when sum(t.transaction_amount) >50000 then "Execllent"
    when sum(t.transaction_amount) >20000 and sum(t.transaction_amount) <=50000 then "Good"
    when sum(t.transaction_amount) >10000 and sum(t.transaction_amount) <=20000 then "Average"
    else "Below Average"
    end as performance_score,
    avg(t.transaction_amount) as average_transaction
    from merchants as m
	join transactions as t on m.merchant_id=t.recipient_id
    where date(t.transaction_date) between '2023-11-01' and '2024-04-30'
    group by m.merchant_id,m.business_name
    order by performance_score desc,total_received desc;

/** 15th question :-The marketing team wants to identify users who have been consistently
 engaged over the last year (from May 2023 to April 2024). 
 A consistently engaged user is defined as one who has made at least one
 transaction in at least 6 out of the 12 months during this period.
Write a query to list user IDs and their email addresses for users who 
have made at least one transaction in at least 6 out of 12 months from May 2023 to April 2024.
**/

select * from users;
select * from transactions;

with monthly as(select u.user_id,u.email,date_format(t.transaction_date,'%Y-%m')as years  from users as u
join transactions as t on u.user_id=t.sender_id
where date(t.transaction_date) between '2023-05-01' and '2024-04-30'
),
distinct_month as(
select user_id,email,count(distinct years) as active_month from monthly
group by user_id,email
) select user_id,email from distinct_month
where active_month>=6
order by user_id;

/** 16th question:- The sales team wants to analyze the performance of 
each merchant by tracking their monthly total transaction amounts and identifying 
months where their transactions exceeded $50,000.
Write a query that calculates the total transaction amount for 
each merchant by month, and then create a column to indicate whether 
the merchant exceeded $50,000 in that month. The transaction date range 
should be considered from 1st Nov 2023 to 1st May 2024. The new column should 
contain the values 'Exceeded $50,000' or 'Did Not Exceed $50,000'. Display the merchant ID, 
business name, transaction year, transaction month, total transaction amount, and the 
new column indicating performance status.
**/

select * from merchants;
select * from transactions;

with monthly_amount as( 
    select m.merchant_id,m.business_name,year(t.transaction_date) as transaction_year,month(t.transaction_date) as transaction_month,
sum(t.transaction_amount) as total_transaction_amount from merchants as m
join transactions as t on m.merchant_id=t.recipient_id
where date(t.transaction_date) between '2023-11-01' and '2024-05-01'
group by m.merchant_id,m.business_name,transaction_year,transaction_month
)
select merchant_id,business_name,transaction_year,transaction_month,total_transaction_amount,case
     when total_transaction_amount>50000 then 'Exceeded $50,000'
     else 'Did Not Exceed $50,000'
     end as performance_status from monthly_amount
     order by merchant_id,transaction_year,transaction_month;










