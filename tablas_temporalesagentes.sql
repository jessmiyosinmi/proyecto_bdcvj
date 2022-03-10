
USE [agentes_forestalesprueba]
GO

drop table informe_suceso 
go 

create table informe_suceso 
	(   id_informe integer Primary Key Clustered,  
		motivo varchar (50),  
	SysStartTime datetime2 generated always as row start not null,  
	SysEndTime datetime2 generated always as row end not null,  
	period for System_time (SysStartTime,SysEndTime) ) 
	with (System_Versioning = ON (History_Table = dbo.informe_suceso_historico)
	) 
go

SELECT * FROM [dbo].[informe_suceso]
GO

SELECT * FROM [dbo].[informe_suceso_historico]
GO

insert into [dbo].[informe_suceso]
values  ('1','pesca'), 
		('2','caza'), 
		('3','incendio'), 
		('4','residuo')

GO 



SELECT * FROM [dbo].[informe_suceso]
GO

update [dbo].[informe_suceso]
	set [motivo]  = 'epis'
	where [id_informe] = '1'
GO

SELECT * FROM [dbo].[informe_suceso]
GO

SELECT * FROM [dbo].[informe_suceso_historico]
GO

update [dbo].[informe_suceso]
	set [motivo]  = 'forestal'
	where [id_informe] = '2'
GO

SELECT * FROM [dbo].[informe_suceso]
GO

SELECT * FROM [dbo].[informe_suceso_historico]
GO


Delete from [dbo].[informe_suceso]
	where [id_informe] = '4'
GO

SELECT * FROM [dbo].[informe_suceso]
GO

SELECT * FROM [dbo].[informe_suceso_historico]
GO

insert into [dbo].[informe_suceso] ( [id_informe],[motivo])
	values('5', 'cotos_caza')
go 


select *
from [dbo].[informe_suceso_historico]
for system_time all
go 

select *
from [dbo].[informe_suceso]
for system_time as of '2022-9-03 17:16:17.3995017'
go 

select *
from [dbo].[informe_suceso]
for system_time from '2022-9-03 17:16:17.3995017'
to '2022-03-09 17:36:05.2582622'
go 

select *
from [dbo].[informe_suceso]
for system_time contained in  ('2022-03-09 17:16:17.3995017',
 '2022-03-09 17:39:14.1274524')
go 