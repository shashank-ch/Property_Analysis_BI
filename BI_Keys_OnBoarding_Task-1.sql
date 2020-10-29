
--a. Display a list of all property names and their property id’s for Owner Id: 1426. 

SELECT p.Name AS 'Property Name',
p.Id as 'Property ID'
FROM Keys.dbo.Property p
INNER JOIN Keys.dbo.OwnerProperty op ON p.Id = op.PropertyId
WHERE op.OwnerId = 1426;


--b. Display the current home value for each property in question a). 

SELECT p.Name AS 'Property Name',
p.Id as 'Property ID',
pf.CurrentHomeValue AS 'Current Home Value'
FROM Keys.dbo.Property p
INNER JOIN Keys.dbo.OwnerProperty op ON p.Id = op.PropertyId
INNER JOIN Keys.dbo.PropertyFinance pf ON op.PropertyId = pf.PropertyId
WHERE op.OwnerId = 1426;



/*c. For each property in question a), return the following:                                                                      
i) Using rental payment amount, rental payment frequency, tenant start date and tenant end date to write a query 
that returns the sum of all payments from start date to end date. 
*/

select * from [dbo].[PropertyRentalPayment] where PropertyId in (5597,5637,5638); --

select * from [dbo].[PropertyRepayment] where PropertyId in (5597,5637,5638);

select * from [dbo].[TenantPaymentFrequencies];

select * from dbo.TenantProperty where  PropertyId in (5597,5637,5638);

select * from dbo.OwnerProperty where OwnerId = 1426;

select * from dbo.Property;

select * from dbo.Tenant;




SELECT p.Name AS 'Property Name',
p.Id as 'Property ID',
prp.Amount,
pr.StartDate,
pr.EndDate,
prp.FrequencyType,
tpf.Name
FROM Keys.dbo.Property p
INNER JOIN Keys.dbo.OwnerProperty op ON p.Id = op.PropertyId
INNER JOIN Keys.[dbo].[PropertyRentalPayment] prp ON prp.PropertyId = op.PropertyId
INNER JOIN Keys.dbo.PropertyRepayment pr ON p.Id = pr.PropertyId
INNER JOIN Keys.dbo.TenantPaymentFrequencies tpf ON prp.FrequencyType = tpf.Id
WHERE op.OwnerId = 1426;

SELECT
p.Name AS 'Property Name',
p.Id as 'Property ID',
tp.PaymentAmount,
tp.StartDate,
tp.EndDate,
tpf.Name as 'Payment Cycle',
CASE 
	WHEN tp.PaymentFrequencyId = 1 THEN tp.PaymentAmount * 52
	WHEN tp.PaymentFrequencyId = 2 THEN tp.PaymentAmount * 26
	WHEN tp.PaymentFrequencyId = 3 THEN tp.PaymentAmount * 12
	ELSE 0
END as 'Total Amount'
FROM Keys.dbo.Property p
INNER JOIN Keys.dbo.OwnerProperty op ON p.Id = op.PropertyId
INNER JOIN dbo.TenantProperty tp ON op.PropertyId = tp.PropertyId
INNER JOIN dbo.TenantPaymentFrequencies tpf ON tp.PaymentFrequencyId = tpf.Id
WHERE op.OwnerId = 1426;


--d.	Display all the jobs available

select * from dbo.Job;

select * from dbo.JobStatus; -- 1,2,3


SELECT 
*
FROM dbo.Job j
INNER JOIN dbo.JobStatus js ON j.JobStatusId = js.Id 
WHERE j.JobStatusId in (1, 2, 3);


/*
e.	Display all property names, current tenants first and last names and rental payments 
per week/ fortnight/month for the properties in question a). 
*/


SELECT
p.Id as 'Property ID',
p.Name AS 'Property Name',
pn.FirstName,
pn.LastName,
tp.PaymentAmount,
tpf.Name as 'Payment Cycle'
FROM Keys.dbo.Property p
INNER JOIN Keys.dbo.OwnerProperty op ON p.Id = op.PropertyId
INNER JOIN dbo.TenantProperty tp ON op.PropertyId = tp.PropertyId
INNER JOIN dbo.Person pn ON tp.TenantId = pn.Id
INNER JOIN dbo.TenantPaymentFrequencies tpf ON tp.PaymentFrequencyId = tpf.Id
WHERE op.OwnerId = 1426
AND tp.IsActive = 1;


-- Task - 2
-- Final Query



