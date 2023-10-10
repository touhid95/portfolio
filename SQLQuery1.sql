select*
from project_4..national_housing

select saleDate, CONVERT(date,SaleDate)
from project_4..national_housing

update national_housing
set SaleDate= CONVERT(date, SaleDate)

alter table national_housing
add SaleDateconverted date;

update national_housing
set SaleDateconverted= convert(date, SaleDate)

ALTER TABLE national_housing
Add SaleDateConverted Date;

Update national_housing
SET SaleDateConverted = CONVERT(Date,SaleDate)

select*

from project_4..national_housing
where PropertyAddress is null

Select *
 from project_4..national_housing
--Where PropertyAddress is null
order by ParcelID
Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From Project_4.dbo.national_housing a
JOIN Project_4.dbo.national_housing b
	on b.ParcelID = a.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From Project_4.dbo.national_housing a
JOIN Project_4.dbo.national_housing b
	on b.ParcelID = a.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


--using string and substring to get , separtion
Select *
 from project_4..national_housing
--Where PropertyAddress is null
--order by ParcelID
select substring (PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as address
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, len(PropertyAddress)) as Address
from project_4..national_housing

Alter table national_housing
add address_1 nvarchar(255);

update national_housing
set address_1 = substring (PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE national_housing
Add PropertySplitAddress Nvarchar(255);

Update national_housing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, len(PropertyAddress))

Select *
From Project_4..national_housing


Select OwnerAddress
From project_4.dbo.natinal_housing

--using parser 
Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From project_4..national_housing



ALTER TABLE national_housing
Add OwnerSplitAddress Nvarchar(255);

Update national_housing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE national_housing
Add OwnerSplitCity Nvarchar(255);

Update national_housing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE national_housing
Add OwnerSplitState Nvarchar(255);

Update national_housing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From Project_4..national_housing


Select Distinct(SoldAsVacant), Count(SoldAsVacant) as vacancy_sold
From Project_4.dbo.national_housing
Group by SoldAsVacant
order by 2

-- changing the row data

select SoldAsVacant
, CASE When SoldAsVacant = 'Y' then 'Yes'
	   When SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
	   end
From Project_4..national_housing

update national_housing
set SoldAsVacant= CASE When SoldAsVacant = 'Y' then 'Yes'
	   When SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
	   end


	 
--dupplicate elimination
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

From Project_4.dbo.national_housing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From Project_4.dbo.national_housing
