-- Script 2: Inserción de Datos de Prueba (DML) para SQLite

-----------------------------------------------------------
-- 1. Inserción de Usuarios
-----------------------------------------------------------
INSERT INTO Usuario (nombre, email, contrasena_hash) VALUES
('Carlos Díaz', 'carlos.diaz@test.com', 'hash_carlos_12345'), -- id_usuario = 1
('Ana Gómez', 'ana.gomez@test.com', 'hash_ana_67890');       -- id_usuario = 2

-----------------------------------------------------------
-- 2. Inserción de Categorías (para id_usuario 1 y 2)
-----------------------------------------------------------
-- Para Carlos (id_usuario = 1)
INSERT INTO Categoria (id_categoria, id_usuario, nombre, icono) VALUES
(1, 1, 'Alimentación', '🛒'),
(2, 1, 'Transporte', '🚌'),
(3, 1, 'Salario', '💰');

-- Para Ana (id_usuario = 2)
INSERT INTO Categoria (id_categoria, id_usuario, nombre, icono) VALUES
(1, 2, 'Ocio', '🎮'),
(2, 2, 'Rentas', '🏠');

-----------------------------------------------------------
-- 3. Inserción de Cuentas Bancarias
-----------------------------------------------------------
-- Para Carlos (id_usuario = 1)
INSERT INTO CuentaBancaria (id_cuenta, id_usuario, nombre_banco, identificador_IBAN, alias) VALUES
(101, 1, 'Banco de Pruebas Global', 'ES1234567890123456789012', 'Cuenta Principal'),
(102, 1, 'Caja Ahorro Digital', 'ES9876543210987654321098', 'Cuenta Ahorros');

-- Para Ana (id_usuario = 2)
INSERT INTO CuentaBancaria (id_cuenta, id_usuario, nombre_banco, identificador_IBAN, alias) VALUES
(201, 2, 'BankApp S.A.', 'DE1112223334445556667778', 'Cuenta Nomina');

-----------------------------------------------------------
-- 4. Inserción de Movimientos
-----------------------------------------------------------
-- Movimientos de Carlos (id_usuario = 1)
INSERT INTO Movimiento (id_usuario, id_cuenta, id_categoria, fecha, descripcion, importe, origen) VALUES
-- Ingreso (Salario, id_categoria=3)
(1, 101, 3, '2025-11-01 09:00:00', 'Nómina mensual', 2500.00, 1),
-- Gasto (Alimentación, id_categoria=1)
(1, 101, 1, '2025-11-03 18:30:00', 'Compra semanal supermercado', -85.50, 0),
-- Gasto (Transporte, id_categoria=2)
(1, 102, 2, '2025-11-05 07:15:00', 'Recarga tarjeta metro', -20.00, 0);

-- Movimiento de Ana (id_usuario = 2)
INSERT INTO Movimiento (id_usuario, id_cuenta, id_categoria, fecha, descripcion, importe, origen) VALUES
-- Gasto (Ocio, id_categoria=1)
(2, 201, 1, '2025-11-10 20:00:00', 'Entrada cine y cena', -45.00, 0);

-----------------------------------------------------------
-- 5. Inserción de TicketGasto (relacionado con el segundo movimiento de Carlos)
-----------------------------------------------------------
-- El id_movimiento del segundo movimiento de Carlos será 2 (asumiendo AUTOINCREMENT de 1)
INSERT INTO TicketGasto (id_movimiento, ruta_imagen, fecha_escaneo) VALUES
(2, '/storage/tickets/carlos/ticket_super_1.jpg', '2025-11-03 19:00:00');

-----------------------------------------------------------
-- 6. Inserción de Presupuestos
-----------------------------------------------------------
-- Presupuestos de Carlos (id_usuario = 1)
INSERT INTO Presupuesto (id_presupuesto, id_usuario, id_categoria, cantidad_limite, periodo) VALUES
(1, 1, 1, 350.00, 'mensual'), -- Presupuesto de Alimentación
(2, 1, 2, 80.00, 'mensual');  -- Presupuesto de Transporte

-- Presupuesto de Ana (id_usuario = 2)
INSERT INTO Presupuesto (id_presupuesto, id_usuario, id_categoria, cantidad_limite, periodo) VALUES
(1, 2, 1, 150.00, 'semanal'); -- Presupuesto de Ocio

-----------------------------------------------------------
-- 7. Inserción de Notificaciones
-----------------------------------------------------------
-- Notificación para Carlos (id_usuario = 1)
INSERT INTO Notificacion (id_notificacion, id_usuario, tipo, mensaje) VALUES
(1, 1, 'preventiva', 'Tu presupuesto de Alimentación está cerca de agotarse.'),
(2, 1, 'logro', '¡Felicidades! Has ahorrado un 10% más este mes.');

-- Notificación para Ana (id_usuario = 2)
INSERT INTO Notificacion (id_notificacion, id_usuario, tipo, mensaje) VALUES
(1, 2, 'recordatorio', 'Recuerda registrar tus gastos de esta semana.');