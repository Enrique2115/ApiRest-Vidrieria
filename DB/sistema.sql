-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 03-02-2022 a las 23:15:58
-- Versión del servidor: 10.4.21-MariaDB
-- Versión de PHP: 8.0.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `sistema`
--
CREATE DATABASE IF NOT EXISTS `sistema` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `sistema`;

DELIMITER $$
--
-- Procedimientos
--
DROP PROCEDURE IF EXISTS `sp_buscarCategoria`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_buscarCategoria` (`_criterio` VARCHAR(80))  BEGIN
	SELECT c.id_categoria, c.nombre, d.alto, d.largo, d.color, d.forma, d.espesor 
	FROM categoria c 
    INNER JOIN detalle_categoria d 
	ON c.id_categoria = d.id_categoria
	WHERE c.nombre LIKE CONCAT('%', _criterio, '%')
	ORDER BY c.id_categoria;
END$$

DROP PROCEDURE IF EXISTS `sp_buscarProducto`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_buscarProducto` (`_criterio` VARCHAR(80), `_estado` BOOLEAN)  BEGIN
	IF length(_criterio) = 0 AND _estado = TRUE THEN
		SELECT * FROM PRODUCTO WHERE estado = 1;
    ELSEIF(length(_criterio) > 0 AND _estado = TRUE) THEN
		SELECT * FROM PRODUCTO WHERE nombre_producto LIKE CONCAT('%', _criterio, '%') AND estado = 1;
	ELSEIF(length(_criterio) = 0 AND _estado = FALSE) THEN
		SELECT * FROM PRODUCTO WHERE estado = 0;
	ELSEIF(length(_criterio) > 0 AND _estado = FALSE)THEN
		SELECT * FROM PRODUCTO WHERE nombre_producto LIKE CONCAT('%', _criterio, '%') AND estado = 0;
    END IF;
END$$

DROP PROCEDURE IF EXISTS `sp_buscarProveedor`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_buscarProveedor` (`_criterio` VARCHAR(80), `_estado` BOOLEAN)  BEGIN
	IF length(_criterio) = 0 AND _estado = TRUE THEN
		SELECT * FROM PROVEEDOR WHERE estado = 1;
    ELSEIF(length(_criterio) > 0 AND _estado = TRUE) THEN
		SELECT * FROM PROVEEDOR WHERE razon_social LIKE CONCAT('%', _criterio, '%') 
        AND estado = 1 ORDER BY razon_social;
	ELSEIF(length(_criterio) = 0 AND _estado = FALSE) THEN
		SELECT * FROM PROVEEDOR WHERE estado = 0;
	ELSEIF(length(_criterio) > 0 AND _estado = FALSE)THEN
		SELECT * FROM PROVEEDOR WHERE razon_social LIKE CONCAT('%', _criterio, '%') 
        AND estado = 0 ORDER BY razon_social;
    END IF;
END$$

DROP PROCEDURE IF EXISTS `sp_categoriaAdd`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_categoriaAdd` (`_id` VARCHAR(50), `_nombre` VARCHAR(45), `_alto` DECIMAL(4,2), `_largo` DECIMAL(4,2), `_color` VARCHAR(25), `_forma` VARCHAR(45), `_espesor` INT)  BEGIN
	DECLARE _idDetalle int;
    SET _idDetalle =  (select count(id_detalle_categoria) from detalle_categoria) + 1;
    
	INSERT INTO categoria(id_categoria, nombre)
    VALUES (_id, _nombre);
    
	SET _idDetalle =  (select count(id_detalle_categoria) from detalle_categoria) + 1;
	INSERT INTO detalle_categoria(id_detalle_categoria, alto, largo, color, forma, espesor, id_categoria)
    VALUES(_idDetalle, _alto, _largo, _color, _forma, _espesor, _id);
END$$