SELECT	distinct PropertyExpense.PropertyId, 
		Property.Name AS [Property Name], 
		CONCAT(Person.FirstName, CASE 
								 WHEN Person.MiddleName IS NULL THEN ' '
								 ELSE ' '+Person.MiddleName+' '
								 END
								 , Person.LastName) AS 'Current Owner', 
		CONCAT(Address.Number, ' ', Address.Street, ' ', CASE 
								 WHEN Address.Suburb=Address.City THEN Address.City+' '
								 ELSE Address.Suburb+' '+Address.City+' ' 
								 END
								 , Address.PostCode) AS 'Property Address', 
        Property.Bedroom, Property.Bathroom, 
		TenantProperty.PaymentAmount, TenantPaymentFrequencies.Name AS [Rent Payment Frequency], 
		PropertyExpense.Description AS [Expense Description], PropertyExpense.Amount AS [Expense Amount], PropertyExpense.Date AS [Expense Date]
FROM    Property 
		INNER JOIN PropertyExpense ON Property.Id = PropertyExpense.PropertyId 
		INNER JOIN OwnerProperty  ON Property.Id = OwnerProperty.PropertyId 
		INNER JOIN Person ON Person.Id = OwnerProperty.OwnerId
		INNER JOIN Address ON Property.AddressId = Address.AddressId 
		INNER JOIN (select * from ( select t.*, RANK() OVER (PARTITION BY t.propertyid ORDER BY t.createdon DESC) rank
									from TenantProperty t
									where IsActive = 1
									) t1
					where t1.rank = 1) AS TenantProperty ON PropertyExpense.PropertyId = TenantProperty.PropertyId
		INNER JOIN TenantPaymentFrequencies ON TenantProperty.PaymentFrequencyId = TenantPaymentFrequencies.Id
where PropertyExpense.PropertyId = 5643




SELECT	distinct PropertyExpense.PropertyId, 
		Property.Name AS [Property Name], 
		CONCAT(Person.FirstName, CASE 
								 WHEN Person.MiddleName IS NULL THEN ' '
								 ELSE ' '+Person.MiddleName+' '
								 END
								 , Person.LastName) AS 'Current Owner', 
		CONCAT(Address.Number, ' ', Address.Street, ' ', Address.Suburb, ' ', Address.City, ' ', Address.PostCode) AS 'Property Address', 
        Property.Bedroom, Property.Bathroom, 
		TenantProperty.PaymentAmount, TenantPaymentFrequencies.Name AS [Rent Payment Frequency], 
		PropertyExpense.Description AS [Expense Description], PropertyExpense.Amount AS [Expense Amount], PropertyExpense.Date AS [Expense Date]
FROM    Property 
		INNER JOIN PropertyExpense ON Property.Id = PropertyExpense.PropertyId 
		INNER JOIN OwnerProperty  ON Property.Id = OwnerProperty.PropertyId 
		INNER JOIN Person ON Person.Id = OwnerProperty.OwnerId
		INNER JOIN Address ON Property.AddressId = Address.AddressId 
		INNER JOIN TenantProperty ON PropertyExpense.PropertyId = TenantProperty.PropertyId
		INNER JOIN TenantPaymentFrequencies ON TenantProperty.PaymentFrequencyId = TenantPaymentFrequencies.Id
where	TenantProperty.IsActive = 1
order by 1



select PropertyId, count(*)
from PropertyExpense
group by PropertyId
order by 2 desc; --  4632, 5643


select * from Property where id = 5774

SELECT	PropertyExpense.PropertyId, 
		Property.Name AS [Property Name], 
		CONCAT(Person.FirstName, CASE 
								 WHEN Person.MiddleName IS NULL THEN ' '
								 ELSE ' '+Person.MiddleName+' '
								 END
								 , Person.LastName) AS 'Current Owner', 
		CONCAT(Address.Number, ' ', Address.Street, ' ', Address.Suburb, ' ', Address.City, ' ', Address.PostCode) AS 'Property Address', 
        Property.Bedroom, Property.Bathroom, 
		TenantProperty.PaymentAmount, TenantPaymentFrequencies.Name AS [Rent Payment Frequency], 
		PropertyExpense.Description AS [Expense Description], PropertyExpense.Amount AS [Expense Amount], PropertyExpense.Date AS [Expense Date]
