create procedure uspComparison(@ListOfTables varchar(100), @sql1 nvarchar(max) OUTPUT)
as 
begin
--store all table names in @ListOfTables in #temptable
declare @sql nvarchar(max)
create table #temptable(name varchar(50))
set @sql = 'insert into #temptable 
	select value from string_split(''' + @ListOfTables + ''','',''' + ')'
exec(@sql)


--calculate number of rows in #temptable 
declare @temp_rows int
select 
	@temp_rows = count(*)
from
	#temptable

--calculate number of rows in #temptable that do not exist in database
declare @null_rows int
select 
	@null_rows = count(*)
from
	#temptable as t1
	left join TestDb.sys.tables as t2 on t2.name = t1.name
where 
	t2.name is null

-- if number of rows in #temptable is the same as number of rows in #temptable that do not exist in database, return no table found
if @temp_rows = @null_rows
	begin
		set @sql1 = 'No table found'
	end
else
	begin
		-- if number of rows in #temptable > 1
		if @temp_rows > 1
			begin
			--check if there is any tables in #temptable that do not exist in database, store the tables in variable @table_not_found
			declare @table_not_found varchar(max)
			set @table_not_found = ''
			select 
				@table_not_found = @table_not_found + t1.name + char(10)
			from
				#temptable as t1
				left join TestDb.sys.tables as t2 on t2.name = t1.name
			where 
				t2.name is null
			end
				
		declare @table_name varchar(50)
		declare @table_num int = 1
		declare @counter int = 1
		declare @counter_table_name varchar(50)
		declare @col_count int
		declare @table_with_similar_col int = 0
		declare @table_count int = 0
		create table #temptable2(col_name varchar(50))
		declare @table_name2 varchar(50)
		declare @similar_value_list varchar(max)
		create table #temptable3(col_name varchar(50))
		set @similar_value_list = ''

		-- create cursor str_table for all the tables in #temptable
		declare str_table cursor for 
			select name from #temptable
		open str_table
		--access each table in str_table and put into variable @table_name
		fetch next from str_table into @table_name
		while @@fetch_status = 0
			--insert into a table variable @table_var, all the columns in each @table_name, the name of each @table_name and a number starting from 1 for each @table_name, 
			begin
				declare @table_var table(col_name varchar(50),table_name varchar(50),table_num int)
				insert into @table_var
				select
					c.name,
					@table_name,
					@table_num
				from
					sys.tables t
					inner join sys.columns c on c.object_id = t.object_id
				where
					t.name = @table_name
				-- if it is not the first table in str_table, find all the similar columns between current table and each of the previous tables and insert the names in #temptable2
				if @table_num > 1
					begin
						while @counter < @table_num
							begin
								insert into #temptable2
								select 
									x1.col_name
								from
									(select	
										col_name
									from
										@table_var
									where
										table_name = @table_name) as x1
									inner join
									(select 
										col_name
									from 
										@table_var
									where 
										table_num = @counter) as x2 on x2.col_name = x1.col_name
								-- count the number of similar columns between current table and each of the previous tables and store in variable @col_count
								select @col_count = count(*) from #temptable2
								if @col_count > 0
									begin
										-- if col_count >0, increase @table_with_similar_columns by 1 which tracks the number of tables with similar columns
										set @table_with_similar_col = @table_with_similar_col + 1
										-- get the table name of the previous table that has similar columns with current table
										select 
											@counter_table_name = table_name
										from 
											@table_var
										where 
											table_num = @counter
										-- create cursor to access each of the similar columns between current table and previous table
										declare str_table2 cursor for 
											select col_name from #temptable2
										open str_table2
										fetch next from str_table2 into @table_name2
										while @@fetch_status = 0
											-- find similar values for each similar columns between current table and previous tables and store in #temptable3
											begin
												set @sql = 'insert into #temptable3 select ' + @table_name2 + ' from ' + @table_name + 
													' intersect select ' + @table_name2 + ' from ' + @counter_table_name
												exec(@sql)
												-- move on to next similar columns
												fetch next from str_table2 into @table_name2
											end
											close str_table2
											deallocate str_table2
									end
								-- empty #temptable2
								delete from #temptable2
								-- move on to next previous table
								set @counter = @counter + 1
							end
							-- if current table has similar columns with any previous tables, add 1 to @table_count, which tracks number of tables with similar columns. 
							if @table_with_similar_col > 0
								begin
									if @table_count = 0
										begin 
											set @table_count = @table_count + 2
										end
									else
										begin
											set @table_count = @table_count + 1
										end
								end
							set @table_with_similar_col = 0		
					end
					--reset counter for previous tables to 1
					set @counter = 1
					--increase the number assign to next table
					set @table_num = @table_num + 1
					-- move on to next table in str_table
					fetch next from str_table into @table_name		
			end
			close str_table
			deallocate str_table
			-- remove duplicates in #temptable3 and put all the similar values in #temptable3 into variable @similar_value_list
			select
				@similar_value_list = @similar_value_list + col_name + char(10)
			from 
				#temptable3
			group by
				col_name
	end	
	-- if number of rows in parameter is less than 2, will ask to provide more table for comparison
	if @temp_rows < 2
		begin
			if @null_rows = 0
				begin
					set @sql1 = 'Please provide more tables in input parameter for comparison'
				end
			else
				begin
					set @sql1 = @ListOfTables + ' is not found in the database.' + char(10) + 'Please provide more tables in input parameter for comparison'
				end
		end
	else
		begin
			-- if there is at least 1 table in #temptable that exist in database
			if @temp_rows <> @null_rows
				begin
					-- count number of similar values in #temptable3 and store in @temptable3_rows
					declare @temptable3_rows int 
					select 
						@temptable3_rows = count(*)
					from
						#temptable3
					-- if there is at least one table that do not exist in database
					if  @null_rows > 0
						begin
							-- and there is no similar value, return:
							if @temptable3_rows = 0 
								begin
									set @sql1 = 'Tables not found in database: ' + char(10) + cast(@table_not_found as nvarchar(max)) + char(10)
										+  'Similar columns in ' + cast(@table_count as nvarchar(max)) + ' out of ' + cast(@temp_rows as nvarchar(max)) + 
										' tables and no similar values are found.'
								end
							else
								-- and there is similar values
								begin
									set @sql1 = 'Tables not found in database: ' + char(10) + cast(@table_not_found as nvarchar(max)) + char(10)
										+ 'Similar columns in ' + cast(@table_count as nvarchar(max)) + ' out of ' + cast(@temp_rows as nvarchar(max)) + 
										' tables and similar values are:' + char(10) + @similar_value_list
								end
						end
					-- if all tables exist in database
					else
						begin
							-- and there is no similar values
							if @temptable3_rows = 0 
								begin
									set @sql1 = 'All tables are found in database.' + char(10)
										+ 'Similar columns in ' + cast(@table_count as nvarchar(max)) + ' out of ' + cast(@temp_rows as nvarchar(max)) + 
										' tables and no similar values are found.'
								end
							else
								begin
								-- and the is similar values
									set @sql1 = 'All tables are found in database.' + char(10)
										+ 'Similar columns in ' + cast(@table_count as nvarchar(max)) + ' out of ' + cast(@temp_rows as nvarchar(max)) + 
										' tables and similar values are:' + char(10) + @similar_value_list
								end
						end
				end
		end
end

declare @message nvarchar(max)
exec uspComparison @ListOfTables ='t5', @sql1 =@message output
print @message