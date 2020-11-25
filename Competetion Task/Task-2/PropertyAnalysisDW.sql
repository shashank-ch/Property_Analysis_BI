
-- [DimStationEntrancesSydney] Table

SELECT [StopKey]
      ,[StopId]
      ,[TrainStation]
      ,[StreetName]
      ,[StreetType]
      ,[EntranceType]
      ,[LAT]
      ,[LONG]
      ,[Exit_Number]
      ,[Mode]
      ,[StateCode]
  FROM [dbo].[DimStationEntrancesSydney];

-- [DimSuburb] Table

SELECT [SuburbKey]
      ,[SuburbID]
      ,[Postcode]
      ,[SuburbName]
      ,[City]
      ,[State]
      ,[State_Code]
      ,[LAT]
      ,[LON]
      ,[District]
  FROM [dbo].[DimSuburb];


  --[FactPropertyMedainValue_NSW] Table

SELECT [PropertyMedianKey]
      ,[PropertyMedianID]
      ,[SuburbKey]
      ,[DateKey]
      ,[PropertyMedianValue]
  FROM [dbo].[FactPropertyMedainValue_NSW];

-- [FactPublicSchoolsDatasNSW] Table

SELECT [SchoolKey]
      ,[School_ID]
      ,[AgeID]
      ,[School_Name]
      ,[Street]
      ,[Town_Suburb]
      ,[Postcode]
      ,[SuburbKey]
      ,[Student_Number]
      ,[Indigenous_Pct]
      ,[Lbote_Pct]
      ,[Icsea_Value]
      ,[Level_Of_Schooling]
      ,[Selective_School]
      ,[Opportunity_Class]
      ,[School_Specialty_Type]
      ,[School_Subtype]
      ,[Support_Classes]
      ,[Preschool_Ind]
      ,[Distance_Education]
      ,[Intensive_English_Centre]
      ,[School_Gender]
      ,[Phone]
      ,[School_Email]
      ,[Fax]
      ,[Late_Opening_School]
      ,[Date_1St_Teacher]
      ,[Lga]
      ,[Electorate]
      ,[Fed_Electorate]
      ,[Operational_Directorate]
      ,[Principal_Network]
      ,[Facs_District]
      ,[Local_Health_District]
      ,[Aecg_Region]
      ,[Asgs_Remoteness]
      ,[Latitude]
      ,[Longitude]
      ,[DateExtractedKey]
  FROM [dbo].[FactPublicSchoolsDatasNSW];

-- [DimDate] Table

SELECT [DateKey]
      ,[FullDate]
      ,[DateName]
      ,[DayOfWeek]
      ,[DayNameOfWeek]
      ,[DayOfMonth]
      ,[DayOfYear]
      ,[WeekdayWeekend]
      ,[WeekOfYear]
      ,[MonthName]
      ,[MonthOfYear]
      ,[IsLastDayOfMonth]
      ,[CalendarQuarter]
      ,[CalendarYear]
      ,[CalendarYearMonth]
      ,[CalendarYearQtr]
      ,[FiscalMonthOfYear]
      ,[FiscalQuarter]
      ,[FiscalYear]
      ,[FiscalYearMonth]
      ,[FiscalYearQtr]
  FROM [dbo].[DimDate];