DROP PROCEDURE IF EXISTS `sp_cliente`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_cliente` (`_dni` VARCHAR(8), `_nombre` VARCHAR(100), `_direccion` VARCHAR(100), `_telef` VARCHAR(15), `_estado` INT)  BEGIN
	DECLARE _id int;
    SET _id =  (select count(id_cliente) from cliente) + 1;
	INSERT INTO cliente (id_cliente, dni, nombre, direccion, telef, estado) 
    VALUES(_id, _dni, _nombre, _direccion, _telef, _estado);
END$$

DROP PROCEDURE IF EXISTS `sp_comprobante`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_comprobante` (`_fecha` DATE, `_tipo` INT, `_n_orden` INT, `_id_cliente` INT)  BEGIN
	DECLARE _id int;
    SET _id =  (select count(id_comprobante) from comprobante) + 1;
	INSERT INTO comprobante (id_comprobante, fecha_emision, tipo, n_orden, id_cliente) 
    VALUES(_id, _fecha, _tipo, _n_orden, _id_cliente);
END$$

DROP PROCEDURE IF EXISTS `sp_inhabilitarProducto`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_inhabilitarProducto` (`_id` VARCHAR(50))  BEGIN
	UPDATE producto SET estado = 0 WHERE id_producto = _id ;
END$$

DROP PROCEDURE IF EXISTS `sp_inhabilitarProveedor`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_inhabilitarProveedor` (`_id` VARCHAR(50))  BEGIN
	UPDATE PROVEEDOR SET estado = 0 WHERE id_proveedor = _id;
END$$

DROP PROCEDURE IF EXISTS `sp_login`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_login` (`_user` VARCHAR(45), `_password` VARCHAR(50), OUT `_existe` INT, OUT `_user_name` CHAR(30))  BEGIN 
	SET _existe = 0;
    SET _user_name = "";
	SELECT nombre_usuario, id_usuario INTO _user_name, _existe FROM usuario WHERE user = _user AND password = _password;
END$$

DROP PROCEDURE IF EXISTS `sp_moneda`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_moneda` (`_nombre` VARCHAR(50))  BEGIN
	DECLARE _id int;
	SET _id =  (select count(id_tipo) from tipo_moneda) + 1;
	INSERT INTO tipo_moneda (id_tipo, nombre) VALUES (_id, _nombre);
END$$

DROP PROCEDURE IF EXISTS `sp_productoAdd`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_productoAdd` (`_id` VARCHAR(80), `_nombre` VARCHAR(50), `_stock` INT, `_pre_costo` DOUBLE(5,2), `_pre_venta` DOUBLE(5,2), `_estado` INT, `_id_proveedor` VARCHAR(50), `_id_categoria` VARCHAR(50))  BEGIN
	INSERT INTO producto (id_producto, nombre_producto, stock, precio_costo, precio_venta, estado, id_proveedor, id_categoria)
	VALUES (_id, _nombre, _stock, _pre_costo, _pre_venta, _estado, _id_proveedor, _id_categoria);
END$$

DROP PROCEDURE IF EXISTS `sp_productoUpdate`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_productoUpdate` (`_id` VARCHAR(80), `_nombre` VARCHAR(50), `_stock` INT, `_pre_costo` DOUBLE(5,2), `_pre_venta` DOUBLE(5,2), `_estado` INT, `_id_proveedor` VARCHAR(50), `_id_categoria` VARCHAR(50))  BEGIN
	UPDATE producto
	SET
		nombre_producto = _nombre,
        stock = _stock,
        precio_costo = _pre_costo,
		precio_venta = _pre_venta,
		estado = _estado,
		id_proveedor = _id_proveedor,
		id_categoria = _id_categoria
	WHERE 
        id_producto = _id;
END$$

