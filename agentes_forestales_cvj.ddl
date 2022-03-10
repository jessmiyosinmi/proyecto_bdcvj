SQL Server 2012



CREATE TABLE administración 
    (
     id_ad INTEGER NOT NULL , 
     nombre_admin VARCHAR (250) NOT NULL , 
     direccion VARCHAR (250) NOT NULL , 
     cp INTEGER NOT NULL , 
     localidad VARCHAR (20) NOT NULL , 
     tf INTEGER NOT NULL 
    )
GO

ALTER TABLE administración ADD CONSTRAINT administración_PK PRIMARY KEY CLUSTERED (id_ad)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE ag_uniforme 
    (
     agente_nº_agente INTEGER NOT NULL , 
     uniforme_id_prenda INTEGER NOT NULL 
    )
GO

ALTER TABLE ag_uniforme ADD CONSTRAINT ag_uniforme_PK PRIMARY KEY CLUSTERED (agente_nº_agente, uniforme_id_prenda)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE agente 
    (
     nº_agente INTEGER NOT NULL , 
     dni_ag VARCHAR (50) NOT NULL , 
     nom VARCHAR (50) NOT NULL , 
     apellido1 VARCHAR (10) NOT NULL , 
     apellido2 VARCHAR (10) , 
     fecha_inicio DATETIME NOT NULL 
    )
GO

ALTER TABLE agente ADD CONSTRAINT agente_PK PRIMARY KEY CLUSTERED (nº_agente)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE ccaa 
    (
     id_ccaa INTEGER NOT NULL , 
     comunidad VARCHAR (50) NOT NULL , 
     nomenclatura VARCHAR (50) NOT NULL , 
     web VARCHAR (50) , 
     total_agentes INTEGER NOT NULL , 
     arma VARCHAR NOT NULL , 
     administración_id_ad INTEGER NOT NULL 
    )
GO 



EXEC sp_addextendedproperty 'MS_Description' , 'bit-valor si o no true o false' , 'USER' , 'dbo' , 'TABLE' , 'ccaa' , 'COLUMN' , 'arma' 
GO

ALTER TABLE ccaa ADD CONSTRAINT ccaa_PK PRIMARY KEY CLUSTERED (id_ccaa)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE ccaa_ag 
    (
     ccaa_id_ccaa INTEGER NOT NULL , 
     agente_nº_agente INTEGER NOT NULL 
    )
GO

ALTER TABLE ccaa_ag ADD CONSTRAINT ccaa_ag_PK PRIMARY KEY CLUSTERED (ccaa_id_ccaa, agente_nº_agente)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE ccaa_v 
    (
     ccaa_id_ccaa INTEGER NOT NULL , 
     "vehiculo-oficial_matricula" VARCHAR (10) NOT NULL 
    )
GO

ALTER TABLE ccaa_v ADD CONSTRAINT ccaa_v_PK PRIMARY KEY CLUSTERED (ccaa_id_ccaa, "vehiculo-oficial_matricula")
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE f_policial 
    (
     id_materia INTEGER NOT NULL , 
     campo VARCHAR (250) NOT NULL 
    )
GO

ALTER TABLE f_policial ADD CONSTRAINT f_policial_PK PRIMARY KEY CLUSTERED (id_materia)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE f_tecni 
    (
     f_tecnica_id_ocupacion INTEGER NOT NULL , 
     agente_nº_agente INTEGER NOT NULL 
    )
GO

ALTER TABLE f_tecni ADD CONSTRAINT f_tecni_PK PRIMARY KEY CLUSTERED (f_tecnica_id_ocupacion, agente_nº_agente)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE f_tecnica 
    (
     id_ocupacion INTEGER NOT NULL , 
     descripcion VARCHAR (250) NOT NULL 
    )
GO

ALTER TABLE f_tecnica ADD CONSTRAINT f_tecnica_PK PRIMARY KEY CLUSTERED (id_ocupacion)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE func_poli 
    (
     f_policial_id_materia INTEGER NOT NULL , 
     agente_nº_agente INTEGER NOT NULL 
    )
GO

ALTER TABLE func_poli ADD CONSTRAINT func_poli_PK PRIMARY KEY CLUSTERED (f_policial_id_materia, agente_nº_agente)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE suceso_ag 
    (
     sucesos_sucesos_ID NUMERIC (28) NOT NULL , 
     agente_nº_agente INTEGER NOT NULL 
    )
GO

ALTER TABLE suceso_ag ADD CONSTRAINT suceso_ag_PK PRIMARY KEY CLUSTERED (sucesos_sucesos_ID, agente_nº_agente)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE sucesos 
    (
     id_suceso INTEGER , 
     fecha DATE NOT NULL , 
     motivo VARCHAR (250) NOT NULL , 
     sucesos_ID NUMERIC (28) NOT NULL IDENTITY NOT FOR REPLICATION 
    )
