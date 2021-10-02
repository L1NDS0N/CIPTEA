-- ArquivosCarteiraPTEA definition

CREATE TABLE ArquivosCarteiraPTEA (
	IDCarteira INTEGER,
	FotoStream BLOB,
	DocStream BLOB,
	IfNoneMatch VARCHAR
, hasDoc boolean);


-- "Temp" definition

CREATE TABLE "Temp" (
	id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT
, FotoRostoPath VARCHAR(254), LaudoMedicoPath VARCHAR(254));


-- Usuario definition

CREATE TABLE Usuario (
	id INTEGER,
	Nome VARCHAR,
	Token VARCHAR,
	StayConected BOOLEAN DEFAULT false NOT NULL,
	TokenCreatedAt INTEGER,
	TokenExpires INTEGER,
	CONSTRAINT Usuario_PK PRIMARY KEY (id)
);