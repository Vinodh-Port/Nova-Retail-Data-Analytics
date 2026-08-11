
-- Updating all category names bcoz in tha data set we dont have proper names

	UPDATE Categories
	SET category_name = CASE category_id
		WHEN 1 THEN 'Electronics'
		WHEN 2 THEN 'Men''s Clothing'
		WHEN 3 THEN 'Women''s Clothing'
		WHEN 4 THEN 'Kids Wear'
		WHEN 5 THEN 'Footwear'
		WHEN 6 THEN 'Beauty & Personal Care'
		WHEN 7 THEN 'Home & Kitchen'
		WHEN 8 THEN 'Furniture'
		WHEN 9 THEN 'Mobiles & Accessories'
		WHEN 10 THEN 'Laptops & Computers'
		WHEN 11 THEN 'Home Appliances'
		WHEN 12 THEN 'Groceries & Essentials'
		WHEN 13 THEN 'Books & Stationery'
		WHEN 14 THEN 'Sports & Fitness'
		WHEN 15 THEN 'Toys & Games'
		WHEN 16 THEN 'Jewelry & Watches'
		WHEN 17 THEN 'Luggage & Travel Gear'
		WHEN 18 THEN 'Automotive Accessories'
		WHEN 19 THEN 'Baby Care Products'
		WHEN 20 THEN 'Health & Wellness'
		WHEN 21 THEN 'Pet Supplies'
		WHEN 22 THEN 'Gardening & Outdoors'
		WHEN 23 THEN 'Home Decor'
		WHEN 24 THEN 'Kitchen Appliances'
		WHEN 25 THEN 'Audio & Headphones'
		WHEN 26 THEN 'Cameras & Accessories'
		WHEN 27 THEN 'Fashion Accessories'
		WHEN 28 THEN 'Bedding & Bath'
		WHEN 29 THEN 'Gaming & Consoles'
		WHEN 30 THEN 'Smart Home Devices'
	END
	WHERE category_id BETWEEN 1 AND 30;

-- Customers table lo city wise enthamandi unnaru ani chudataniki

	Select
		city As City,
		Count(customer_id) As TotalCount
	From Customers
	Group By city
	Order By TotalCount DESC;

-- Employees table lo ye store lo enthamandi employees unnaroo chudataniki

	Select
		store_id AS StoreID,
		Count(employee_id) As TotalEmployees
	From Employees
	Group By store_id
	Order By TotalEmployees DESC;

-- Orders table nundi 3K + orders ni process chesina stores details chudataniki

	Select
		store_id As StoreID,
		Count(order_id) As TotalOrders
	From Orders
	Where store_id IS NOT NULL
	Group By store_id
	Having Count(order_id) > 3000
	Order By TotalOrders DESC;

-- Products table lo 300 + products unna category ids ni chudataniki

	Select
		category_id As CategoryID,
		Count(product_id) As TotalProducts
	From Products
	Where product_id IS NOT NULL And category_id IS NOT NULL
	Group By category_id
	Having Count(product_id) > 300
	Order By TotalProducts DESC;

-- Customers and Orders tables use chesi OrderID, CustomerID, City, and OrderDate chudataniki

		SELECT 
			O.order_id AS OrderID,
			C.customer_id AS CustomerID,
			C.city AS CustomerCity,
			O.order_date AS OrderDate
		FROM Orders AS O
		JOIN Customers AS C ON O.customer_id = C.customer_id;


		Select
			C.customer_id As CustomerID,
			C.city As CustomerCity,
			Count(O.order_id) As NumOfOrders,
			O.order_date As OrderedDate
		From Orders O
		Join Customers C On C.customer_id = O.customer_id
		Group by C.customer_id, C.city, O.order_date
		Order By NumOfOrders DESC;

