# Car Dealership Database SQL Queries

## Compare Databases

This query checks the difference between 2 databases using metadata:

1. Check whether the 2 databases have same tables - return the table name for all tables that exist in any 1 database only

2. Check whether the 2 database have same number of columns in all tables - return the table name and column numbers for all tables that don't have same number of columns

3. Check whether the 2 databases have same column orders in all tables - return the table name, column id and column name for all columns that don't have same column orders

4. Check whether the 2 databases have the same column data type for all columns in all tables - return the table name, column id, column name, type id, type name and max length for all columns that don't have same column data type

5. Check whether the 2 databases have same nullable preference for all columns in all tables - return the table name, column id, column name and is_nullable for all columns that don't have same nullable preference 

6. Check whether the 2 databases have same default preference for all columns in all tables - return the table name, column id, column name and has_default for all columns that don't have same default preference 

7. Check whether the 2 databases have same indexes in all tables - return the table name, index id, index type, and index type description for all tables that don't have same in



## Compare Tables

This query creates a store procedure that accepts a list of tables as a string parameter "@ListOfTables" and an output string parameter @sql1. The store procedure compares the columns and values for all tables listed 
in @ListOfTables and return the number of tables that have similar columns and list all similar values.

Steps:

1. Use string_split to store the table names in @ListOfTables in a temporary table

2. Count number of table names in @ListOfTables and store in a variable

3. Count number of table names in @ListOfTables that do not exist in database and store in a variable

4. If number of tables names in @ListOfTables = number of table names in @ListOfTables that do not exist in database, @sql1 will return no table found. Otherwise continue to next step.

5. If number of table names in @ListOfTables > 1, store all table names that do not exist in database in a variable. Use cursor to loop through each table name in @ListOfTables temporary table.For each table name, insert all the columns in the current table, the current table name and a number starting from 1 assigned to each current table into a table variable. If the current table name is not first table name in @ListOfTables, find all the similar columns between current table and each of the previous tables and insert all the similar column names in temporary table. Count the number of similar columns and store in a variable. If similar column count > 0, use cursor to access each of the similar columns to find similar values and store result in temporary table. Empty the temporary table that contain all similar columns and move on to next previous table. If current table has similar columns with any of the previous tables, add 1 to variable that tracks number of tables with similar columns. Move on to next current table. End If.

6. If number of table names in @ListOfTables < 2, @sql1 will ask for more table in input parameter for comparison if all tables exist in database or @sql1 will return @ListOfTables not found, please provide more table in input parameter for comparison. Otherwise continue to next step.

7. If at least 1 table in @listOfTable exist in database, count number of similar values and store in a variable. If there is at least one table that do not exist in datase and count of similar values = 0, @sql1 will return the name of tables not found, number of table with similar columns out of total tables and no similar values found. If count of similar values > 0, @sql1 will return the name of tables not found, number of table with similar columns out of total tables and list all similar values. If all tables exist in database and there is no similar values, @sql1 will return all tables are found in database, number of table with similar columns out of total tables and no similar values found. If count of similar values > 0, @sql1 will return all tables are found in database, number of table with similar columns out of total tables and list all similar values.


## 10,000,000 GUID Rows
This query used cross join to create 10,000,000 rows of Id and GUID. The rows are then inserted into a table.
