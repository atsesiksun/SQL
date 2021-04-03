--check table difference
select 
	t1.name as CarDealership_table,
	t2.name as CarDealership2_table
from 
	CarDealership.sys.tables t1
	full join CarDealership2.sys.tables t2  on t2.name = t1.name
where 
	(t1.name is null or t2.name is null)

--check column number difference
Select
	*
From
	(select
		t1.name CarDealership_table,
		count(*) CarDealership_col_number
	 from
		CarDealership.sys.tables t1
		inner join CarDealership.sys.columns c1 on c1.object_id = t1.object_id
	group by
		t1.name,
		c1.object_id) as x1
	full join
	(select
		t2.name CarDealership2_table,
		count(*) CarDealership2_col_number
	 from
		CarDealership2.sys.tables t2
		inner join CarDealership2.sys.columns c2 on c2.object_id = t2.object_id
	group by
		t2.name,
		c2.object_id) as x2 on x2.CarDealership2_table = x1.CarDealership_table
	where
		x1.CarDealership_col_number <> x2.CarDealership2_col_number or x1.CarDealership_col_number is null or x2.CarDealership2_col_number is null

--check column order difference
Select
	*
From
	(select
		t1.name CarDealership_table,
		c1.column_id as CarDealership_col_id,
		c1.name as CarDealership_col_name
	 from
		CarDealership.sys.tables t1
		inner join CarDealership.sys.columns c1 on c1.object_id = t1.object_id) as x1
	full join
	(select
		t2.name CarDealership2_table,
		c2.column_id as CarDealership2_col_id,
		c2.name as CarDealership2_col_name
	 from
		CarDealership2.sys.tables t2
		inner join CarDealership2.sys.columns c2 on c2.object_id = t2.object_id) as x2 on x2.CarDealership2_table = x1.CarDealership_table and x2.CarDealership2_col_name = x1.CarDealership_col_name			
	where
		x1.CarDealership_col_id <> x2.CarDealership2_col_id or x1.CarDealership_col_id is null or x2.CarDealership2_col_id is null

--check column data type difference
Select
	*
From
	(select
		t1.name CarDealership_table,
		c1.column_id as CarDealership_col_id,
		c1.name as CarDealership_col_name,
		c1.system_type_id as CarDealership_type_id,
		y1.name as CarDealership_type_name,
		c1.max_length as CarDealership_max_length
	 from
		CarDealership.sys.tables t1
		inner join CarDealership.sys.columns c1 on c1.object_id = t1.object_id
		inner join sys.types y1 on y1.user_type_id = c1.user_type_id) as x1
	full join
	(select
		t2.name CarDealership2_table,
		c2.column_id as CarDealership2_col_id,
		c2.name as CarDealership2_col_name,
		c2.system_type_id as CarDealership2_type_id,
		y2.name as CarDealership2_type_name,
		c2.max_length as CarDealership2_max_length
	 from
		CarDealership2.sys.tables t2
		inner join CarDealership2.sys.columns c2 on c2.object_id = t2.object_id
		inner join sys.types y2 on y2.user_type_id = c2.user_type_id) as x2 on x2.CarDealership2_table = x1.CarDealership_table and x2.CarDealership2_col_name = x1.CarDealership_col_name
	where
		x1.CarDealership_type_id <> x2.CarDealership2_type_id or x1.CarDealership_max_length <> x2.CarDealership2_max_length or x1.CarDealership_type_id is null or x2.CarDealership2_type_id is null or x1.CarDealership_max_length is null or x2.CarDealership2_max_length is null

--check column nullable difference
Select
	*
From
	(select
		t1.name CarDealership_table,
		c1.column_id as CarDealership_col_id,
		c1.name as CarDealership_col_name,
		c1.is_nullable as CarDealership_is_nullable
	 from
		CarDealership.sys.tables t1
		inner join CarDealership.sys.columns c1 on c1.object_id = t1.object_id) as x1
	full join
	(select
		t2.name CarDealership2_table,
		c2.column_id as CarDealership2_col_id,
		c2.name as CarDealership2_col_name,
		c2.is_nullable as CarDealership2_is_nullable
	 from
		CarDealership2.sys.tables t2
		inner join CarDealership2.sys.columns c2 on c2.object_id = t2.object_id) as x2 on x2.CarDealership2_table = x1.CarDealership_table and x2.CarDealership2_col_name = x1.CarDealership_col_name
	where
		x1.CarDealership_is_nullable <> x2.CarDealership2_is_nullable or x1.CarDealership_is_nullable is null or x2.CarDealership2_is_nullable is null

--check column default difference
Select
	*
From
	(select
		t1.name CarDealership_table,
		c1.column_id as CarDealership_col_id,
		c1.name as CarDealership_col_name,
		c1.default_object_id as CarDealership_has_default
	 from
		CarDealership.sys.tables t1
		inner join CarDealership.sys.columns c1 on c1.object_id = t1.object_id) as x1
	full join
	(select
		t2.name CarDealership2_table,
		c2.column_id as CarDealership2_col_id,
		c2.name as CarDealership2_col_name,
		c2.default_object_id as CarDealership2_has_default
	 from
		CarDealership2.sys.tables t2
		inner join CarDealership2.sys.columns c2 on c2.object_id = t2.object_id) as x2 on x2.CarDealership2_table = x1.CarDealership_table and x2.CarDealership2_col_name = x1.CarDealership_col_name
	where
		x1.CarDealership_has_default <> x2.CarDealership2_has_default or x1.CarDealership_has_default is null or x2.CarDealership2_has_default is null

--check index difference
Select
	*
From
	(select
		t1.name CarDealership_table,
		x1.index_id as CarDealership_index_id,
		x1.name as CarDealership_index_name,
		x1.type as CarDealership_index_type,
		x1.type_desc as CarDealership_index_type_desc
	 from
		CarDealership.sys.tables t1
		inner join CarDealership.sys.indexes x1 on x1.object_id = t1.object_id) as x1
	full join
	(select
		t2.name CarDealership2_table,
		x2.index_id as CarDealership2_index_id,
		x2.name as CarDealership2_index_name,
		x2.type as CarDealership2_index_type,
		x2.type_desc as CarDealership2_index_type_desc
	 from
		CarDealership2.sys.tables t2
		inner join CarDealership2.sys.indexes x2 on x2.object_id = t2.object_id) as x2 on x2.CarDealership2_table = x1.CarDealership_table and x2.CarDealership2_index_id = x1.CarDealership_index_id
	where
		x1.CarDealership_index_id <> x2.CarDealership2_index_id or x1.CarDealership_index_id is null or  x2.CarDealership2_index_id is null or x1.CarDealership_index_name <> x2.CarDealership2_index_name or x1.CarDealership_index_name is null or x2.CarDealership2_index_name is null