DROP PROCEDURE IF EXISTS `sp_proveedorAdd`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_proveedorAdd` (`_id` VARCHAR(50), `_razon` VARCHAR(50), `_direccion` VARCHAR(60), `_telef` VARCHAR(10), `_email` VARCHAR(80), `_ciudad` VARCHAR(45), `_estado` INT)  BEGIN
	INSERT INTO proveedor(id_proveedor, razon_social, direccion, celular, email, ciudad, estado)
	VALUES (_id, _razon, _direccion, _telef, _email, _ciudad, _estado);
END$$

DROP PROCEDURE IF EXISTS `sp_proveedorUpdate`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_proveedorUpdate` (`_id` VARCHAR(50), `_razon` VARCHAR(50), `_direccion` VARCHAR(60), `_telef` VARCHAR(10), `_email` VARCHAR(80), `_ciudad` VARCHAR(45), `_estado` INT)  BEGIN
    UPDATE proveedor 
	SET
		razon_social = _razon,
		direccion = _direccion,
		celular = _telef,
		email = _email,
		estado = _estado,
		ciudad = _ciudad
	WHERE 
		id_proveedor = _id;
END$$

DROP PROCEDURE IF EXISTS `sp_tipo_comprobante`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_tipo_comprobante` (`_nombre` VARCHAR(50))  BEGIN
	DECLARE _id int;
	SET _id =  (select count(id_tipo) from tipo_comprobante) + 1;
	INSERT INTO tipo_comprobante (id_tipo, nombre) VALUES (_id, _nombre);
END$$

DROP PROCEDURE IF EXISTS `sp_updateStock`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_updateStock` (`_cantidad` INT, `_id_producto` VARCHAR(100))  BEGIN
	UPDATE producto SET stock = _cantidad WHERE id_producto = _id_producto;
END$$

DROP PROCEDURE IF EXISTS `sp_usuario`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_usuario` (`_nombre` VARCHAR(45), `_email` VARCHAR(60), `_user` VARCHAR(45), `_password` VARCHAR(50), `_estado` INT)  BEGIN
	DECLARE _id int;
	SET _id =  (select count(id_usuario) from usuario) + 1;
	INSERT INTO usuario (id_usuario, nombre_usuario, email, user, password, estado) 
    VALUES (_id, _nombre, _email, _user, _password, _estado);
END$$

DROP PROCEDURE IF EXISTS `sp_venta`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_venta` (`_tipo_moneda` INT, `_id_comprobante` INT, `_sub_total` DOUBLE, `_igv` DOUBLE, `_total` DOUBLE)  BEGIN
	-- Crea la Venta
    DECLARE _id int;
    DECLARE _id2 int;
	SET _id =  (select count(id_venta) from venta) + 1;
	INSERT INTO venta (id_venta, tipo_moneda, id_boleta, sub_total, igv, total) 
    VALUES (_id, _tipo_moneda, _id_comprobante, _sub_total, _igv, _total);
    
    -- Detalles de la venta
    
	SET _id2 =  (select count(id_detalle) from detalle_venta) + 1;
    INSERT INTO detalle_venta (id_detalle, piezas_vendidas, costo_unitario, id_prod, id_venta)
    VALUES (_id2);
    
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categoria`
--

DROP TABLE IF EXISTS `categoria`;
CREATE TABLE `categoria` (
  `id_categoria` varchar(50) NOT NULL,
  `nombre` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cliente`
--