-- OrderItems ni Products ni base cheskuni individual and clubbed ga Quantity and Price chudataniki
	
	-- Individual
		
		Select
			O.order_item_id AS OrderItemID,
			O.qty As Quantity,
			P.product_id As ProductID,
			P.price As Price
		From OrderItems O
		Join Products P On P.product_id = O.product_id
		Where O.qty > 2
		Order By Quantity DESC;
	
	-- Quantity ni group chesi only unit price
		
		Select
			O.qty As Quantity,
			Count(O.order_item_id) As OrdersCount,
			Count(P.product_id) As ProductsCount,
			Round(Sum(P.price), 2) As TotalPrice
		From OrderItems O
		Join Products P On P.product_id = O.product_id
		Group By O.qty
		Order By TotalPrice DESC;

	-- Quantity ni group chesi total price ante Qty * Unit price = Total price
		
		Select
			O.qty As Quantity,
			Count(O.order_item_id) As OrdersCount,
			Count(P.product_id) As ProductsCount,
			Round(Sum(P.price), 2) As UnitPrice,
			Round(Sum(O.qty * P.price), 2) As TotalPrice
		From OrderItems O
		Join Products P On P.product_id = O.product_id
		Group By O.qty
		Order By TotalPrice DESC;

-- Prathi category lo entha Revenue generate aindi chudataniki

	Select
		C.category_name As Category,
		Count(I.order_id) As TotalOrders,
		Sum(I.qty) As TotalQuantity,
		Round(Sum(I.qty * P.price), 2) As TotalRevenue
	From OrderItems I
	Join Products P On P.product_id = I.product_id
	Join Categories C On C.category_id = P.product_id
	Group by C.category_name
	Order By TotalRevenue DESC;

-- Prathi City lo entha revenue generate aindi chudataniki

	Select
		C.city As City,
		Count(Distinct O.order_id) As TotalOrders,
		Round(Sum(P.amount), 2) As TotalSpent
	From Customers C
	Join Orders O On O.customer_id = C.customer_id
	Join Payments P On P.order_id = O.order_id
	Group by C.city
	Order By TotalSpent DESC;

-- Total stores di shipments details chudataniki

	Select
		O.store_id As StoreID,
		Count(S.shipment_id) As TotalShipments,
		Count(Case When S.status = 'Delivered' Then 1 End) As DeliveredShipments,
		Count(Case When S.status = 'late' Then 1 End) As LateShipments,
		Round(Count(Case When S.status = 'late' Then 1 End) * 100.0 / Count(S.shipment_id), 2) As LatePercentage
	From Shipments S
	Join Orders O On S.order_id = S.order_id
	Group By O.store_id
	Order by LatePercentage DESC;

-- Categories wise product pricing and revenue chudali anukunte

	Select
		C.category_name As CategoryName,
		Sum(I.qty) As TotalQuantity,
		Sum(Case When P.price > 2000 Then I.qty Else 0 End) As HighQuantity,
		Sum(Case When P.price <= 2000 Then I.qty Else 0 End) As BudgetQuantity
	From OrderItems I
	Join Products P On P.product_id = I.product_id
	Join Categories C On C.category_id = P.category_id
	Group By C.category_name
	Order By HighQuantity DESC;

-- Prathi store lo salary teskunna top 1 employee ni chudataniki

	With TopSalary AS(
		Select
			E.store_id As StoreID,
			E.employee_id As EmployeeID,
			E.salary As Salary,
			Row_Number() Over(Partition By E.store_id Order By E.salary DESC) As SalaryRank
		From Employees E)
		
		Select 
			StoreID,
			EmployeeID,
			Salary
		From TopSalary
		Where SalaryRank <=3
		Order By StoreID;

-- Prathi category lo high cost product ni chudataniki

	With HighCost As(
		Select
			C.category_name As CategoryName,
			P.product_id As ProductID,
			P.price As Price,
			Row_Number() Over(Partition by C.category_name Order by P.price DESC) As PriceRank
		From Categories C
		Join Products P On P.category_id = C.category_id)
		
		Select
			CategoryName,
			ProductID,
			Price
		From HighCost
		Where PriceRank = 1
		Order By CategoryName;
	
-- Year and Month wise orders trend chudataniki

	Select
		Year(order_date) As OrderYear,
		Format(order_date, 'MMM') As OrderMonth,
		Count(order_id) As TotalOrders
	From Orders
	Where order_date IS NOT NULL
	Group by Year(order_date), Format(order_date, 'MMM'), Month(order_date)
	Order By OrderYear DESC, Month(order_date) ASC;