FROM    Property 
		LEFT OUTER JOIN PropertyExpense ON Property.Id = PropertyExpense.PropertyId 
		LEFT OUTER JOIN OwnerProperty  ON Property.Id = OwnerProperty.PropertyId 
		LEFT OUTER JOIN Person ON Person.Id = OwnerProperty.OwnerId
		LEFT OUTER JOIN Address ON Property.AddressId = Address.AddressId 
		LEFT OUTER JOIN TenantProperty ON PropertyExpense.PropertyId = TenantProperty.PropertyId
		LEFT OUTER JOIN TenantPaymentFrequencies ON TenantProperty.PaymentFrequencyId = TenantPaymentFrequencies.Id
where	PropertyExpense.PropertyId = 5774;


select * from TenantProperty where PropertyId = 4632;



SELECT	distinct PropertyExpense.PropertyId, 
		Property.Name AS [Property Name], 
		CONCAT(Person.FirstName, CASE 
								 WHEN Person.MiddleName IS NULL THEN ' '
								 ELSE ' '+Person.MiddleName+' '
								 END
								 , Person.LastName) AS 'Current Owner', 
		CONCAT(Address.Number, ' ', Address.Street, ' ', Address.Suburb, ' ', Address.City, ' ', Address.PostCode) AS 'Property Address', 
        Property.Bedroom, Property.Bathroom, 
		TenantProperty.PaymentAmount, TenantPaymentFrequencies.Name AS [Rent Payment Frequency], 
		PropertyExpense.Description AS [Expense Description], PropertyExpense.Amount AS [Expense Amount], PropertyExpense.Date AS [Expense Date]
FROM    Property 
		INNER JOIN PropertyExpense ON Property.Id = PropertyExpense.PropertyId 
		INNER JOIN OwnerProperty  ON Property.Id = OwnerProperty.PropertyId 
		INNER JOIN Person ON Person.Id = OwnerProperty.OwnerId
		INNER JOIN Address ON Property.AddressId = Address.AddressId 
		INNER JOIN (select * from ( select t.*, RANK() OVER (PARTITION BY t.propertyid ORDER BY t.createdon DESC) rank
									from TenantProperty t
									where IsActive = 1
									) t1
					where t1.rank = 1) AS TenantProperty ON PropertyExpense.PropertyId = TenantProperty.PropertyId
							--	  AND TenantProperty.IsActive = 1
								  -- AND EndDate IS NULL ( Not using this as output has only 72 rows and most of the reports will have one record
		INNER JOIN TenantPaymentFrequencies ON TenantProperty.PaymentFrequencyId = TenantPaymentFrequencies.Id
		--left outer JOIN TenantPaymentFrequencies ON TenantProperty.PaymentFrequencyId = TenantPaymentFrequencies.Id
where PropertyExpense.PropertyId in( 5643, 4409, 12744)
order by 1


SELECT TenantId, count(*) FROM TenantProperty
WHERE IsActive = 1
group by TenantId
order by 2 desc;

select * from (
select t.*,
RANK() OVER (PARTITION BY t.propertyid ORDER BY t.createdon DESC) rank
from TenantProperty t
) t1
where t1.rank = 1
and t1.PropertyId = 2839;


select * from TenantProperty where PropertyId = 4209 and IsActive = 1;


--5613


SELECT	distinct PropertyExpense.PropertyId, 
		count(*)
FROM    Property 
		INNER JOIN PropertyExpense ON Property.Id = PropertyExpense.PropertyId 
		INNER JOIN OwnerProperty  ON Property.Id = OwnerProperty.PropertyId 
		INNER JOIN Person ON Person.Id = OwnerProperty.OwnerId
		INNER JOIN Address ON Property.AddressId = Address.AddressId 
		INNER JOIN (select * from ( select t.*, RANK() OVER (PARTITION BY t.propertyid ORDER BY t.createdon DESC) rank
									from TenantProperty t
									where IsActive = 1
									) t1
					where t1.rank = 1) AS TenantProperty ON PropertyExpense.PropertyId = TenantProperty.PropertyId
							--	  AND TenantProperty.IsActive = 1
								  -- AND EndDate IS NULL ( Not using this as output has only 72 rows and most of the reports will have one record
		INNER JOIN TenantPaymentFrequencies ON TenantProperty.PaymentFrequencyId = TenantPaymentFrequencies.Id
		--left outer JOIN TenantPaymentFrequencies ON TenantProperty.PaymentFrequencyId = TenantPaymentFrequencies.Id
--where PropertyExpense.PropertyId = 7885
group by PropertyExpense.PropertyId
order by 2 desc
-- 4632, 2821, 3082,5643,5613, 4129