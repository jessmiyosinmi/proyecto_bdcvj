USE MASTER 
GO

DROP DATABASE IF EXISTS[agente_forestal]
GO

CREATE DATABASE [agente_forestal]
GO
USE [agente_forestal]
GO
CREATE TABLE administración (
    nombre_admin varchar(50) NOT NULL,
    direccion    varchar(50) NOT NULL,
    cp           NUMERIC(5) NOT NULL,
    localidad    varchar(20) NOT NULL,
    tf           NUMERIC(15) NOT NULL
);

ALTER TABLE administración ADD CONSTRAINT administración_pk PRIMARY KEY ( nombre_admin );

CREATE TABLE ag_funcion (
    f_policial_id_materia NUMERIC(8) NOT NULL,
    id_id_n_ag            NUMERIC(6) NOT NULL
);

ALTER TABLE ag_funcion ADD CONSTRAINT ag_funcion_pk PRIMARY KEY ( f_policial_id_materia,
                                                                  id_id_n_ag );

CREATE TABLE ag_función (
    f_tecnica_id_ocupacion NUMERIC(8) NOT NULL,
    id_id_n_ag             NUMERIC(6) NOT NULL
);

ALTER TABLE ag_función ADD CONSTRAINT ag_función_pk PRIMARY KEY ( f_tecnica_id_ocupacion,
                                                                  id_id_n_ag );

CREATE TABLE ag_uniforme (
    agente_dni_ag      NUMERIC(12) NOT NULL,
    uniforme_id_prenda varchar(2) NOT NULL
);

ALTER TABLE ag_uniforme ADD CONSTRAINT ag_uniforme_pk PRIMARY KEY ( agente_dni_ag,
                                                                    uniforme_id_prenda );

CREATE TABLE agente (
    dni_ag            NUMERIC(12) NOT NULL,
    nom               varchar(12) NOT NULL,
    apellido1         varchar(10) NOT NULL,
    apellido2         varchar(10),
    fecha_inicio      DATE NOT NULL,
    divisas_id_divisa varchar(1) NOT NULL,
    id_id_n_ag        NUMERIC(6) NOT NULL
);

ALTER TABLE agente ADD CONSTRAINT agente_pk PRIMARY KEY ( dni_ag );

CREATE TABLE ccaa (
    id_ccaa                     NUMERIC(2) NOT NULL,
    comunidad                   varchar(15) NOT NULL,
    nomenclatura                varchar(20) NOT NULL,
    web                         varchar(50),
    total_agentes               NUMERIC(4) NOT NULL,
    arma                        VARCHAR(2) NOT NULL,
    administración_nombre_admin varchar(50) NOT NULL
);


ALTER TABLE ccaa ADD CONSTRAINT ccaa_pk PRIMARY KEY ( id_ccaa );

CREATE TABLE ccaa_ag (
    ccaa_id_ccaa  NUMERIC(2) NOT NULL,
    agente_dni_ag NUMERIC(12) NOT NULL
);

ALTER TABLE ccaa_ag ADD CONSTRAINT ccaa_ag_pk PRIMARY KEY ( ccaa_id_ccaa,
                                                            agente_dni_ag );

CREATE TABLE ccaa_v (
    ccaa_id_ccaa                 NUMERIC(2) NOT NULL,
    "vehiculo-oficial_matricula" varchar(10) NOT NULL
);

ALTER TABLE ccaa_v ADD CONSTRAINT ccaa_v_pk PRIMARY KEY ( ccaa_id_ccaa,
                                                          "vehiculo-oficial_matricula" );

CREATE TABLE divisas (
    id_divisa   varchar(1) NOT NULL,
    tipo_agente varchar(10) NOT NULL,
    n_hojas     NUMERIC(1)
);

ALTER TABLE divisas ADD CONSTRAINT divisas_pk PRIMARY KEY ( id_divisa );

CREATE TABLE emblema (
    id_n_ag     NUMERIC(6) NOT NULL,
    imagen      VARBINARY(MAX),
    descripcion varchar(1000) NOT NULL
);

ALTER TABLE emblema ADD CONSTRAINT emblema_pk PRIMARY KEY ( id_n_ag );

CREATE TABLE f_policial (
    id_materia NUMERIC(8) NOT NULL,
    campo      varchar(50) NOT NULL
);

ALTER TABLE f_policial ADD CONSTRAINT f_policial_pk PRIMARY KEY ( id_materia );

CREATE TABLE f_tecnica (
    id_ocupacion NUMERIC(8) NOT NULL,
    descripcion  varchar(100) NOT NULL
);

ALTER TABLE f_tecnica ADD CONSTRAINT f_tecnica_pk PRIMARY KEY ( id_ocupacion );

CREATE TABLE id (
    id_n_ag NUMERIC(6) NOT NULL,
    id_feha DATE NOT NULL
);


ALTER TABLE id ADD CONSTRAINT id_pk PRIMARY KEY ( id_n_ag );

CREATE TABLE tarjeta_identificativa (
    id_n_ag   NUMERIC(6) NOT NULL,
    categoria varchar(20) NOT NULL
);

ALTER TABLE tarjeta_identificativa ADD CONSTRAINT tarjeta_identificativa_pk PRIMARY KEY ( id_n_ag );