-- City wise yearly total signups enni chudataniki

	Select
		Year(C.signup_date) As SignupYear,
		Format(C.signup_date, 'MMM') AS SignupMonth,
		C.city AS CityName,
		Count(C.customer_id) As TotalSignups
	From Customers C
	Where C.signup_date IS NOT NULL
	Group By C.city, Year(C.signup_date), Format(C.signup_date, 'MMM'), Month(C.signup_date)
	Order By SignupYear DESC, Month(C.signup_date) ASC, TotalSignups DESC;

-- At least okkasari ina return chesina unique customers ni chudataniki

	SELECT 
		C.customer_id AS CustomerID,
		C.city AS CityName,
		C.signup_date AS SignupDate
	FROM Customers AS C
	WHERE C.customer_id IN (
		SELECT DISTINCT O.customer_id
		FROM Orders AS O
		JOIN OrderItems AS OI ON O.order_id = OI.order_id
		JOIN Returns AS R ON OI.order_item_id = R.order_item_id
	)
	ORDER BY CustomerID ASC;

	-- Or simple ga CTE lo rayachu adi inka clean ga untundi ila messy ga kakunda

	With ReturnOrders As(
		Select
			Distinct O.customer_id As CustomerID
		From Orders O
		Join OrderItems I On I.order_id = O.order_id
		Join Returns R On R.order_item_id = I.order_item_id)

		Select
			C.customer_id As CustomerID,
			C.city As CityName,
			C.signup_date As SignUpDate
		From Customers C
		Join ReturnOrders RO On RO.CustomerID = C.customer_id;

-- Zero Usage Orders ni chudataniki

	With UsedPromotions As(
		Select
			O.promotion_id As PromotionID,
			O.order_id,
			O.store_id
		From Orders O
		Where O.promotion_id IS NOT NULL)

		Select
			P.promotion_id As PromotionID,
			P.discount AS Discount
		From Promotions P
		Left Join UsedPromotions U On P.promotion_id = U.PromotionID
		Where U.PromotionID IS NULL;

-- Union All chesi data ni vertical ga petti price ni base cheskuni product ni segments ga chudataniki

	Select
		P.product_id As ItemID,
		P.category_id As CategoryID,
		P.price As UnitPrice,
		'Premium Product' As PriceSegment
	From Products P
	Where P.price > 4000
	Union All -- Union All ki badulu Union use chesthe duplicates unte remove chestundi present mana data lo duplicates levu kabatti edi use chesina same output vastundi
	Select
		P.product_id As ItemID,
		P.category_id As CategoryID,
		P.price As UnitPrice,
		'Budget Product' As PriceSegment
	From Products P
	Where P.price <= 4000
	Order By UnitPrice DESC;

-- OrderItems nundi bulk orders or single orders ni Union All use chesi chudataniki

	Select
		I.order_id As Orders,
		I.order_item_id As OrderItems,
		I.qty As Quantity,
		'Bulk Orders' As OrderCategory
	From OrderItems I
	Where I.qty > 3
	Union All
	Select
		I.order_id As Orders,
		I.order_item_id As OrderItems,
		I.qty As Quantity,
		'Single Item Orders' As OrderCategory
	From OrderItems I
	Where I.qty = 1
	Order By Quantity DESC;

-- Coalesce use chesi if emina null values unte vatini manaki kavalsina vatitho replace cheyyataniki

	Select
		O.order_id As OrderID,
		O.customer_id As CustomerID,
		ISNULL(O.promotion_id, 0) As PromotionID,
		Coalesce(O.order_date, '1990-01-01') As OrderDate
	From Orders O
	Order By OrderDate DESC;

			-- Actually ISNULL and Coalesce rendu same gane work chesthayi but IsNull anedi only okka column ni check cheyyataniki use avtundi
			-- If mana deggara 3 columns unnai MobilePhone, HomePhone, WorkPhone ani so ISNull use chesthe edo okka column ki matrame null ni replace cheyyagalamu
			-- But Coalesce ala kadu ah 3 columns ni check chestundi if ah 3 null untene manam kavalsina output istundi ledante edoka num ni return chestundi

	Select
		S.order_id As OrderID,
		S.shipment_id AS ShipmentID,
		Coalesce(S.status, 'Pending') As DeliveryStatus
	From Shipments S
	Order by ShipmentID ASC;

