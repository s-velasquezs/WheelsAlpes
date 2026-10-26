CREATE TABLE Estudiantes (
    documento_id            VARCHAR2(10 CHAR) NOT NULL,
    nombre                  VARCHAR2(15 CHAR) NOT NULL,
    apellido                VARCHAR2(20 CHAR) NOT NULL,
    programa                VARCHAR2(20 CHAR) NOT NULL,
    universidad             VARCHAR2(25 CHAR) NOT NULL,
    correo_institucional    VARCHAR2(30 CHAR) NOT NULL,
    celular                 VARCHAR2(10 CHAR) NOT NULL,
    
    CONSTRAINT pk_estudiantes PRIMARY KEY (documento_id)
);


CREATE TABLE Conductor (
    documento_id VARCHAR2(10 CHAR) NOT NULL,
    CONSTRAINT pk_conductor PRIMARY KEY (documento_id),
    CONSTRAINT fk_conductor_estudiante FOREIGN KEY (documento_id)
        REFERENCES Estudiantes(documento_id)
);



CREATE TABLE Vehiculo (
    placa VARCHAR2(6 CHAR) NOT NULL,
    marca VARCHAR2(20 CHAR) NOT NULL,
    modelo VARCHAR2(20 CHAR) NOT NULL,
    anio NUMBER(4) NOT NULL,
    color VARCHAR2(10 CHAR) NOT NULL,
    cupos_disponibles NUMBER(2) NOT NULL, 
    id_conductor VARCHAR2(10 CHAR) NOT NULL,
    
    CONSTRAINT pk_vehiculo PRIMARY KEY (placa),
    
    CONSTRAINT fk_vehiculo_conductor FOREIGN KEY (id_conductor)
        REFERENCES Conductor (documento_id)

);


CREATE TABLE Viaje (
    id_viaje VARCHAR2 (5 CHAR) NOT NULL,
    fecha_hora_salida DATE NOT NULL,
    punto_origen VARCHAR2 (20 CHAR) NOT NULL,
    cupos_disponibles_viaje NUMBER(2) NOT NULL,
    costo NUMBER (6) NOT NULL,
    estado VARCHAR2 (15 CHAR) NOT NULL,
    ruta_general VARCHAR2 (20 CHAR) NOT NULL,
    placa VARCHAR2 (6 CHAR) NOT NULL,
    id_conductor VARCHAR2 (10 CHAR) NOT NULL,
    
    CONSTRAINT pk_viaje PRIMARY KEY (id_viaje),
    
    CONSTRAINT fk_placa_viaje FOREIGN KEY (placa)
        REFERENCES Vehiculo (placa),

    CONSTRAINT fk_viaje_conductor FOREIGN KEY (id_conductor)
        REFERENCES Conductor (documento_id),
        
    CONSTRAINT chk_estado_viaje CHECK (estado IN ('PROGRAMADO','EN CURSO','COMPLETADO','CANCELADO'))
    
    
);


CREATE TABLE Parada (
    id_parada VARCHAR2(5 CHAR) NOT NULL,
    parada VARCHAR2 (20 CHAR) NOT NULL,
    
    CONSTRAINT pk_parada PRIMARY KEY (id_parada)
    
);


CREATE TABLE Solicitud (
    id_solicitud VARCHAR2 (5 CHAR) NOT NULL,
    estado_solicitud VARCHAR2 (15 CHAR) NOT NULL,
    id_pasajero VARCHAR2 (10 CHAR) NOT NULL,
    id_viaje VARCHAR2 (5 CHAR) NOT NULL,
    punto_recogida VARCHAR2 (20 CHAR) NOT NULL,
    
    CONSTRAINT pk_solicitud PRIMARY KEY (id_solicitud),
    
    CONSTRAINT fk_solicitud_estudiante FOREIGN KEY (id_pasajero)
        REFERENCES Estudiantes (documento_id),
    
    CONSTRAINT fk_solicitud_viaje FOREIGN KEY (id_viaje) 
        REFERENCES Viaje (id_viaje),
        
    CONSTRAINT chk_estado_solicitud CHECK (estado_solicitud IN ('PENDIENTE', 'ACEPTADA', 'RECHAZADA'))
);

CREATE TABLE Viaje_parada (
    id_viaje VARCHAR2 (5 CHAR) NOT NULL,
    id_parada VARCHAR2 (5 CHAR) NOT NULL, 
    
    CONSTRAINT pk_viaje_parada PRIMARY KEY (id_viaje, id_parada),
    
    CONSTRAINT fk_viaje_parada_viaje FOREIGN KEY (id_viaje)
        REFERENCES Viaje (id_viaje),

    CONSTRAINT fk_viaje_parada_parada FOREIGN KEY (id_parada)
        REFERENCES Parada (id_parada)
        
);




CREATE SEQUENCE seq_viaje
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

CREATE OR REPLACE TRIGGER trg_viaje_id
BEFORE INSERT ON Viaje
FOR EACH ROW
WHEN (NEW.id_viaje IS NULL)
BEGIN
    :NEW.id_viaje := 'V' || LPAD(seq_viaje.NEXTVAL, 4, '0');
END;
/

CREATE SEQUENCE seq_parada
    START WITH 1
    INCREMENT BY 1
    NOCACHE;
    
CREATE OR REPLACE TRIGGER trg_parada_id
BEFORE INSERT ON Parada
FOR EACH ROW
WHEN (NEW.id_parada IS NULL)
BEGIN
    :NEW.id_parada := 'P' || LPAD(seq_parada.NEXTVAL, 4, '0');
END;

CREATE SEQUENCE seq_solicitud
    START WITH 1
    INCREMENT BY 1
    NOCACHE;
    
CREATE OR REPLACE TRIGGER trg_solicitud_id
BEFORE INSERT ON Solicitud
FOR EACH ROW
WHEN (NEW.id_solicitud IS NULL)
BEGIN
    :NEW.id_solicitud := 'S' || LPAD(seq_solicitud.NEXTVAL, 4, '0');
END;


