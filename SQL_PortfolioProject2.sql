select * from project..NashvilleHousing 

--------------------------------------------------------------------------------------------------------------------------------------------------

--standardize Date format 

select saledate, convert(date, saledate) from project..NashvilleHousing 

alter table project..NashvilleHousing
add saledateconverted date;

update project..NashvilleHousing
set saledateconverted = convert(date, saledate)

--------------------------------------------------------------------------------------------------------------------------------------------------

--Breaking adddress into individual columns (property Address)

select propertyAddress from project..NashvilleHousing 

select substring(propertyAddress, 1, charindex( ',', propertyAddress)-1) as address,
substring(propertyAddress,  charindex( ',', propertyAddress)+1, len(propertyaddress)) as city
from project..NashvilleHousing 

alter table project..NashvilleHousing
add propertySplitAddress varchar(255)

update project..NashvilleHousing
set propertySplitAddress = substring(propertyAddress, 1, charindex( ',', propertyAddress)-1)

alter table project..NashvilleHousing
add propertySplitCity varchar(255);

update project..NashvilleHousing
set propertySplitCity = substring(propertyAddress,  charindex( ',', propertyAddress)+1, len(propertyaddress))

select * from project..NashvilleHousing 

------------------------------------------------------------------------------------------------------------------------------------------------

--Breaking adddress into individual columns (Owner Address) using PARSENAME Function

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From project..NashvilleHousing 

ALTER TABLE project..NashvilleHousing 
Add OwnerSplitAddress Nvarchar(255);

Update project..NashvilleHousing 
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE project..NashvilleHousing 
Add OwnerSplitCity Nvarchar(255);

Update project..NashvilleHousing 
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE project..NashvilleHousing 
Add OwnerSplitState Nvarchar(255);

Update project..NashvilleHousing 
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

select * from project..NashvilleHousing 

------------------------------------------------------------------------------------------------------------------------------------------------

--Change Y and N to Yes and No in "Sold as Vacant" field

select distinct(SoldAsVacant) , count(SoldAsVacant) 
from project..NashvilleHousing 
group by SoldAsVacant
order by 

select SoldAsVacant ,
case when SoldAsVacant = 'Y' THEN 'Yes'
     when SoldAsVacant = 'N' THEN 'No'
	 else  SoldAsVacant
	 END
from project..NashvilleHousing

Update  project..NashvilleHousing
set SoldAsVacant = case when SoldAsVacant = 'Y' THEN 'Yes'
     when SoldAsVacant = 'N' THEN 'No'
	 else  SoldAsVacant
	 END

------------------------------------------------------------------------------------------------------------------------------------------------

--	Remove Duplicates

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
From project..NashvilleHousing
)
DELETE
From RowNumCTE
Where row_num > 1

Select *
From project..NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------------------------

--Delete unused columns

alter  table project..NashvilleHousing
drop column propertyAddress, ownerAddress, TaxDistrict







 