-- Window functions use chesi edina table ni chudataniki

	Select
		O.order_id As OrderID,
		O.customer_id As CustomerID,
		O.order_date As OrderDate,
		ROW_NUMBER() Over(Partition By O.customer_id Order By O.order_date DESC) As RowNum,
		DENSE_RANK() Over(Partition By O.customer_id Order By O.order_date DESC) As DenseRank,
		Rank() Over(Partition By O.customer_id Order By O.order_date DESC) As Ranking
	From Orders O
	Order By CustomerID ASC, OrderDate DESC;

-- Window functions use chesi prathi Customer chesina Highest Quantity Purchase Items ni chudataniki

	With RankedItems AS(
	Select
		O.order_id AS OrderID,
		O.customer_id As CustomerID,
		I.product_id AS ProductID,
		I.qty AS Quantity,
		ROW_NUMBER() Over (Partition by O.customer_id Order By I.qty DESC) As ItemRank
	From Orders O
	Join OrderItems I On I.order_id = O.order_id)

	Select
		CustomerID,
		OrderID,
		ProductID,
		Quantity
	From RankedItems
	Where ItemRank = 1
	Order By CustomerID ASC;

-- Previous row and Next row data ni chudali ante Lag() and Lead() use chestham so ala data comparission chudataniki

	Select
		O.order_id As OrderID,
		O.customer_id As CustomerID,
		O.order_date As OrderDate,
		Lag(O.order_date, 1) Over(Partition By O.customer_id Order By O.order_date ASC) As PreviousOrderDate,
		Lead(O.order_date, 1) Over(Partition By O.customer_id Order By O.order_date ASC) As NextOrderDate
	From Orders O
	Order By CustomerID ASC, OrderDate ASC;

-- Dates madhyalo difference chudataniki DatedIff() use chestham alane dates ki days ni add/subtract cheyyataniki DateADD() ni use chestham

	Select
		O.order_id AS OrderID,
		O.customer_id As CustomerID,
		O.order_date AS OrderDate,
		DateADD(Day, 5, O.order_date) As EstimatedDelivery, -- Value ni positive ga isthe adi add chestundi indulo 5 days add chesina date ni chupistundi
		DateADD(Day, -5, O.order_date) As EstimatedDelivery, -- Value ni Negative ga isthe adi Subtract chestundi indulo 5 days tagginchina date ni chupistundi
		DatedIFF(Day, O.order_date, GETDATE()) As DateSinceOrder, -- GetDate() ante ivvalti date ostundi so table lo unna date ki ivvalati date ki madhyalo enni days unnai ani teliyali kabatti Day use chesam
		DatedIFF(Month, O.order_date, GETDATE()) As DateSinceOrder, -- GetDate() ante ivvalti date ostundi so table lo unna date ki ivvalati date ki madhyalo enni months unnai ani teliyali kabatti Month use chesam
		DatedIFF(Year, O.order_date, GETDATE()) As DateSinceOrder -- GetDate() ante ivvalti date ostundi so table lo unna date ki ivvalati date ki madhyalo enni Years unnai ani teliyali kabatti Year use chesam
	From Orders O
	Where O.customer_id < 4
	Order By O.customer_id ASC;


	Select
		C.city As City,
		C.customer_id AS CustomerID,
		C.signup_date As SignupDate,
		DateADD(Day, 30, C.signup_date) As DaysAfter,
		DateADD(Month, 2, C.signup_date) As MonthsAfter,
		DateADD(Year, 1, C.signup_date) As YearAfter,
		DateADD(Year, -1, C.signup_date) As YearBefore,
		DatedIFF(Day, C.signup_date, GetDate()) As DaysSignedUp,
		DatedIFF(Month, C.signup_date, GetDate()) As MonthsSignedUp,
		DatedIFF(Year, C.signup_date, GetDate()) As YearsSignedUp
	From Customers C
	Order By CustomerID ASC;

