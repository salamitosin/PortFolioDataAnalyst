/*

Cleaning Data in SQL Queries

*/

Select *
From DataAnalystPortFolioProjects.dbo.SamVilleHousingDataCleaning

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

Select saleDate, CONVERT(Date,SaleDate)
From DataAnalystPortFolioProjects.dbo.SamVilleHousingDataCleaning

Select saleDateConverted, CONVERT(Date,SaleDate)
From DataAnalystPortFolioProjects.dbo.SamVilleHousingDataCleaning

Update SamVilleHousingDataCleaning
SET SaleDate = CONVERT(Date,SaleDate)


-- If it doesn't Update properly

ALTER TABLE SamVilleHousingDataCleaning
Add SaleDateConverted Date;

Update SamVilleHousingDataCleaning
SET SaleDateConverted = CONVERT(Date,SaleDate)


--------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
From DataAnalystPortFolioProjects.dbo.SamVilleHousingDataCleaning
--Where PropertyAddress is null
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From DataAnalystPortFolioProjects.dbo.SamVilleHousingDataCleaning a
JOIN DataAnalystPortFolioProjects.dbo.SamVilleHousingDataCleaning b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From DataAnalystPortFolioProjects.dbo.SamVilleHousingDataCleaning a
JOIN DataAnalystPortFolioProjects.dbo.SamVilleHousingDataCleaning b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null



--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

Select *
From DataAnalystPortFolioProjects.dbo.SamVilleHousingDataCleaning
--Where PropertyAddress is null

Select PropertyAddress
From DataAnalystPortFolioProjects.dbo.SamVilleHousingDataCleaning
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From DataAnalystPortFolioProjects.dbo.SamVilleHousingDataCleaning


ALTER TABLE SamVilleHousingDataCleaning
Add PropertySplitAddress Nvarchar(255);

Update SamVilleHousingDataCleaning
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE SamVilleHousingDataCleaning
Add PropertySplitCity Nvarchar(255);

Update SamVilleHousingDataCleaning
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




Select *
From DataAnalystPortFolioProjects.dbo.SamVilleHousingDataCleaning





Select OwnerAddress
From DataAnalystPortFolioProjects.dbo.SamVilleHousingDataCleaning


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From DataAnalystPortFolioProjects.dbo.SamVilleHousingDataCleaning



ALTER TABLE SamvilleHousingDataCleaning
Add OwnerSplitAddress Nvarchar(255);

Update SamVilleHousingDataCleaning
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE SamVilleHousingDataCleaning
Add OwnerSplitCity Nvarchar(255);

Update SamVilleHousingDataCleaning
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE SamVilleHousingDataCleaning
Add OwnerSplitState Nvarchar(255);

Update SamVilleHousingDataCleaning
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From DataAnalystPortFolioProjects.dbo.SamVilleHousingDataCleaning


--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

Select SoldAsVacant
From DataAnalystPortFolioProjects.dbo.SamVilleHousingDataCleaning
--Group by SoldAsVacant

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From DataAnalystPortFolioProjects.dbo.SamVilleHousingDataCleaning
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From DataAnalystPortFolioProjects.dbo.SamVilleHousingDataCleaning


Update SamvilleHousingDataCleaning
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

	   --Verify Result
Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From DataAnalystPortFolioProjects.dbo.SamVilleHousingDataCleaning
Group by SoldAsVacant
order by 2


-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates using CTE subqueries in a queries i.e UniqueId

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From DataAnalystPortFolioProjects.dbo.SamVilleHousingDataCleaning
--order by ParcelID
)

Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From DataAnalystPortFolioProjects.dbo.SamVilleHousingDataCleaning


---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From DataAnalystPortFolioProjects.dbo.SamVilleHousingDataCleaning


ALTER TABLE DataAnalystPortFolioProjects.dbo.SamVilleHousingDataCleaning
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate















-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

--- Importing Data using OPENROWSET and BULK INSERT	

--  More advanced and looks cooler, but have to configure server appropriately to do correctly
--  Wanted to provide this in case you wanted to try it


--sp_configure 'show advanced options', 1;
--RECONFIGURE;
--GO
--sp_configure 'Ad Hoc Distributed Queries', 1;
--RECONFIGURE;
--GO


--USE PortfolioProject 

--GO 

--EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'AllowInProcess', 1 

--GO 

--EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'DynamicParameters', 1 

--GO 


---- Using BULK INSERT

--USE PortfolioProject;
--GO
--BULK INSERT nashvilleHousing FROM 'C:\Temp\SQL Server Management Studio\Nashville Housing Data for Data Cleaning Project.csv'
--   WITH (
--      FIELDTERMINATOR = ',',
--      ROWTERMINATOR = '\n'
--);
--GO


---- Using OPENROWSET
--USE PortfolioProject;
--GO
--SELECT * INTO nashvilleHousing
--FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0',
--    'Excel 12.0; Database=C:\Users\alexf\OneDrive\Documents\SQL Server Management Studio\Nashville Housing Data for Data Cleaning Project.csv', [Sheet1$]);
--GO