-- ArquivosCarteiraPTEA definition

CREATE TABLE ArquivosCarteiraPTEA (
	IDCarteira INTEGER,
	FotoStream BLOB,
	DocStream BLOB,
	IfNoneMatch VARCHAR
, hasDoc boolean);


-- Usuario definition

CREATE TABLE Usuario (
	id INTEGER,
	Nome VARCHAR,
	Token VARCHAR,
	StayConected BOOLEAN DEFAULT false NOT NULL,
	TokenCreatedAt INTEGER,
	TokenExpires INTEGER, Email VARCHAR,
	CONSTRAINT Usuario_PK PRIMARY KEY (id)
);