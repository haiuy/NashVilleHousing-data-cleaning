# NashVilleHousing-data-cleaning
In this project, I take raw housing data and transform it in SQL server to make it more usable for analysis.
- Convert function is used to standardize date time data.
- Some missing values of property address are populated based on their same parcel ID.
- Individual columns of address, city and state are divided by substring and parsename from property address to help simplifying analysis processes.
- "y" and "n" values in Sold As Vacant field are transformed to "Yes" and "No" using case statement.
- Removing duplicates and delete some unused columns of the dataset.
