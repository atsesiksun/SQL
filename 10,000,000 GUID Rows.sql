create table t1(Id bigint primary key, UniqueId nvarchar(255))

with t2 as (
	(select 1 n1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9 union select 10))
insert into t1(Id, UniqueId)
select 
	a.n1 + ((b.n1-1)*10) + ((c.n1-1)*100) + ((d.n1-1)*1000) + ((e.n1-1)*10000) + ((f.n1-1)*100000) + ((g.n1-1)*1000000) as ans,
	newid() as UniqueId
from 
	t2 a cross join t2 b cross join t2 c cross join t2 d cross join t2 e cross join t2 f cross join t2 g

select * from t1

