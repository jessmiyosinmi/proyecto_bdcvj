


DROP DATABASE IF exists  [agentes_forestalesfiletable]

GO


CREATE DATABASE [agentes_forestalesfiletable]
ON PRIMARY
(
    NAME = agentesFileTable_data,
    FILENAME = 'C:\FileTable_ag\agentesFileTable.mdf'
),
FILEGROUP FileStreamFG CONTAINS FILESTREAM
(
    NAME = agentesFileTable,
    FILENAME = 'C:\FileTable_ag\agentesFileTable_Container' 
)
LOG ON
(
    NAME = SQLFileTable_Log,
    FILENAME = 'C:\FileTable_ag\agentesFileTable_Log.ldf'
)
WITH FILESTREAM
(
    NON_TRANSACTED_ACCESS = FULL,
    DIRECTORY_NAME = 'FileTableContainer'
);
GO

use [agentes_forestalesfiletable]
go

DROP TABLE IF EXISTS informes 
GO

CREATE TABLE informes 
AS FILETABLE
WITH 
(
    FileTable_Directory = 'FileTableContainer',
    FileTable_Collate_Filename = database_default
);
GO

SELECT *
FROM informes
GO