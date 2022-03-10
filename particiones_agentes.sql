use [agentes_forestalesprueba]
go

SELECT * FROM  [dbo].[agente]
GO

-- CREATE FILEGROUPS
ALTER DATABASE [agentes_forestalesprueba] ADD FILEGROUP [FG_Archivo] 
GO 
ALTER DATABASE [agentes_forestalesprueba] ADD FILEGROUP [FG_2018] 
GO 
ALTER DATABASE [agentes_forestalesprueba] ADD FILEGROUP [FG_2019] 
GO 
ALTER DATABASE [agentes_forestalesprueba] ADD FILEGROUP [FG_2020]
GO

select * from sys.filegroups
GO

-- -- CREATE FILES

ALTER DATABASE [agentes_forestalesprueba] ADD FILE ( NAME = 'Altas_Archivo', FILENAME = 'c:\DATA\Altas_Archivo.ndf', SIZE = 5MB, MAXSIZE = 100MB, FILEGROWTH = 2MB ) TO FILEGROUP [FG_Archivo] 
GO
ALTER DATABASE [agentes_forestalesprueba] ADD FILE ( NAME = 'altas_2018', FILENAME = 'c:\DATA\altas_2018.ndf', SIZE = 5MB, MAXSIZE = 100MB, FILEGROWTH = 2MB ) TO FILEGROUP [FG_2018] 
GO
Alter DATABASE [agentes_forestalesprueba] ADD FILE ( NAME = 'altas_2019', FILENAME = 'c:\DATA\altas_2019.ndf', SIZE = 5MB, MAXSIZE = 100MB, FILEGROWTH = 2MB ) TO FILEGROUP [FG_2018] 
GO
ALTER DATABASE [agentes_forestalesprueba] ADD FILE ( NAME = 'altas_2020', FILENAME = 'c:\DATA\altas_2020.ndf', SIZE = 5MB, MAXSIZE = 100MB, FILEGROWTH = 2MB ) TO FILEGROUP [FG_2019] 
GO
ALTER DATABASE [agentes_forestalesprueba] ADD FILE ( NAME = 'altas_2021', FILENAME = 'c:\DATA\altas_2021.ndf', SIZE = 5MB, MAXSIZE = 100MB, FILEGROWTH = 2MB ) TO FILEGROUP [FG_2020] 
GO

DBCC SHOWFILESTATS
GO

select * from sys.filegroups
GO

select * from sys.database_files
GO

-- PARTITION FUNCTION 
-- BOUNDARIES (LIMITES)

CREATE PARTITION FUNCTION FN_altas_fecha (datetime) 
AS RANGE RIGHT   --CON RIGHT INCLUYE CON LEFT NO INCLUYE LA FECHA INDICADA
	FOR VALUES ('2018-01-01','2019-01-01')
GO

--ANTERIOR-------2016 2016 AL 2017 2017  EN ADELANTE
-- PARTITION SCHEME 

CREATE PARTITION SCHEME altas_fecha 
AS PARTITION FN_altas_fecha 
	TO (FG_Archivo,FG_2018,FG_2019,FG_2020) 
GO


   create table agente_prueba(
	[nº_agente][int] NOT NULL,
	[dni_ag] [varchar](50) NOT NULL,
	[nom] [varchar](50) NOT NULL,
	[apellido1] [varchar](10) NOT NULL,
	[apellido2] [varchar](10) NULL,
	[fecha_inicio] [datetime] NOT NULL)
	on altas_fecha
	 (fecha_inicio)
GO


-- METADATA INFORMATION

SELECT *,$Partition.FN_altas_fecha(fecha_inicio) AS Partition
FROM [dbo].[agente_prueba]
GO


select name, create_date, value from sys.partition_functions f 
inner join sys.partition_range_values rv 
on f.function_id=rv.function_id 
where f.name = 'FN_altas_fecha'
gO


--VER ANTES DE SPLIT

select p.partition_number, p.rows from sys.partitions p 
inner join sys.tables t 
on p.object_id=t.object_id and t.name = 'agente_prueba'
GO

