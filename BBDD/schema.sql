-- Script 1: Creación de la Base de Datos (DDL) para SQLite

-- Habilitar la integridad referencial
PRAGMA foreign_keys = ON;

-----------------------------------------------------------
-- Tabla Usuario
-----------------------------------------------------------
CREATE TABLE Usuario (
    id_usuario          INTEGER     PRIMARY KEY AUTOINCREMENT,
    nombre              TEXT        NOT NULL,
    email               TEXT        UNIQUE NOT NULL,
    contrasena_hash     TEXT        NOT NULL,
    fecha_registro      TEXT        NOT NULL DEFAULT (datetime('now')) -- YYYY-MM-DD HH:MM:SS
);

-----------------------------------------------------------
-- Tabla Categoria
-----------------------------------------------------------
CREATE TABLE Categoria (
    id_categoria        INTEGER     NOT NULL,
    id_usuario          INTEGER     NOT NULL,
    nombre              TEXT        NOT NULL,
    icono               TEXT,
    PRIMARY KEY (id_categoria, id_usuario),
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario) ON DELETE CASCADE
);

-----------------------------------------------------------
-- Tabla CuentaBancaria
-----------------------------------------------------------
CREATE TABLE CuentaBancaria (
    id_cuenta           INTEGER     NOT NULL,
    id_usuario          INTEGER     NOT NULL,
    nombre_banco        TEXT        NOT NULL,
    identificador_IBAN  TEXT        UNIQUE,
    alias               TEXT        NOT NULL,
    PRIMARY KEY (id_cuenta, id_usuario),
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario) ON DELETE CASCADE
);

-----------------------------------------------------------
-- Tabla TicketGasto
-----------------------------------------------------------
CREATE TABLE TicketGasto (
    id_ticket           INTEGER     PRIMARY KEY AUTOINCREMENT,
    id_movimiento       INTEGER     UNIQUE NOT NULL, -- Clave foránea referenciada en Movimiento
    ruta_imagen         TEXT,
    fecha_escaneo       TEXT        NOT NULL DEFAULT (datetime('now')),
    FOREIGN KEY (id_movimiento) REFERENCES Movimiento(id_movimiento) ON DELETE CASCADE
    -- NOTA: La clave foránea apunta a Movimiento(id_movimiento).
);

-----------------------------------------------------------
-- Tabla Movimiento
-----------------------------------------------------------
CREATE TABLE Movimiento (
    id_movimiento       INTEGER     PRIMARY KEY AUTOINCREMENT,
    id_usuario          INTEGER     NOT NULL,
    id_cuenta           INTEGER     NOT NULL,
    id_categoria        INTEGER     NOT NULL,
    fecha               TEXT        NOT NULL, -- YYYY-MM-DD HH:MM:SS o solo fecha
    descripcion         TEXT,
    importe             REAL        NOT NULL, -- Positivo para ingreso, negativo para gasto
    origen              NUMERIC     NOT NULL, -- 0: manual, 1: bancario, 2: ticket
    id_ticket           INTEGER     UNIQUE, -- Clave foránea opcional a TicketGasto
    
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_cuenta, id_usuario) REFERENCES CuentaBancaria(id_cuenta, id_usuario) ON DELETE RESTRICT,
    FOREIGN KEY (id_categoria, id_usuario) REFERENCES Categoria(id_categoria, id_usuario) ON DELETE RESTRICT,
    FOREIGN KEY (id_ticket) REFERENCES TicketGasto(id_ticket) ON DELETE SET NULL
);

-- Actualizar la FK en TicketGasto después de crear Movimiento (si fuera necesario, pero la definí antes)
-- El diseño que tengo implica que TicketGasto.id_movimiento debe ser un FOREIGN KEY.
-- Lo he modelado de forma que Movimiento.id_ticket es la FK opcional, lo cual es más estándar
-- para una relación 1 a 0..1 (Movimiento puede tener un Ticket, pero el Ticket SIEMPRE tiene un Movimiento).
-- **Ajuste:** Mantengo el diseño de mi ER: `TicketGasto.id_movimiento` apunta a `Movimiento`.

-- RE-Creación de TicketGasto para seguir el ER más fielmente:
DROP TABLE IF EXISTS TicketGasto;
CREATE TABLE TicketGasto (
    id_ticket           INTEGER     PRIMARY KEY AUTOINCREMENT,
    id_movimiento       INTEGER     UNIQUE NOT NULL, -- El 1 en la relación 0..1
    ruta_imagen         TEXT,
    fecha_escaneo       TEXT        NOT NULL DEFAULT (datetime('now')),
    FOREIGN KEY (id_movimiento) REFERENCES Movimiento(id_movimiento) ON DELETE CASCADE
);

-- RE-Creación de Movimiento para que no tenga id_ticket
DROP TABLE IF EXISTS Movimiento;
CREATE TABLE Movimiento (
    id_movimiento       INTEGER     PRIMARY KEY AUTOINCREMENT,
    id_usuario          INTEGER     NOT NULL,
    id_cuenta           INTEGER     NOT NULL,
    id_categoria        INTEGER     NOT NULL,
    fecha               TEXT        NOT NULL, -- YYYY-MM-DD HH:MM:SS o solo fecha
    descripcion         TEXT,
    importe             REAL        NOT NULL, -- Positivo para ingreso, negativo para gasto
    origen              NUMERIC     NOT NULL, -- 0: manual, 1: bancario, 2: ticket
    
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_cuenta, id_usuario) REFERENCES CuentaBancaria(id_cuenta, id_usuario) ON DELETE RESTRICT,
    FOREIGN KEY (id_categoria, id_usuario) REFERENCES Categoria(id_categoria, id_usuario) ON DELETE RESTRICT
);


-----------------------------------------------------------
-- Tabla Presupuesto
-----------------------------------------------------------
CREATE TABLE Presupuesto (
    id_presupuesto      INTEGER     NOT NULL,
    id_usuario          INTEGER     NOT NULL,
    id_categoria        INTEGER     NOT NULL,
    cantidad_limite     REAL        NOT NULL,
    periodo             TEXT        NOT NULL, -- 'mensual' o 'semanal'
    PRIMARY KEY (id_presupuesto, id_usuario),
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_categoria, id_usuario) REFERENCES Categoria(id_categoria, id_usuario) ON DELETE RESTRICT
);

-----------------------------------------------------------
-- Tabla Notificacion
-----------------------------------------------------------
CREATE TABLE Notificacion (
    id_notificacion     INTEGER     NOT NULL,
    id_usuario          INTEGER     NOT NULL,
    tipo                TEXT        NOT NULL, -- 'preventiva', 'recordatorio', 'logro'
    mensaje             TEXT        NOT NULL,
    fecha_envio         TEXT        NOT NULL DEFAULT (datetime('now')),
    PRIMARY KEY (id_notificacion, id_usuario),
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario) ON DELETE CASCADE
);