-- String Manipulations and Text funtions (Concat, Upper, Lower, Substring, Replace, Trim) ni chuddam

	Select
		C.customer_id As CustomerID,
		C.city As RawCity,
		Upper(C.city) As CityUpper,
		Lower(Trim(C.city)) AS CityLower,
		Concat('Cust - ', C.customer_id, ' - ', Upper(C.city)) AS CustomerCode,
		Substring(C.city, 1, 3) AS CityShortCode
	From Customers C
	Order By CustomerID ASC;

	Select
		C.category_id As CategoryID,
		C.category_name As CategoryName,
		Upper(C.category_name) As CategoryNameUpper,
		SUBSTRING(C.category_name, 1, 4) As ShortCode,
		Concat('Cat-', Upper(Trim(SUBSTRING(C.category_name, 1, 4))), '-', C.category_id) As CategoryTag
	From Categories C
	Order By CategoryID ASC;

	SELECT 
		category_name AS OriginalName,
		REPLACE(category_name, '&', 'and') AS ReplacedName, -- Replace ela wrk avtundi ante mana deggara unna category names lo & symbol undi danni and ga change chesam so first denni change cheyyalo adi ivvali trvtha dentho change cheyyalo adi ivvali
		REPLACE(category_name, ' ', '_') AS FormattedCode
	FROM Categories;

-- Conditional logic use chesi query rayatam ante manam excel lo If elano ikkada idi ala

	Select
		O.order_id AS OrderID,
		O.price AS Price,
		Case
			When O.price > 2000 Then 'High Value Order'
			When O.price <= 2000 and O.price >= 500 Then 'Medium Value Order'
			Else 'Low Value Order'
		End As OrderCategory
	From OrderItems O
	Order By Price DESC;

	Select
		S.shipment_id AS ShipmentID,
		S.status AS ShipmentStatus,
		Case
			When S.status = 'Delivered' Then 'Completed'
			When S.status = 'Late' Then 'Action Required'
			When S.status = 'Shipped' Then 'In Transit'
			Else 'Pending Dispatch'
		End As DeliveryAlert
	From Shipments S
	Order By ShipmentID ASC;

-- CTE (CommonTable Expressions) use chesi queries rayatam chuddam CTEs anevi best way than Subquery and easy kuda and CTEs anevi oka temporary tables ni create cheskuni vatini base cheskuni output teskostham

	With PriceRange As (
		Select
			C.customer_id AS CustomerID,
			O.order_id AS OrderID,
			O.store_id AS StoreID,
			I.qty As Quantity,
			Sum(I.price) AS Price
		From Customers C
		Join Orders O On O.customer_id = C.customer_id
		Join OrderItems I On I.order_id = O.order_id
		Group By 
			C.customer_id,
			O.order_id,
			O.store_id,
			I.qty)
		
		Select * From PriceRange
		Where Price > 5000
		Order By CustomerID ASC, Quantity ASC;
	
	------------------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------
	
	With RevenueCategory As(
		Select
			C.category_name AS CategoryName,
			Count(I.order_id) As totalItemsSold,
			Sum(I.price) AS TotalCategoryRevenue
		From OrderItems I
		Join Products P On P.product_id = I.product_id
		Join Categories C On C.category_id = P.category_id
		Group By C.category_name)

		Select * From RevenueCategory
		Where TotalCategoryRevenue > 52000000
		Order By TotalCategoryRevenue ASC;

	------------------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------	

	With CustomerSpend As(	
		Select
			C.customer_id As CustomerID,
			C.city As CustomerCity,
			Sum(I.price) As TotalSpend
		From Orders O
		Join Customers C On O.customer_id = C.customer_id
		Join OrderItems I On I.order_id = O.order_id
		Group By C.customer_id, C.city),

		Benchmark AS(
			Select
				CS.CustomerCity,
				Avg(CS.TotalSpend) As AvrgSpend
			From CustomerSpend CS
			Group By CS.CustomerCity)

		Select
			CS.CustomerID,
			CS.CustomerCity,
			CS.TotalSpend,
			B.AvrgSpend,
			(CS.TotalSpend - B.AvrgSpend) As SpendAbvAvrg
		From CustomerSpend CS
		Join Benchmark B On B.CustomerCity = CS.CustomerCity
		Where CS.TotalSpend > B.AvrgSpend
		Order By SpendAbvAvrg DESC, CustomerCity ASC;

	------------------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------

	With StoreSum As (
		Select
			O.customer_id As CustomerID,
			O.store_id As StoreID,
			Sum(I.price) As TotalPrice
		From Orders O
		Join OrderItems I On I.order_id = O.order_id
		Group by O.customer_id, O.store_id),

		StoreAvrg As(
		Select
			S.StoreID,
			Avg(S.TotalPrice) As TotalAvrgPrice
		From StoreSum S
		Group by S.StoreID)

		Select
			S.CustomerID,
			S.StoreID,
			S.TotalPrice,
			A.TotalAvrgPrice
		From StoreSum S
		Join StoreAvrg A On A.StoreID = S.StoreID
		Where TotalPrice > TotalAvrgPrice
		Order By S.StoreID ASC, S.TotalPrice DESC;

