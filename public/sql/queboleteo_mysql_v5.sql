-- QueBoleteo - DDL
-- Base de datos: queboleteo
-- -----------------------------------------------------
-- Table ARTISTA_INDIVIDUAL
-- -----------------------------------------------------
CREATE TABLE ARTISTA_INDIVIDUAL (
    IdArtista           BIGINT          NOT NULL AUTO_INCREMENT,
    NombreArtista       VARCHAR(100),
    DescripcionArtista  VARCHAR(200),
    ImagenArtista       VARCHAR(2000),
    PaisOrigenArtista   VARCHAR(50),
    EdadArtista         INTEGER,
    LenguajeArtista     VARCHAR(50),
    CONSTRAINT ARTISTA_INDIVIDUAL_PK PRIMARY KEY (IdArtista)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table GENERO
-- -----------------------------------------------------
CREATE TABLE GENERO (
    IdGenero        BIGINT      NOT NULL AUTO_INCREMENT,
    NombreGenero    VARCHAR(50),
    CONSTRAINT GENERO_PK PRIMARY KEY (IdGenero),
    CONSTRAINT GENERO_UN UNIQUE (IdGenero, NombreGenero)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table GRUPO
-- -----------------------------------------------------
CREATE TABLE GRUPO (
    IdGrupo             BIGINT          NOT NULL AUTO_INCREMENT,
    NombreGrupo         VARCHAR(100),
    DescripcionGrupo    VARCHAR(500),
    ImagenGrupo         VARCHAR(2000),
    PaisOrigenGrupo     VARCHAR(100),
    TiempoDuracion      INTEGER,
    LenguajeGrupo       VARCHAR(50),
    CONSTRAINT GRUPO_PK PRIMARY KEY (IdGrupo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table ORGANIZADOR
-- -----------------------------------------------------
CREATE TABLE ORGANIZADOR (
    NombreOrganizador   VARCHAR(100)    NOT NULL,
    CorreoOrganizador   VARCHAR(100),
    Logo                VARCHAR(2000),
    CONSTRAINT ORGANIZADOR_PK PRIMARY KEY (NombreOrganizador),
    CONSTRAINT ORGANIZADOR_UN UNIQUE (NombreOrganizador, CorreoOrganizador)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table SEDE
-- -----------------------------------------------------
CREATE TABLE SEDE (
    NombreSede          VARCHAR(100)    NOT NULL,
    Calle               VARCHAR(100),
    Carrera             VARCHAR(100),
    Ciudad              VARCHAR(50),
    TieneAccesibilidad  BOOLEAN,
    ImagenSede          VARCHAR(2000),
    ImagenSeccion       VARCHAR(2000),
    CONSTRAINT SEDE_PK PRIMARY KEY (NombreSede)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table TOUR
-- -----------------------------------------------------
CREATE TABLE TOUR (
    IdTour          BIGINT          NOT NULL AUTO_INCREMENT,
    NombreTour      VARCHAR(100),
    DescripcionTour VARCHAR(500),
    ImagenTour      VARCHAR(2000),
    FechaInicial    DATE,
    FechaFinal      DATE,
    CONSTRAINT TOUR_PK PRIMARY KEY (IdTour)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table USUARIO
-- -----------------------------------------------------
CREATE TABLE USUARIO (
    Correo                  VARCHAR(50)     NOT NULL,
    NombreUsuario           VARCHAR(50)     NOT NULL,
    Clave                   VARCHAR(255)    NOT NULL,
    DocumentoIdentidad      VARCHAR(20)     NOT NULL,
    PrimerNombre            VARCHAR(50)     NOT NULL,
    SegundoNombre           VARCHAR(50),
    PrimerApellido          VARCHAR(50)     NOT NULL,
    SegundoApellido         VARCHAR(50),
    FechaNacimiento         DATE            NOT NULL,
    Edad                    INTEGER,
    NumeroTelefono          VARCHAR(20),
    IsVerified              BOOLEAN         NOT NULL DEFAULT FALSE,
    AccountNonExpired       BOOLEAN         NOT NULL DEFAULT TRUE,
    AccountNonLocked        BOOLEAN         NOT NULL DEFAULT TRUE,
    CredentialsNonExpired   BOOLEAN         NOT NULL DEFAULT TRUE,
    Enabled                 BOOLEAN         NOT NULL DEFAULT TRUE,
    Role                    ENUM('USUARIO','ADMINISTRADOR') NOT NULL DEFAULT 'USUARIO',
    CONSTRAINT USUARIO_PK PRIMARY KEY (Correo),
    CONSTRAINT USUARIO_UN UNIQUE (Correo, NombreUsuario, DocumentoIdentidad)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table CONCIERTO
-- -----------------------------------------------------
CREATE TABLE CONCIERTO (
    IdConcierto             BIGINT          NOT NULL AUTO_INCREMENT,
    NombreConcierto         VARCHAR(50),
    DescripcionConcierto    VARCHAR(500),
    ImagenConcierto         VARCHAR(2000),
    EdadMinima              INTEGER,
    Recomendacion           VARCHAR(350),
    FechaConcierto          DATETIME,
    EstadoConcierto         VARCHAR(20),
    TOUR_IdTour             BIGINT,
    SEDE_NombreSede         VARCHAR(100)    NOT NULL,
    CONSTRAINT CONCIERTO_PK PRIMARY KEY (IdConcierto),
    CONSTRAINT CONCIERTO_TOUR_FK FOREIGN KEY (TOUR_IdTour)
        REFERENCES TOUR (IdTour) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT CONCIERTO_SEDE_FK FOREIGN KEY (SEDE_NombreSede)
        REFERENCES SEDE (NombreSede) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table VENTA
-- -----------------------------------------------------
CREATE TABLE VENTA (
    IdVenta         BIGINT          NOT NULL AUTO_INCREMENT,
    ValorTotal      DECIMAL(28,2),
    FechaVenta      DATETIME,
    USUARIO_Correo  VARCHAR(50)     NOT NULL,
    CONSTRAINT VENTA_PK PRIMARY KEY (IdVenta),
    CONSTRAINT VENTA_USUARIO_FK FOREIGN KEY (USUARIO_Correo)
        REFERENCES USUARIO (Correo) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table ZONA
-- -----------------------------------------------------
CREATE TABLE ZONA (
    IdZona          BIGINT          NOT NULL AUTO_INCREMENT,
    NombreZona      VARCHAR(50),
    TieneAsiento    BOOLEAN,
    SEDE_NombreSede VARCHAR(100)    NOT NULL,
    CONSTRAINT ZONA_PK PRIMARY KEY (IdZona),
    CONSTRAINT ZONA_SEDE_FK FOREIGN KEY (SEDE_NombreSede)
        REFERENCES SEDE (NombreSede) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table ZONA_CONCIERTO
-- -----------------------------------------------------
CREATE TABLE ZONA_CONCIERTO (
    IdPrecio                BIGINT          NOT NULL AUTO_INCREMENT,
    Precio                  DECIMAL(28,2),
    CantidadDisponible      INTEGER,
    ZONA_IdZona             BIGINT          NOT NULL,
    CONCIERTO_IdConcierto   BIGINT          NOT NULL,
    CONSTRAINT ZONA_CONCIERTO_PK PRIMARY KEY (IdPrecio),
    CONSTRAINT ZONA_CONCIERTO_ZONA_FK FOREIGN KEY (ZONA_IdZona)
        REFERENCES ZONA (IdZona) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT ZONA_CONCIERTO_CONCIERTO_FK FOREIGN KEY (CONCIERTO_IdConcierto)
        REFERENCES CONCIERTO (IdConcierto) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table LUGAR
-- -----------------------------------------------------
CREATE TABLE LUGAR (
    IdLugar         BIGINT      NOT NULL AUTO_INCREMENT,
    NumeroAsiento   INTEGER,
    Fila            VARCHAR(10),
    ZONA_IdZona     BIGINT      NOT NULL,
    CONSTRAINT LUGAR_PK PRIMARY KEY (IdLugar),
    CONSTRAINT LUGAR_ZONA_FK FOREIGN KEY (ZONA_IdZona)
        REFERENCES ZONA (IdZona) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table BOLETO
-- -----------------------------------------------------
CREATE TABLE BOLETO (
    CodigoBoleto                BIGINT      NOT NULL AUTO_INCREMENT,
    EstadoBoleto                VARCHAR(15),
    LUGAR_IdLugar               BIGINT      NULL,
    ZONA_CONCIERTO_IdPrecio     BIGINT      NOT NULL,
    VENTA_IdVenta               BIGINT      NOT NULL,
    CONSTRAINT BOLETO_PK PRIMARY KEY (CodigoBoleto),
    CONSTRAINT BOLETO_LUGAR_FK FOREIGN KEY (LUGAR_IdLugar)
        REFERENCES LUGAR (IdLugar) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT BOLETO_ZONA_CONCIERTO_FK FOREIGN KEY (ZONA_CONCIERTO_IdPrecio)
        REFERENCES ZONA_CONCIERTO (IdPrecio) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT BOLETO_VENTA_FK FOREIGN KEY (VENTA_IdVenta)
        REFERENCES VENTA (IdVenta) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table RESENA
-- -----------------------------------------------------
CREATE TABLE RESENA (
    IdResena                BIGINT          NOT NULL AUTO_INCREMENT,
    Comentario              VARCHAR(350),
    Calificacion            INTEGER,
    USUARIO_Correo          VARCHAR(50)     NOT NULL,
    CONCIERTO_IdConcierto   BIGINT          NOT NULL,
    CONSTRAINT RESENA_PK PRIMARY KEY (IdResena),
    CONSTRAINT RESENA_USUARIO_FK FOREIGN KEY (USUARIO_Correo)
        REFERENCES USUARIO (Correo) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT RESENA_CONCIERTO_FK FOREIGN KEY (CONCIERTO_IdConcierto)
        REFERENCES CONCIERTO (IdConcierto) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table CON_ORG (CONCIERTO - ORGANIZADOR)
-- -----------------------------------------------------
CREATE TABLE CON_ORG (
    CONCIERTO_IdConcierto           BIGINT          NOT NULL,
    ORGANIZADOR_NombreOrganizador   VARCHAR(100)    NOT NULL,
    CONSTRAINT CON_ORG_PK PRIMARY KEY (CONCIERTO_IdConcierto, ORGANIZADOR_NombreOrganizador),
    CONSTRAINT CON_ORG_CONCIERTO_FK FOREIGN KEY (CONCIERTO_IdConcierto)
        REFERENCES CONCIERTO (IdConcierto) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT CON_ORG_ORGANIZADOR_FK FOREIGN KEY (ORGANIZADOR_NombreOrganizador)
        REFERENCES ORGANIZADOR (NombreOrganizador) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table CON_ART (CONCIERTO - ARTISTA_INDIVIDUAL)
-- -----------------------------------------------------
CREATE TABLE CON_ART (
    CONCIERTO_IdConcierto           BIGINT  NOT NULL,
    ARTISTA_INDIVIDUAL_IdArtista    BIGINT  NOT NULL,
    CONSTRAINT CON_ART_PK PRIMARY KEY (CONCIERTO_IdConcierto, ARTISTA_INDIVIDUAL_IdArtista),
    CONSTRAINT CON_ART_CONCIERTO_FK FOREIGN KEY (CONCIERTO_IdConcierto)
        REFERENCES CONCIERTO (IdConcierto) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT CON_ART_ARTISTA_FK FOREIGN KEY (ARTISTA_INDIVIDUAL_IdArtista)
        REFERENCES ARTISTA_INDIVIDUAL (IdArtista) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table CON_GRU (CONCIERTO - GRUPO)
-- -----------------------------------------------------
CREATE TABLE CON_GRU (
    CONCIERTO_IdConcierto   BIGINT  NOT NULL,
    GRUPO_IdGrupo           BIGINT  NOT NULL,
    CONSTRAINT CON_GRU_PK PRIMARY KEY (CONCIERTO_IdConcierto, GRUPO_IdGrupo),
    CONSTRAINT CON_GRU_CONCIERTO_FK FOREIGN KEY (CONCIERTO_IdConcierto)
        REFERENCES CONCIERTO (IdConcierto) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT CON_GRU_GRUPO_FK FOREIGN KEY (GRUPO_IdGrupo)
        REFERENCES GRUPO (IdGrupo) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table GRU_ART (GRUPO - ARTISTA_INDIVIDUAL)
-- -----------------------------------------------------
CREATE TABLE GRU_ART (
    GRUPO_IdGrupo                   BIGINT      NOT NULL,
    ARTISTA_INDIVIDUAL_IdArtista    BIGINT      NOT NULL,
    Rol                             VARCHAR(50),
    CONSTRAINT GRU_ART_PK PRIMARY KEY (GRUPO_IdGrupo, ARTISTA_INDIVIDUAL_IdArtista),
    CONSTRAINT GRU_ART_GRUPO_FK FOREIGN KEY (GRUPO_IdGrupo)
        REFERENCES GRUPO (IdGrupo) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT GRU_ART_ARTISTA_FK FOREIGN KEY (ARTISTA_INDIVIDUAL_IdArtista)
        REFERENCES ARTISTA_INDIVIDUAL (IdArtista) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table ART_GEN (ARTISTA_INDIVIDUAL - GENERO)
-- -----------------------------------------------------
CREATE TABLE ART_GEN (
    ARTISTA_INDIVIDUAL_IdArtista    BIGINT  NOT NULL,
    GENERO_IdGenero                 BIGINT  NOT NULL,
    CONSTRAINT ART_GEN_PK PRIMARY KEY (ARTISTA_INDIVIDUAL_IdArtista, GENERO_IdGenero),
    CONSTRAINT ART_GEN_ARTISTA_FK FOREIGN KEY (ARTISTA_INDIVIDUAL_IdArtista)
        REFERENCES ARTISTA_INDIVIDUAL (IdArtista) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT ART_GEN_GENERO_FK FOREIGN KEY (GENERO_IdGenero)
        REFERENCES GENERO (IdGenero) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table GRU_GEN (GRUPO - GENERO)
-- -----------------------------------------------------
CREATE TABLE GRU_GEN (
    GRUPO_IdGrupo   BIGINT  NOT NULL,
    GENERO_IdGenero BIGINT  NOT NULL,
    CONSTRAINT GRU_GEN_PK PRIMARY KEY (GRUPO_IdGrupo, GENERO_IdGenero),
    CONSTRAINT GRU_GEN_GRUPO_FK FOREIGN KEY (GRUPO_IdGrupo)
        REFERENCES GRUPO (IdGrupo) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT GRU_GEN_GENERO_FK FOREIGN KEY (GENERO_IdGenero)
        REFERENCES GENERO (IdGenero) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