DECLARE @TableName NVARCHAR(200) = N'agente_prueba' 
SELECT SCHEMA_NAME(o.schema_id) + '.' + OBJECT_NAME(i.object_id) AS [object] , p.partition_number AS [p#] , fg.name AS [filegroup] , p.rows , au.total_pages AS pages , CASE boundary_value_on_right WHEN 1 THEN 'less than' ELSE 'less than or equal to' END as comparison , rv.value , CONVERT (VARCHAR(6), CONVERT (INT, SUBSTRING (au.first_page, 6, 1) + SUBSTRING (au.first_page, 5, 1))) + ':' + CONVERT (VARCHAR(20), CONVERT (INT, SUBSTRING (au.first_page, 4, 1) + SUBSTRING (au.first_page, 3, 1) + SUBSTRING (au.first_page, 2, 1) + SUBSTRING (au.first_page, 1, 1))) AS first_page FROM sys.partitions p INNER JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id INNER JOIN sys.objects o
ON p.object_id = o.object_id INNER JOIN sys.system_internals_allocation_units au ON p.partition_id = au.container_id INNER JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id INNER JOIN sys.partition_functions f ON f.function_id = ps.function_id INNER JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number INNER JOIN sys.filegroups fg ON dds.data_space_id = fg.data_space_id LEFT OUTER JOIN sys.partition_range_values rv ON f.function_id = rv.function_id AND p.partition_number = rv.boundary_id WHERE i.index_id < 2 AND o.object_id = OBJECT_ID(@TableName);
GO


----inserto datos a la tabla ----copio de la que ya tengo insertada dbo.agente

SELECT *,$Partition.FN_altas_fecha(fecha_inicio) 
FROM [dbo].[agente_prueba]
GO

select p.partition_number, p.rows from sys.partitions p 
inner join sys.tables t 
on p.object_id=t.object_id and t.name = 'agente_prueba'
GO


DECLARE @TableName NVARCHAR(200) = N'agente_prueba' 
SELECT SCHEMA_NAME(o.schema_id) + '.' + OBJECT_NAME(i.object_id) AS [object] , p.partition_number AS [p#] , fg.name AS [filegroup] , p.rows , au.total_pages AS pages , CASE boundary_value_on_right WHEN 1 THEN 'less than' ELSE 'less than or equal to' END as comparison , rv.value , CONVERT (VARCHAR(6), CONVERT (INT, SUBSTRING (au.first_page, 6, 1) + SUBSTRING (au.first_page, 5, 1))) + ':' + CONVERT (VARCHAR(20), CONVERT (INT, SUBSTRING (au.first_page, 4, 1) + SUBSTRING (au.first_page, 3, 1) + SUBSTRING (au.first_page, 2, 1) + SUBSTRING (au.first_page, 1, 1))) AS first_page FROM sys.partitions p INNER JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id INNER JOIN sys.objects o
ON p.object_id = o.object_id INNER JOIN sys.system_internals_allocation_units au ON p.partition_id = au.container_id INNER JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id INNER JOIN sys.partition_functions f ON f.function_id = ps.function_id INNER JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number INNER JOIN sys.filegroups fg ON dds.data_space_id = fg.data_space_id LEFT OUTER JOIN sys.partition_range_values rv ON f.function_id = rv.function_id AND p.partition_number = rv.boundary_id WHERE i.index_id < 2 AND o.object_id = OBJECT_ID(@TableName);
GO

------operaciones -------
--split----
----aqui creo otro fichero para que no me de error el split ya que al inicio no añadi el filegroup 2020

ALTER DATABASE [agentes_forestalesprueba] ADD FILE ( NAME = 'altas_2021', FILENAME = 'c:\DATA\altas_2021.ndf', SIZE = 5MB, MAXSIZE = 100MB, FILEGROWTH = 2MB ) TO FILEGROUP [FG_2020] 
GO

ALTER PARTITION FUNCTION FN_altas_fecha() 
	SPLIT RANGE ('2017-01-01');  -- pongo donde quiero partir 
GO

SELECT *,$Partition.FN_altas_fecha(fecha_inicio) as PARTITION
FROM [dbo].[agente_prueba]

DECLARE @TableName NVARCHAR(200) = N'agente_prueba' 
SELECT SCHEMA_NAME(o.schema_id) + '.' + OBJECT_NAME(i.object_id) AS [object] , p.partition_number AS [p#] , fg.name AS [filegroup] , p.rows , au.total_pages AS pages , CASE boundary_value_on_right WHEN 1 THEN 'less than' ELSE 'less than or equal to' END as comparison , rv.value , CONVERT (VARCHAR(6), CONVERT (INT, SUBSTRING (au.first_page, 6, 1) + SUBSTRING (au.first_page, 5, 1))) + ':' + CONVERT (VARCHAR(20), CONVERT (INT, SUBSTRING (au.first_page, 4, 1) + SUBSTRING (au.first_page, 3, 1) + SUBSTRING (au.first_page, 2, 1) + SUBSTRING (au.first_page, 1, 1))) AS first_page FROM sys.partitions p INNER JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id INNER JOIN sys.objects o
ON p.object_id = o.object_id INNER JOIN sys.system_internals_allocation_units au ON p.partition_id = au.container_id INNER JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id INNER JOIN sys.partition_functions f ON f.function_id = ps.function_id INNER JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number INNER JOIN sys.filegroups fg ON dds.data_space_id = fg.data_space_id LEFT OUTER JOIN sys.partition_range_values rv ON f.function_id = rv.function_id AND p.partition_number = rv.boundary_id WHERE i.index_id < 2 AND o.object_id = OBJECT_ID(@TableName);
GO

-- MERGE   HAGO UNA FUSIÓN

ALTER PARTITION FUNCTION FN_Altas_Fecha ()
 MERGE RANGE ('2017-01-01'); 
 GO

 SELECT *,$Partition.FN_altas_fecha(fecha_inicio) as PARTITION
FROM [dbo].[agente_prueba]


DECLARE @TableName NVARCHAR(200) = N'agente_prueba' 
SELECT SCHEMA_NAME(o.schema_id) + '.' + OBJECT_NAME(i.object_id) AS [object] , p.partition_number AS [p#] , fg.name AS [filegroup] , p.rows , au.total_pages AS pages , CASE boundary_value_on_right WHEN 1 THEN 'less than' ELSE 'less than or equal to' END as comparison , rv.value , CONVERT (VARCHAR(6), CONVERT (INT, SUBSTRING (au.first_page, 6, 1) + SUBSTRING (au.first_page, 5, 1))) + ':' + CONVERT (VARCHAR(20), CONVERT (INT, SUBSTRING (au.first_page, 4, 1) + SUBSTRING (au.first_page, 3, 1) + SUBSTRING (au.first_page, 2, 1) + SUBSTRING (au.first_page, 1, 1))) AS first_page FROM sys.partitions p INNER JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id INNER JOIN sys.objects o
ON p.object_id = o.object_id INNER JOIN sys.system_internals_allocation_units au ON p.partition_id = au.container_id INNER JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id INNER JOIN sys.partition_functions f ON f.function_id = ps.function_id INNER JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number INNER JOIN sys.filegroups fg ON dds.data_space_id = fg.data_space_id LEFT OUTER JOIN sys.partition_range_values rv ON f.function_id = rv.function_id AND p.partition_number = rv.boundary_id WHERE i.index_id < 2 AND o.object_id = OBJECT_ID(@TableName);
GO

-- Example SWITCH   CAMBIAR EL CONTENIDO QUE TIENES EN UNA PARTICIÓN PARA OTRA PARTICIÓON 
---hago este cambio basandome en el error del principio cuando añado archivo al filegroup

USE master
GO

ALTER DATABASE [agentes_forestalesprueba] ADD FILEGROUP [FG_2021]
GO

ALTER DATABASE [agentes_forestalesprueba] ADD FILE ( NAME = 'altas_2021', FILENAME = 'c:\DATA\altas_2021.ndf', SIZE = 5MB, MAXSIZE = 100MB, FILEGROWTH = 2MB ) TO FILEGROUP [FG_2021] 
GO

ALTER DATABASE [agentes_forestalesprueba] REMOVE FILE altas_2021
go

ALTER DATABASE [agentes_forestalesprueba] REMOVE FILEGROUP FG_2021
GO

select * from sys.filegroups
GO

select * from sys.database_files
GO 

-- SWITCH 

SELECT *,$Partition.FN_altas_fecha(fecha_inicio) as PARTITION
FROM [dbo].[agente_prueba]
go


DECLARE @TableName NVARCHAR(200) = N'agente_prueba' 
SELECT SCHEMA_NAME(o.schema_id) + '.' + OBJECT_NAME(i.object_id) AS [object] , p.partition_number AS [p#] , fg.name AS [filegroup] , p.rows , au.total_pages AS pages , CASE boundary_value_on_right WHEN 1 THEN 'less than' ELSE 'less than or equal to' END as comparison , rv.value , CONVERT (VARCHAR(6), CONVERT (INT, SUBSTRING (au.first_page, 6, 1) + SUBSTRING (au.first_page, 5, 1))) + ':' + CONVERT (VARCHAR(20), CONVERT (INT, SUBSTRING (au.first_page, 4, 1) + SUBSTRING (au.first_page, 3, 1) + SUBSTRING (au.first_page, 2, 1) + SUBSTRING (au.first_page, 1, 1))) AS first_page FROM sys.partitions p INNER JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id INNER JOIN sys.objects o
ON p.object_id = o.object_id INNER JOIN sys.system_internals_allocation_units au ON p.partition_id = au.container_id INNER JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id INNER JOIN sys.partition_functions f ON f.function_id = ps.function_id INNER JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number INNER JOIN sys.filegroups fg ON dds.data_space_id = fg.data_space_id LEFT OUTER JOIN sys.partition_range_values rv ON f.function_id = rv.function_id AND p.partition_number = rv.boundary_id WHERE i.index_id < 2 AND o.object_id = OBJECT_ID(@TableName);
GO



    create table archivoag_prueba(
	[nº_agente][int] NOT NULL,
	[dni_ag] [varchar](50) NOT NULL,
	[nom] [varchar](50) NOT NULL,
	[apellido1] [varchar](10) NOT NULL,
	[apellido2] [varchar](10) NULL,
	[fecha_inicio] [datetime] NOT NULL)
	on FG_Archivo
go 



ALTER TABLE [dbo].[agente_prueba]
	SWITCH Partition 1 to [dbo].[archivoag_prueba]
go


select * from  [dbo].[archivoag_prueba]
go

select * from  [dbo].[agente_prueba]
go 



DECLARE @TableName NVARCHAR(200) = N'agente_prueba' 
SELECT SCHEMA_NAME(o.schema_id) + '.' + OBJECT_NAME(i.object_id) AS [object] , p.partition_number AS [p#] , fg.name AS [filegroup] , p.rows , au.total_pages AS pages , CASE boundary_value_on_right WHEN 1 THEN 'less than' ELSE 'less than or equal to' END as comparison , rv.value , CONVERT (VARCHAR(6), CONVERT (INT, SUBSTRING (au.first_page, 6, 1) + SUBSTRING (au.first_page, 5, 1))) + ':' + CONVERT (VARCHAR(20), CONVERT (INT, SUBSTRING (au.first_page, 4, 1) + SUBSTRING (au.first_page, 3, 1) + SUBSTRING (au.first_page, 2, 1) + SUBSTRING (au.first_page, 1, 1))) AS first_page FROM sys.partitions p INNER JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id INNER JOIN sys.objects o
ON p.object_id = o.object_id INNER JOIN sys.system_internals_allocation_units au ON p.partition_id = au.container_id INNER JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id INNER JOIN sys.partition_functions f ON f.function_id = ps.function_id INNER JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number INNER JOIN sys.filegroups fg ON dds.data_space_id = fg.data_space_id LEFT OUTER JOIN sys.partition_range_values rv ON f.function_id = rv.function_id AND p.partition_number = rv.boundary_id WHERE i.index_id < 2 AND o.object_id = OBJECT_ID(@TableName);
GO

-- TRUNCATE es para cargarte una partición

TRUNCATE TABLE  [dbo].[agente_prueba]
	WITH (PARTITIONS (3));
go

select * from [dbo].[agente_prueba]
GO

DECLARE @TableName NVARCHAR(200) = N'agente_prueba' 
SELECT SCHEMA_NAME(o.schema_id) + '.' + OBJECT_NAME(i.object_id) AS [object] , p.partition_number AS [p#] , fg.name AS [filegroup] , p.rows , au.total_pages AS pages , CASE boundary_value_on_right WHEN 1 THEN 'less than' ELSE 'less than or equal to' END as comparison , rv.value , CONVERT (VARCHAR(6), CONVERT (INT, SUBSTRING (au.first_page, 6, 1) + SUBSTRING (au.first_page, 5, 1))) + ':' + CONVERT (VARCHAR(20), CONVERT (INT, SUBSTRING (au.first_page, 4, 1) + SUBSTRING (au.first_page, 3, 1) + SUBSTRING (au.first_page, 2, 1) + SUBSTRING (au.first_page, 1, 1))) AS first_page FROM sys.partitions p INNER JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id INNER JOIN sys.objects o
ON p.object_id = o.object_id INNER JOIN sys.system_internals_allocation_units au ON p.partition_id = au.container_id INNER JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id INNER JOIN sys.partition_functions f ON f.function_id = ps.function_id INNER JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number INNER JOIN sys.filegroups fg ON dds.data_space_id = fg.data_space_id LEFT OUTER JOIN sys.partition_range_values rv ON f.function_id = rv.function_id AND p.partition_number = rv.boundary_id WHERE i.index_id < 2 AND o.object_id = OBJECT_ID(@TableName);
GO