-- Customers order chesina previous and current price ki unna growth difference chudataniki

	With PreviousOrders As(	
		Select
			O.customer_id AS CustomrID,
			O.order_id As OrderID,
			O.order_date As OrderedDate,
			I.price As TotalPrice,
			Lag(I.price, 1, 0) Over (Partition By O.customer_id Order By O.order_id ASC) As PreviousOrderPrice
		From Orders O
		Join OrderItems I On I.order_id = O.order_id
		)

		Select
			CustomrID,
			OrderID,
			OrderedDate,
			TotalPrice,
			PreviousOrderPrice,
			(TotalPrice - PreviousOrderPrice) As GrowthDiff
		From PreviousOrders
		Order By CustomrID ASC;

-- Same customers ki chusinatle Products ki chuddam

	With PriceDiff As(	
		Select
			I.product_id AS ProductID,
			I.order_id AS OrderID,
			I.price As CurrentPrice,
			Lag(I.price, 1, 0) Over (Partition By I.product_id Order By I.order_id ASC) AS BeforePrice,
			Lead(I.price, 1, 0) Over (Partition By I.product_id Order By I.order_id ASC) AS AfterPrice
		From OrderItems I
		Join Orders O On O.order_id = I.order_id)
		Select
			P.ProductID,
			P.OrderID,
			P.CurrentPrice,
			P.BeforePrice,
			P.AfterPrice,
			(P.CurrentPrice - P.BeforePrice) As BeforeDiff,
			(P.CurrentPrice - P.AfterPrice) As AfterDiff
		From PriceDiff P
		Order By ProductID ASC;

