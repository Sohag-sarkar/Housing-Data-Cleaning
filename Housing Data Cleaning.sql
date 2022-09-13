-- Checking Data
SELECT * FROM world.`housing data 1`;

-- Date Formating

select SaleDate, str_to_date(SaleDate , '%M%d, %Y ')  FROM world.`housing data 1`;
alter table world.`housing data 1`
add Sale_date date;
update world.`housing data 1`
set Sale_date=str_to_date(SaleDate , '%M%d, %Y ') ;
alter table world.`housing data 1`
drop column SaleDate ;
SELECT * FROM world.`housing data 1`;


-- Populate PropertyAddress Data

SELECT PropertyAddress FROM world.`housing data 1`
where PropertyAddress is null;

update world.`housing data 1`
set PropertyAddress= if(PropertyAddress='', NULL, PropertyAddress);

Select a.ParcelID, a.PropertyAddress,  b.ParcelID, b.PropertyAddress, ifnull( a.PropertyAddress= b.PropertyAddress)
from world.`housing data 1` a
join world.`housing data 1` b
on a.ParcelID= b.ParcelID
and a.UniqueID= b.UniqueID
where a.PropertyAddress is null;

update a
set a.PropertyAddress= ifnull(a.PropertyAddress, b.PropertyAddress)
from world.`housing data 1` a
join world.`housing data 1` b
on a.ParcelID= b.ParcelID
and a.UniqueID= b.UniqueID
where a.PropertyAddress is null;

-- Breaking out Propertyaddress

Select PropertyAddress FROM world.`housing data 1`;
select substring(PropertyAddress,1, position(',' in PropertyAddress)-1) as Address1 , 
substring(PropertyAddress, position(',' in PropertyAddress)+1,length(PropertyAddress) ) as Address2
FROM world.`housing data 1`;

alter table world.`housing data 1`
add PropertySplitAddress nvarchar(250);
update world.`housing data 1`
set PropertySplitAddress= substring(PropertyAddress,1, position(',' in PropertyAddress)-1);

alter table world.`housing data 1`
add PropertySplitCity nvarchar(250);
update world.`housing data 1`
set PropertySplitCity= substring(PropertyAddress, position(',' in PropertyAddress)+1,length(PropertyAddress)) ;

SELECT * FROM world.`housing data 1`;


-- Breaking down OwnerADDRESS

update world.`housing data 1`
set OwnerADDRESS= if(OwnerADDRESS='', NULL, OwnerADDRESS);
SELECT * FROM world.`housing data 1`;

select substring_index(OwnerAddress,',',1),
substring_index( substring_index(OwnerAddress,',',2), ',', -1),
substring_index(OwnerAddress,',',-1)
FROM world.`housing data 1`;

alter table world.`housing data 1`
add OwnersplitAddress nvarchar(300);
 alter table world.`housing data 1`
add OwnersplitCity nvarchar(300);
 alter table world.`housing data 1`
add OwnersplitState nvarchar(300);

update world.`housing data 1`
set OwnersplitAddress= substring_index(OwnerAddress,',',1);
update world.`housing data 1`
set OwnersplitCity= substring_index( substring_index(OwnerAddress,',',2), ',', -1);
update world.`housing data 1`
set OwnersplitState= substring_index(OwnerAddress,',',-1);
SELECT * FROM world.`housing data 1`;


-- Replace N with No and Y with Yes

select distinct(SoldAsVacant) , count(SoldAsVacant) 
FROM world.`housing data 1`
group by SoldAsVacant
order by 2;

select SoldAsVacant,
case
when SoldAsVacant='Y' then 'Yes'
when SoldAsVacant='N' then 'No'
else SoldAsVacant
END
FROM world.`housing data 1`;

update world.`housing data 1`
set SoldAsVacant= case
when SoldAsVacant='Y' then 'Yes'
when SoldAsVacant='N' then 'No'
else SoldAsVacant
END;

-- Remove Duplicates

with rownumCTE as(
select *, row_number() over(
partition by 
ParcelID,
LandUse, PropertyAddress, SalePrice, LegalReference, SoldAsVacant, OwnerName, OwnerAddress, TaxDistrict, Sale_date
order by UniqueID) as row_num
FROM world.`housing data 1`
)
select * from rownumCTE
where row_num>1 ;



-- Delete unused columns

 SELECT * FROM world.`housing data 1`;
 
 alter table world.`housing data 1`
 drop column PropertyAddress ;
 alter table world.`housing data 1`
 drop column OwnerAddress ;
 alter table world.`housing data 1`
 drop column TaxDistrict ;
 SELECT * FROM world.`housing data 1`;