DROP TABLE IF EXISTS `cliente`;
CREATE TABLE `cliente` (
  `id_cliente` int(11) NOT NULL,
  `dni` varchar(8) DEFAULT NULL,
  `nombre` varchar(100) DEFAULT NULL COMMENT 'Razon Social',
  `direccion` varchar(100) DEFAULT NULL,
  `telef` varchar(15) DEFAULT NULL,
  `estado` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `comprobante`
--

DROP TABLE IF EXISTS `comprobante`;
CREATE TABLE `comprobante` (
  `id_comprobante` int(11) NOT NULL,
  `fecha_emision` date NOT NULL,
  `tipo` int(11) NOT NULL COMMENT 'Tipo de comprobante: 1-Boleta, 2-Factura',
  `n_orden` int(11) NOT NULL,
  `id_cliente` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_categoria`
--

DROP TABLE IF EXISTS `detalle_categoria`;
CREATE TABLE `detalle_categoria` (
  `id_detalle_categoria` int(11) NOT NULL,
  `alto` decimal(4,2) NOT NULL,
  `largo` decimal(4,2) NOT NULL,
  `color` varchar(25) NOT NULL,
  `forma` varchar(45) NOT NULL,
  `espesor` int(11) NOT NULL COMMENT 'VALORES EN MILIMETROS',
  `id_categoria` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_venta`
--

DROP TABLE IF EXISTS `detalle_venta`;
CREATE TABLE `detalle_venta` (
  `id_detalle` int(11) NOT NULL,
  `piezas_vendidas` double NOT NULL,
  `costo_unitario` double NOT NULL,
  `id_prod` varchar(100) NOT NULL,
  `id_venta` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `producto`
--

DROP TABLE IF EXISTS `producto`;
CREATE TABLE `producto` (
  `id_producto` varchar(100) NOT NULL,
  `nombre_producto` varchar(50) NOT NULL,
  `stock` int(11) NOT NULL COMMENT 'Muestra la Cantidad de productos que hay',
  `precio_costo` double(5,2) NOT NULL,
  `precio_venta` double(5,2) NOT NULL,
  `estado` int(11) NOT NULL COMMENT '1 - Activo\n2 - Inactivo',
  `id_proveedor` varchar(50) NOT NULL,
  `id_categoria` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proveedor`
--

DROP TABLE IF EXISTS `proveedor`;
CREATE TABLE `proveedor` (
  `id_proveedor` varchar(50) NOT NULL,
  `razon_social` varchar(50) NOT NULL,
  `direccion` varchar(60) NOT NULL,
  `celular` varchar(10) DEFAULT NULL,
  `email` varchar(80) NOT NULL,
  `ciudad` varchar(45) DEFAULT NULL,
  `estado` int(11) NOT NULL COMMENT '1 - Activo\n0 - Inactivo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipo_comprobante`
--

DROP TABLE IF EXISTS `tipo_comprobante`;
CREATE TABLE `tipo_comprobante` (
  `id_tipo` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipo_moneda`
--

DROP TABLE IF EXISTS `tipo_moneda`;
CREATE TABLE `tipo_moneda` (
  `id_tipo` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

DROP TABLE IF EXISTS `usuario`;
CREATE TABLE `usuario` (
  `id_usuario` int(11) NOT NULL,
  `nombre_usuario` varchar(45) NOT NULL,
  `email` varchar(60) NOT NULL,
  `user` varchar(45) NOT NULL COMMENT 'Sera el identificador para iniciar sesion',
  `password` longblob NOT NULL,
  `estado` int(11) NOT NULL COMMENT '1 - Activo\n2 - Inactivo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`id_usuario`, `nombre_usuario`, `email`, `user`, `password`, `estado`) VALUES
(1, 'Rosa Reyna Febres Palacios', 'lmorochofebres@gmail.com', 'rosarey', 0x3132333435, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `venta`
--

DROP TABLE IF EXISTS `venta`;
CREATE TABLE `venta` (
  `id_venta` int(11) NOT NULL,
  `id_comprobante` int(11) NOT NULL,
  `tipo_moneda` int(11) NOT NULL,
  `sub_total` double NOT NULL,
  `igv` double NOT NULL,
  `total` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `categoria`
--
ALTER TABLE `categoria`
  ADD PRIMARY KEY (`id_categoria`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- Indices de la tabla `cliente`
--
ALTER TABLE `cliente`
  ADD PRIMARY KEY (`id_cliente`),
  ADD UNIQUE KEY `dni` (`dni`);

--
-- Indices de la tabla `comprobante`
--
ALTER TABLE `comprobante`
  ADD PRIMARY KEY (`id_comprobante`),
  ADD KEY `fk_id_tipo_comprobante` (`tipo`),
  ADD KEY `fk_id_cliente` (`id_cliente`);

--
-- Indices de la tabla `detalle_categoria`
--
ALTER TABLE `detalle_categoria`
  ADD PRIMARY KEY (`id_detalle_categoria`),
  ADD KEY `fk_id_categoria_detalle` (`id_categoria`);

--
-- Indices de la tabla `detalle_venta`
--
ALTER TABLE `detalle_venta`
  ADD PRIMARY KEY (`id_detalle`),
  ADD KEY `fk_id_prod` (`id_prod`),
  ADD KEY `fk_id_venta` (`id_venta`);

--
-- Indices de la tabla `producto`
--
ALTER TABLE `producto`
  ADD PRIMARY KEY (`id_producto`),
  ADD KEY `fk_id_proveedor` (`id_proveedor`),
  ADD KEY `fk_id_categoria` (`id_categoria`);

--
-- Indices de la tabla `proveedor`
--
ALTER TABLE `proveedor`
  ADD PRIMARY KEY (`id_proveedor`),
  ADD UNIQUE KEY `razon_social` (`razon_social`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indices de la tabla `tipo_comprobante`
--
ALTER TABLE `tipo_comprobante`
  ADD PRIMARY KEY (`id_tipo`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- Indices de la tabla `tipo_moneda`
--
ALTER TABLE `tipo_moneda`
  ADD PRIMARY KEY (`id_tipo`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`id_usuario`),
  ADD UNIQUE KEY `user` (`user`);

--
-- Indices de la tabla `venta`
--
ALTER TABLE `venta`
  ADD PRIMARY KEY (`id_venta`),
  ADD KEY `fk_id_tipo_moneda` (`tipo_moneda`),
  ADD KEY `fk_id_comprobante` (`id_comprobante`);

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `comprobante`
--
ALTER TABLE `comprobante`
  ADD CONSTRAINT `fk_id_cliente` FOREIGN KEY (`id_cliente`) REFERENCES `cliente` (`id_cliente`),
  ADD CONSTRAINT `fk_id_tipo_comprobante` FOREIGN KEY (`tipo`) REFERENCES `tipo_comprobante` (`id_tipo`);

--
-- Filtros para la tabla `detalle_categoria`
--
ALTER TABLE `detalle_categoria`
  ADD CONSTRAINT `fk_id_categoria_detalle` FOREIGN KEY (`id_categoria`) REFERENCES `categoria` (`id_categoria`);

--
-- Filtros para la tabla `detalle_venta`
--
ALTER TABLE `detalle_venta`
  ADD CONSTRAINT `fk_id_prod` FOREIGN KEY (`id_prod`) REFERENCES `producto` (`id_producto`),
  ADD CONSTRAINT `fk_id_venta` FOREIGN KEY (`id_venta`) REFERENCES `venta` (`id_venta`);

--
-- Filtros para la tabla `producto`
--
ALTER TABLE `producto`
  ADD CONSTRAINT `fk_id_categoria` FOREIGN KEY (`id_categoria`) REFERENCES `categoria` (`id_categoria`),
  ADD CONSTRAINT `fk_id_proveedor` FOREIGN KEY (`id_proveedor`) REFERENCES `proveedor` (`id_proveedor`);

--
-- Filtros para la tabla `venta`
--
ALTER TABLE `venta`
  ADD CONSTRAINT `fk_id_comprobante` FOREIGN KEY (`id_comprobante`) REFERENCES `comprobante` (`id_comprobante`),
  ADD CONSTRAINT `fk_id_tipo_moneda` FOREIGN KEY (`tipo_moneda`) REFERENCES `tipo_moneda` (`id_tipo`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
