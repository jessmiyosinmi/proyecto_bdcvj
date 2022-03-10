use master
go 
drop database
agentes_forestalesprueba

create DATABASE agentes_forestalesprueba
	ON PRIMARY ( NAME = 'AG_FORESTAL1', 
	FILENAME = 'C:\Data\AG_FORESTAL1_MDF.mdf' , 
	SIZE = 15360KB , MAXSIZE = UNLIMITED, FILEGROWTH = 0) 
	LOG ON ( NAME = 'AG_FORESTAL2', 
	FILENAME = 'C:\Data\AG_FORESTAL2_LOG.ldf' , 
	SIZE = 10176KB , MAXSIZE = 2048GB , FILEGROWTH = 10%) 
GO



 use [agentes_forestalesprueba]
 go

 
 select * from sysfilegroups
 go 


EXEC sp_configure filestream_access_level, 2
RECONFIGURE
GO



DROP TABLE IF EXISTS Imagen_emblema
GO

ALTER DATABASE  [agentes_forestalesprueba]
	ADD FILEGROUP [PRIMARY_FILESTREAM] 
	CONTAINS FILESTREAM 
GO

ALTER DATABASE [agentes_forestalesprueba]
       ADD FILE (
             NAME = 'MyDatabase_filestream',
             FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\filestream'
       )
       TO FILEGROUP [PRIMARY_FILESTREAM]
GO

use [agentes_forestalesprueba]
go 

DROP TABLE IF EXISTS Imagen_escudo
GO

CREATE TABLE Imagen_escudo (
 id UNIQUEIDENTIFIER ROWGUIDCOL NOT NULL UNIQUE,
 imageFile VARBINARY(MAX) FILESTREAM
);
GO

INSERT INTO Imagen_escudo(id, imageFile)
		SELECT NEWID(), BulkColumn
		FROM OPENROWSET(BULK 'C:\Imagen_escudo\Aragon.jpg', SINGLE_BLOB) as f;
GO
INSERT INTO Imagen_escudo(id, imageFile)
	SELECT NEWID(), BulkColumn
	FROM OPENROWSET(BULK 'C:\imagen_escudo\Castilla_LaMancha.jpg', SINGLE_BLOB) as f;
GO
INSERT INTO Imagen_escudo(id, imageFile)
	SELECT NEWID(), BulkColumn
	FROM OPENROWSET(BULK 'C:\imagen_escudo\Galicia.jpg', SINGLE_BLOB) as f;
GO


SELECT *
FROM Imagen_escudo;
GO