GO

ALTER TABLE sucesos ADD CONSTRAINT sucesos_PK PRIMARY KEY CLUSTERED (sucesos_ID)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE uniforme 
    (
     id_prenda INTEGER NOT NULL , 
     prenda VARCHAR (50) NOT NULL , 
     num_prenda INTEGER NOT NULL , 
     fecha_entrega DATE NOT NULL 
    )
GO

ALTER TABLE uniforme ADD CONSTRAINT uniforme_PK PRIMARY KEY CLUSTERED (id_prenda)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE "vehiculo-oficial" 
    (
     matricula VARCHAR (10) NOT NULL , 
     marca VARCHAR (20) NOT NULL , 
     modelo VARCHAR (20) NOT NULL 
    )
GO

ALTER TABLE "vehiculo-oficial" ADD CONSTRAINT "vehiculo-oficial_PK" PRIMARY KEY CLUSTERED (matricula)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

ALTER TABLE ag_uniforme 
    ADD CONSTRAINT ag_uniforme_agente_FK FOREIGN KEY 
    ( 
     agente_nº_agente
    ) 
    REFERENCES agente 
    ( 
     nº_agente 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE ag_uniforme 
    ADD CONSTRAINT ag_uniforme_uniforme_FK FOREIGN KEY 
    ( 
     uniforme_id_prenda
    ) 
    REFERENCES uniforme 
    ( 
     id_prenda 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE ccaa 
    ADD CONSTRAINT ccaa_administración_FK FOREIGN KEY 
    ( 
     administración_id_ad
    ) 
    REFERENCES administración 
    ( 
     id_ad 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE ccaa_ag 
    ADD CONSTRAINT ccaa_ag_agente_FK FOREIGN KEY 
    ( 
     agente_nº_agente
    ) 
    REFERENCES agente 
    ( 
     nº_agente 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE ccaa_ag 
    ADD CONSTRAINT ccaa_ag_ccaa_FK FOREIGN KEY 
    ( 
     ccaa_id_ccaa
    ) 
    REFERENCES ccaa 
    ( 
     id_ccaa 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE ccaa_v 
    ADD CONSTRAINT ccaa_v_ccaa_FK FOREIGN KEY 
    ( 
     ccaa_id_ccaa
    ) 
    REFERENCES ccaa 
    ( 
     id_ccaa 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE ccaa_v 
    ADD CONSTRAINT "ccaa_v_vehiculo-oficial_FK" FOREIGN KEY 
    ( 
     "vehiculo-oficial_matricula"
    ) 
    REFERENCES ""vehiculo-oficial"" 
    ( 
     matricula 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE f_tecni 
    ADD CONSTRAINT f_tecni_agente_FK FOREIGN KEY 
    ( 
     agente_nº_agente
    ) 
    REFERENCES agente 
    ( 
     nº_agente 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE f_tecni 
    ADD CONSTRAINT f_tecni_f_tecnica_FK FOREIGN KEY 
    ( 
     f_tecnica_id_ocupacion
    ) 
    REFERENCES f_tecnica 
    ( 
     id_ocupacion 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE func_poli 
    ADD CONSTRAINT func_poli_agente_FK FOREIGN KEY 
    ( 
     agente_nº_agente
    ) 
    REFERENCES agente 
    ( 
     nº_agente 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE func_poli 
    ADD CONSTRAINT func_poli_f_policial_FK FOREIGN KEY 
    ( 
     f_policial_id_materia
    ) 
    REFERENCES f_policial 
    ( 
     id_materia 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE suceso_ag 
    ADD CONSTRAINT suceso_ag_agente_FK FOREIGN KEY 
    ( 
     agente_nº_agente
    ) 
    REFERENCES agente 
    ( 
     nº_agente 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE suceso_ag 
    ADD CONSTRAINT suceso_ag_sucesos_FK FOREIGN KEY 
    ( 
     sucesos_sucesos_ID
    ) 
    REFERENCES sucesos 
    ( 
     sucesos_ID 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO



-- Informe de Resumen de Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                            14
-- CREATE INDEX                             0
-- ALTER TABLE                             27
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE DATABASE                          0
-- CREATE DEFAULT                           0
-- CREATE INDEX ON VIEW                     0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE ROLE                              0
-- CREATE RULE                              0
-- CREATE SCHEMA                            0
-- CREATE SEQUENCE                          0
-- CREATE PARTITION FUNCTION                0
-- CREATE PARTITION SCHEME                  0
-- 
-- DROP DATABASE                            0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0
