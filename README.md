# Car Dealership Database SQL Queries

## Compare Databases

This query checks the difference between 2 databases using metadata:

**1. Check whether the 2 databases have same tables** - return the table name for all tables that exist in any 1 database only

**2. Check whether the 2 database have same number of columns in all tables** - return the table name and column numbers for all tables that don't have same number of columns

**3. Check whether the 2 databases have same column orders in all tables** - return the table name, column id and column name for all columns that don't have same column orders

**4. Check whether the 2 databases have the same column data type for all columns in all tables** - return the table name, column id, column name, type id, type name and max length for all columns that don't have same column data type

**5. Check whether the 2 databases have same nullable preference for all columns in all tables** - return the table name, column id, column name and is_nullable for all columns that don't have same nullable preference 

**6. Check whether the 2 databases have same default preference for all columns in all tables** - return the table name, column id, column name and has_default for all columns that don't have same default preference 

**7. Check whether the 2 databases have same indexes in all tables** - return the table name, index id, index type, and index type description for all tables that don't have same in

## 10,000,000 GUID Rows
This query used cross join to create 10,000,000 rows of Id and GUID. The rows are then inserted into a table.
