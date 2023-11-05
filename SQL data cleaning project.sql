select *
From DataCleaningProject.dbo.NashvilleHousing

--Standardize date fromat
select SaleDate, convert(Date,SaleDate)
From DataCleaningProject.dbo.NashvilleHousing

Alter table NashvilleHousing
add SaleDateConverted Date;

Update NashvilleHousing
Set SaleDateConverted=convert(Date,SaleDate)

--populate property address data
select *
From NashvilleHousing
where PropertyAddress is null

select  a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From NashvilleHousing a
Join NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

Update a
Set PropertyAddress=ISNULL(a.PropertyAddress, b.PropertyAddress)
From NashvilleHousing a
Join NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

--Breaking out address into individual columns (Address, City, State)
select substring(PropertyAddress, 1, charindex(',',PropertyAddress)-1) as Address, substring(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, Len(PropertyAddress)) as Address
From NashvilleHousing

alter table NashvilleHousing
add PropertySplitAddress nvarchar(255)

update NashvilleHousing
Set PropertySplitAddress=substring(PropertyAddress, 1, charindex(',',PropertyAddress)-1)

alter table NashvilleHousing
add PropertySplitCity nvarchar(255)

Update NashvilleHousing
Set PropertySplitCity = substring(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, Len(PropertyAddress))

select *
From NashvilleHousing



select
parsename(replace(OwnerAddress, ',', '.'), 1)
, parsename(replace(OwnerAddress, ',', '.'), 2)
, parsename(replace(OwnerAddress, ',', '.'), 3)
From NashvilleHousing


alter table NashvilleHousing
add OwnerSplitAddress Nvarchar(255);

update NashvilleHousing
set OwnerSplitAddress = parsename(replace(OwnerAddress, ',', '.'),3)

alter table NashvilleHousing
add OwnerSplitCity Nvarchar(255);
update NashvilleHousing
set OwnerSplitCity = parsename(replace(OwnerAddress, ',', '.'),2)

alter table NashvilleHousing
add OwnerSplitState Nvarchar(255);
update NashvilleHousing
set OwnerSplitState = parsename(replace(OwnerAddress, ',', '.'),1)

select *
from NashvilleHousing

-- change Y and N to 'yes' and 'no' in "sold as vacant" field
Select distinct (SoldAsVacant), Count(SoldAsVacant)
From NashvilleHousing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant,
Case When SoldAsVacant ='Y' then 'Yes'
	When SoldAsVacant ='N' then 'No'
	ELse SoldAsVacant
	End
From NashVilleHousing

Update NashvilleHousing
Set SoldAsVacant =Case When SoldAsVacant ='Y' then 'Yes'
	When SoldAsVacant ='N' then 'No'
	ELse SoldAsVacant
	End

--Remove duplicates
With RowNumCTE as(
Select *,
ROW_NUMBER() over(
partition by ParcelID,
			PropertyAddress,
			SalePrice,
			SaleDate,
			LegalReference
			Order by UniqueID) 
			row_num
From NashvilleHousing
)
select *
From RowNumCTE
where row_num >1

--Delete unused columns
select * 
From NashvilleHousing

Alter table NashvilleHousing
Drop column OwnerAddress, TaxDistrict, PropertyAddress

Alter table NashvilleHousing
Drop column SaleDate