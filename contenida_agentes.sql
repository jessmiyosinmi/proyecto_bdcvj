USE MASTER
GO

-- A UNO SE ACTIVAN OPCIONES AVANZADAS
EXEC SP_CONFIGURE 'show advanced options', 1
GO
-- Actualizamos el valor
RECONFIGURE
GO


--ACTIVAMOS LA CARACTERISTICA
EXEC SP_CONFIGURE 'contained database authentication', 1
GO
-- Actualizamos de nuevo
RECONFIGURE
GO

---
-- Hasta aqui preparamos el entorno para lo que vamos a ejecutar
---
DROP DATABASE IF EXISTS Contenida_cvj
GO
CREATE DATABASE Contenida_cvj
CONTAINMENT=PARTIAL
GO

--Una vez creada la activamos
USE Contenida_cvj
GO

-- Creo usuario juan, asocio esquema dbo
DROP USER IF EXISTS juan
GO
CREATE USER juan 
	WITH PASSWORD='abcd1234.',
	DEFAULT_SCHEMA=[dbo]
go
-- Añadimos el usuario juan el rol dbo_owner
-- Deprecated
EXEC sp_addrolemember 'db_owner', 'juan'
GO
-- New
ALTER ROLE db_owner
ADD MEMBER juan
GO

-- Intento conectarme juan abcd1234.
-- ERROR
--TITLE: Connect to Server
--------------------------------
--Cannot connect to DESKTOP-7CRURLP.
--------------------------------
--ADDITIONAL INFORMATION:
--Login failed for user 'juan'. (Microsoft SQL Server, Error: 18456)
--For help, click: http://go.microsoft.com/fwlink?ProdName=Microsoft%20SQL%20Server&EvtSrc=MSSQLServer&EvtID=18456&LinkId=20476
------------------------------

-- Damos permiso grant para que juan se pueda conectar
GRANT CONNECT TO JUAN
GO

-- Intento conectarme juan abcd1234.
-- Login failed for user 'juan'. (Microsoft SQL Server, Error: 18456)
-- Necesitamos "Aditional Connection Parameters" DATABASE=Contenida

---------------------------------
-- Tiene que estar con autenticacion mixta
-- Nos conectamos como Juan
-- Vamos a pestaña "Aditional Connection Parameters" DATABASE=Contenida

-- Entramos. Mirar GUI

-- Desde Juan pruebo a crear una Tabla


CREATE TABLE [dbo].[TablaContenida](
	[Codigo] [nchar](10) NULL,
	[Nombre] [nchar](10) NULL
) ON [PRIMARY]
GO

-- Commands completed successfully.