-- Stored Procedures ela work avthayo chuddam

	Create Or Alter Procedure Sp_GetAllOrders As  -- Views ela rasthamo stored procedures kuda anthy Create Or Alter tho start chesi oka Name assign chestham

		Begin		-- Stored Procedures lo Oka query anthatini Begin and End ki madhyalo rastham ante manaki kavalsina output ki tagina query ni andulo raskuntam
			Select
				O.customer_id AS CustomerID,
				O.order_id As OrderID,
				O.order_date As OrderDate,
				I.price AS Price
			From Orders O
			Join OrderItems I On I.order_id = O.order_id
			Order By CustomerID ASC
		End;						-- Ikkaditho Stored Procedure anedi end avtundi, if manam emina edit cheyyali query ni anukunte Alter ni pettakapothe edit avvadu

		Exec Sp_GetAllOrders; -- Manam create chesina Stored Procedure ni call chesi output chudataniki ila "Exec" use chesi Name ni istham then output vastundi

	-----------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------
	
	Create Or Alter Procedure Sp_GetOrdersByCustomers
		@CustomerID INT    -- Idi oka parameter ante idi manam output ni decide cheyyataniki use avtundi "@" ni use cheyyali and INT, DECIMAL ilantivi use cheyyali based on columns data
	As

		Begin
			Select
				O.customer_id AS CustomerID,
				O.order_id As OrderID,
				O.order_date As OrderDate,
				I.price AS Price,
				Lag(I.price, 1, 0) Over (Partition By O.customer_id Order By O.order_id ASC) AS PreviousPrice 
			From Orders O
			Join OrderItems I On I.order_id = O.order_id
			Where O.customer_id = @CustomerID -- Ikkada dynamic ga em cheptunnam ante Exec query use chesinappudu @CustomerID ki em value isthe danni ikkada return cheyyamani cheptundi
			Order By CustomerID ASC
		End;

		Exec Sp_GetOrdersByCustomers @CustomerID = 135; -- So ikkada chusthe "@" ki manam em use chesamo adi ikkada call cheyyali ledante error chupistundi

	-----------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------	
	
	Create Or Alter Procedure Sp_GetHighValueOrders
		@CustomerID INT,
		@MinPrice Decimal (10, 2) -- Indaka nerchukunnatle ikkada manam inkoka parameter ni icham so ikkada yenni parameters ni add chesthe avi anni Exec lo call cheyyali
	As

		Begin
			Select
				O.customer_id AS CustomerID,
				O.order_id As OrderID,
				O.order_date As OrderDate,
				I.price AS Price,
				Lag(I.price, 1, 0) Over (Partition By O.customer_id Order By O.order_id ASC) AS PreviousPrice 
			From Orders O
			Join OrderItems I On I.order_id = O.order_id
			Where 
				O.customer_id = @CustomerID And
				I.price >= @MinPrice
			Order By CustomerID ASC
		End;

		Exec Sp_GetHighValueOrders
			@CustomerID = 156,
			@MinPrice = 3000;

	-----------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------
	
	Create Or Alter Procedure Sp_GetCustomerTotalSpend
		@CustomerID INT,
		@TotalSpend INT OUTPUT -- Final ga yedi ithe chupinchali anukuntunnamo daniki Output ani ivvali and ee Output anedi Exec lo kuda ivvali ledante error throw chestundi
	As

	Begin
		Begin Try  -- Begin Try ante indaka lagane manam query ni run chestham but Try lo run chestham if emina errors osthe kinda unna Catch lo display avvalsinadi display avtundi
			Select
				@TotalSpend = Sum(I.price)
			From Orders O
			Join OrderItems I On I.order_id = O.order_id
			Where O.customer_id = @CustomerID
		End Try  -- Begin chesina Try ni End cheyyali so that Catch ni start cheyachu

		Begin Catch  -- If Try lo emina errors osthe then hang avvakunda ee Print statement ni chupistundi
			Print 'Database Error'
		End Catch  -- Catch ni End chesi final End ni kuda end cheyyali 
	End;

	Declare @MyResult INT;  -- So paina chesina query output antha oka table lo store cheskuntundi daniki oka name ni fix chestunnam
	Exec Sp_GetCustomerTotalSpend
		@CustomerID = 1,
		@TotalSpend = @MyResult Output;  -- So Declare cheskunna name ki Output ni add chestunnam and Output ani kachitam ga ivvali
	SELECT @MyResult AS TotalSpendOfCustomer; -- Ah store cheskunna table nundi ochina Output ni Select chestunnam so that manaki kavalsina data chudataniki

				-- Only value ni chudataniki Select use chesam but ala kakunda ah value ni base cheskuni category laga edina decide cheyyali anukunte and edina single output oche values unnapudu Output and Declare ni use chestham
				-- Max ee Output and Declare ni use chesi edina single value outputs kosam and ah values ni use cheskuni If else tho vatini describe cheyyatam alativi use chestham for example
	
	Declare @MyResult INT;
	Exec Sp_GetCustomerTotalSpend
		@CustomerID = 1,
		@TotalSpend = @MyResult Output;
	If @MyResult > 20000
	Begin
		Print 'Total Spend is above 20K'
	End
	Else
	Begin
		Print 'Total Spend is below 20K'
	End;

	-----------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------


	



