CREATE TABLE uniforme (
    id_prenda        varchar(2) NOT NULL,
    prenda           varchar(20) NOT NULL,
    n_inicial_prenda NUMERIC(1) NOT NULL,
    fecha_entrega    DATE NOT NULL
);

ALTER TABLE uniforme ADD CONSTRAINT uniforme_pk PRIMARY KEY ( id_prenda );

CREATE TABLE "vehiculo-oficial" (
    matricula varchar(10) NOT NULL,
    marca     varchar(20) NOT NULL,
    modelo    varchar(20) NOT NULL
);

ALTER TABLE "vehiculo-oficial" ADD CONSTRAINT "vehiculo-oficial_PK" PRIMARY KEY ( matricula );

ALTER TABLE ag_funcion
    ADD CONSTRAINT ag_funcion_f_policial_fk FOREIGN KEY ( f_policial_id_materia )
        REFERENCES f_policial ( id_materia );

ALTER TABLE ag_función
    ADD CONSTRAINT ag_función_f_tecnica_fk FOREIGN KEY ( f_tecnica_id_ocupacion )
        REFERENCES f_tecnica ( id_ocupacion );

ALTER TABLE ag_funcion
    ADD CONSTRAINT ag_funcion_id_fk FOREIGN KEY ( id_id_n_ag )
        REFERENCES id ( id_n_ag );

ALTER TABLE ag_función
    ADD CONSTRAINT ag_función_id_fk FOREIGN KEY ( id_id_n_ag )
        REFERENCES id ( id_n_ag );

ALTER TABLE ag_uniforme
    ADD CONSTRAINT ag_uniforme_agente_fk FOREIGN KEY ( agente_dni_ag )
        REFERENCES agente ( dni_ag );

ALTER TABLE ag_uniforme
    ADD CONSTRAINT ag_uniforme_uniforme_fk FOREIGN KEY ( uniforme_id_prenda )
        REFERENCES uniforme ( id_prenda );

ALTER TABLE agente
    ADD CONSTRAINT agente_divisas_fk FOREIGN KEY ( divisas_id_divisa )
        REFERENCES divisas ( id_divisa );

ALTER TABLE agente
    ADD CONSTRAINT agente_id_fk FOREIGN KEY ( id_id_n_ag )
        REFERENCES id ( id_n_ag );

ALTER TABLE ccaa
    ADD CONSTRAINT ccaa_administración_fk FOREIGN KEY ( administración_nombre_admin )
        REFERENCES administración ( nombre_admin );

ALTER TABLE ccaa_ag
    ADD CONSTRAINT ccaa_ag_agente_fk FOREIGN KEY ( agente_dni_ag )
        REFERENCES agente ( dni_ag );

ALTER TABLE ccaa_ag
    ADD CONSTRAINT ccaa_ag_ccaa_fk FOREIGN KEY ( ccaa_id_ccaa )
        REFERENCES ccaa ( id_ccaa );

ALTER TABLE ccaa_v
    ADD CONSTRAINT ccaa_v_ccaa_fk FOREIGN KEY ( ccaa_id_ccaa )
        REFERENCES ccaa ( id_ccaa );

ALTER TABLE ccaa_v
    ADD CONSTRAINT "ccaa_v_vehiculo-oficial_FK" FOREIGN KEY ( "vehiculo-oficial_matricula" )
        REFERENCES "vehiculo-oficial" ( matricula );

ALTER TABLE emblema
    ADD CONSTRAINT emblema_id_fk FOREIGN KEY ( id_n_ag )
        REFERENCES id ( id_n_ag );

ALTER TABLE tarjeta_identificativa
    ADD CONSTRAINT tarjeta_identificativa_id_fk FOREIGN KEY ( id_n_ag )
        REFERENCES id ( id_n_ag );

--CREATE TRIGGER arc_supertipo_emblema 
--BEFORE INSERT OF id_n_ag ON emblema
--    FOR EACH ROW
--DECLARE
--    d NUMERIC(6);
--BEGIN
--    SELECT
--        a.id_n_ag
--    INTO d
--    FROM
--        id a
--    WHERE
--        a.id_n_ag = :new.id_n_ag;

--    IF ( d IS NULL OR d <> 0 ) THEN
--        raise_application_error(-20223,
--                               'FK emblema_id_FK in Table emblema violates Arc constraint on Table id - discriminator column id_n_ag doesn''t have value 0');
--    END IF;

--EXCEPTION
--    WHEN no_data_found THEN
--        NULL;
--    WHEN OTHERS THEN
--        RAISE;
--END;
--/

--CREATE OR REPLACE TRIGGER arc_sup_tarjeta_identificativa BEFORE
--    INSERT OR UPDATE OF id_n_ag ON tarjeta_identificativa
--    FOR EACH ROW
--DECLARE
--    d NUMERIC(6);
--BEGIN
--    SELECT
--        a.id_n_ag
--    INTO d
--    FROM
--        id a
--    WHERE
--        a.id_n_ag = :new.id_n_ag;

--    IF ( d IS NULL OR d <> 0 ) THEN
--        raise_application_error(-20223,
--                               'FK tarjeta_identificativa_id_FK in Table tarjeta_identificativa violates Arc constraint on Table id - discriminator column id_n_ag doesn''t have value 0');
--    END IF;

--EXCEPTION
--    WHEN no_data_found THEN
--        NULL;
--    WHEN OTHERS THEN
--        RAISE;
--END;
--/