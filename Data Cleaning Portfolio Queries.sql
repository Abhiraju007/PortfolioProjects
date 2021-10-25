--Cleaning Data in SQL Queries

select *from PortfolioProject.dbo.NashvilleHousing 

--Standardize Date Format
select SaleDate, Convert(Date,SaleDate)
from PortfolioProject.dbo.NashvilleHousing 

Update PortfolioProject.dbo.NashvilleHousing
set SaleDate= Convert(Date,SaleDate)

Alter Table PortfolioProject.dbo.NashvilleHousing
Add SaleDateConverted Date;

Update PortfolioProject.dbo.NashvilleHousing
Set SaleDateConverted = CONVERT(Date,SaleDate)

select SaleDateConverted, Convert(Date,SaleDate)
from PortfolioProject.dbo.NashvilleHousing 

----------------------------------------------------------------------------------------------------------------------
---Populate Property Address Data------

select *
from PortfolioProject.dbo.NashvilleHousing 
--where PropertyAddress is NUll
order by ParcelID

select A.ParcelID,A.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(A.PropertyAddress,B.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing A
join PortfolioProject.dbo.NashvilleHousing B
on A.ParcelID = B.ParcelID
and A.[UniqueID ]<>B.[UniqueID ]
where A.PropertyAddress is null

update A 
Set PropertyAddress = ISNULL(A.PropertyAddress,B.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing A
join PortfolioProject.dbo.NashvilleHousing B
on A.ParcelID = B.ParcelID
and A.[UniqueID ]<>B.[UniqueID ]
where A.PropertyAddress is null


---------------------------------------------------------------------------------------------------------
---Breaking Out Address into Individuals Columns(Address, City, State)

select PropertyAddress
from PortfolioProject.dbo.NashvilleHousing 
--where PropertyAddress is NUll
order by ParcelID

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1) As Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) As Address
from PortfolioProject.dbo.NashvilleHousing


Alter Table PortfolioProject.dbo.NashvilleHousing
Add PropertySplitAddress NVarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1)

Alter Table PortfolioProject.dbo.NashvilleHousing
Add PropertySplitCity NVarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))



select OwnerAddress from PortfolioProject.dbo.NashvilleHousing

Select OwnerAddress,
PARSENAME(replace(OwnerAddress,',','.') , 3),
PARSENAME(replace(OwnerAddress,',','.') , 2),
PARSENAME(replace(OwnerAddress,',','.') , 1)
from PortfolioProject.dbo.NashvilleHousing

Alter Table PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitAddress NVarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
Set OwnerSplitAddress = PARSENAME(replace(OwnerAddress,',','.') , 3)

Alter Table PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitCity NVarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
Set OwnerSplitCity = PARSENAME(replace(OwnerAddress,',','.') , 2)


Alter Table PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitState NVarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
Set OwnerSplitState = PARSENAME(replace(OwnerAddress,',','.') , 1)

select *from PortfolioProject.dbo.NashvilleHousing

-----------------------------------------------------------------------------------------------------

--Change Y and N to Yes and No in "Sold as Vacant" Field

Select distinct(SoldAsVacant), COUNT(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing
group by SoldAsVacant
order by 2 desc

select SoldAsVacant,
case when SoldAsVacant = 'Y' then 'Yes'
     when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 End as NewSoldAsVacant
from PortfolioProject.dbo.NashvilleHousing


Update PortfolioProject.dbo.NashvilleHousing
Set SoldAsVacant =
case when SoldAsVacant = 'Y' then 'Yes'
     when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 End 
from PortfolioProject.dbo.NashvilleHousing

Select distinct(SoldAsVacant), COUNT(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing
group by SoldAsVacant
order by 2 desc

-----------------------------------------------------------------------------------------------------

--Remove Duplicates
with RownmuberCTE as
(select *, ROW_NUMBER() over(
          partition by  [ParcelID],
		                 [PropertyAddress],
                         [SalePrice],
                         [LegalReference]
						 order by 
						 uniqueID)
						 row_num

from PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)

Select * from RownmuberCTE
where row_num> 1

------------------------------------------------------------------------------------------------
--Delete Unused Columns

select *from PortfolioProject.dbo.NashvilleHousing

Alter Table PortfolioProject.dbo.NashvilleHousing
Drop column OwnerAddress, TaxDistrict, PropertyAddress

Alter Table PortfolioProject.dbo.NashvilleHousing
Drop column SaleDate

select *from PortfolioProject.dbo.NashvilleHousing








