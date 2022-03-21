-- Structured to DB
CREATE DATABASE sistema2;
USE sistema2;

-- categoria
CREATE TABLE `categoria` (
  `id_categoria` varchar(50) NOT NULL PRIMARY KEY ,
  `nombre` varchar(45) NOT NULL UNIQUE KEY
);

-- cliente
CREATE TABLE `cliente` (
  `id_cliente` int(11) NOT NULL PRIMARY KEY,
  `dni` varchar(8) DEFAULT NULL UNIQUE KEY,
  `nombre` varchar(100) DEFAULT NULL COMMENT 'Razon Social',
  `direccion` varchar(100) DEFAULT NULL,
  `telef` varchar(15) DEFAULT NULL,
  `estado` int(11) DEFAULT NULL
);

-- tipo_comprobante
CREATE TABLE `tipo_comprobante` (
  `id_tipo` int(11) NOT NULL PRIMARY KEY,
  `nombre` varchar(50) NOT NULL UNIQUE KEY
);

-- comprobante
CREATE TABLE `comprobante` (
  `id_comprobante` int(11) NOT NULL PRIMARY KEY,
  `fecha_emision` date NOT NULL,
  `tipo` int(11) NOT NULL COMMENT 'Tipo de comprobante: 1-Boleta, 2-Factura',
  `n_orden` int(11) NOT NULL,
  `id_cliente` int(11) DEFAULT NULL,
  CONSTRAINT `fk_id_cliente` FOREIGN KEY (`id_cliente`) REFERENCES `cliente` (`id_cliente`),
  CONSTRAINT `fk_id_tipo_comprobante` FOREIGN KEY (`tipo`) REFERENCES `tipo_comprobante` (`id_tipo`)
);

-- detalle_categoria
CREATE TABLE `detalle_categoria` (
  `id_detalle_categoria` int(11) NOT NULL PRIMARY KEY,
  `alto` decimal(4,2) NOT NULL,
  `largo` decimal(4,2) NOT NULL,
  `color` varchar(25) NOT NULL,
  `forma` varchar(45) NOT NULL,
  `espesor` int(11) NOT NULL COMMENT 'VALORES EN MILIMETROS',
  `id_categoria` varchar(50) NOT NULL,
  CONSTRAINT `fk_id_categoria_detalle` FOREIGN KEY (`id_categoria`) REFERENCES `categoria` (`id_categoria`)
);

-- proveedor
CREATE TABLE `proveedor` (
  `id_proveedor` varchar(50) NOT NULL PRIMARY KEY,
  `razon_social` varchar(50) NOT NULL UNIQUE KEY,
  `direccion` varchar(60) NOT NULL,
  `celular` varchar(10) DEFAULT NULL,
  `email` varchar(80) NOT NULL UNIQUE KEY,
  `ciudad` varchar(45) DEFAULT NULL,
  `estado` int(11) NOT NULL COMMENT '1 - Activo\n0 - Inactivo'
);

-- producto
CREATE TABLE `producto` (
  `id_producto` varchar(100) NOT NULL PRIMARY KEY,
  `nombre_producto` varchar(50) NOT NULL,
  `stock` int(11) NOT NULL COMMENT 'Muestra la Cantidad de productos que hay',
  `precio_costo` double(5,2) NOT NULL,
  `precio_venta` double(5,2) NOT NULL,
  `estado` int(11) NOT NULL COMMENT '1 - Activo\n2 - Inactivo',
  `id_proveedor` varchar(50) NOT NULL,
  `id_categoria` varchar(50) NOT NULL,
  CONSTRAINT `fk_id_categoria` FOREIGN KEY (`id_categoria`) REFERENCES `categoria` (`id_categoria`),
  CONSTRAINT `fk_id_proveedor` FOREIGN KEY (`id_proveedor`) REFERENCES `proveedor` (`id_proveedor`)
);

-- tipo_moneda
CREATE TABLE `tipo_moneda` (
  `id_tipo` int(11) NOT NULL PRIMARY KEY,
  `nombre` varchar(50) NOT NULL UNIQUE KEY
);

-- venta
CREATE TABLE `venta` (
  `id_venta` int(11) NOT NULL PRIMARY KEY,
  `id_comprobante` int(11) NOT NULL,
  `tipo_moneda` int(11) NOT NULL,
  `sub_total` double NOT NULL,
  `igv` double NOT NULL,
  `total` double NOT NULL,
  CONSTRAINT `fk_id_comprobante` FOREIGN KEY (`id_comprobante`) REFERENCES `comprobante` (`id_comprobante`),
  CONSTRAINT `fk_id_tipo_moneda` FOREIGN KEY (`tipo_moneda`) REFERENCES `tipo_moneda` (`id_tipo`)
);

-- detalle_venta
CREATE TABLE `detalle_venta` (
  `id_detalle` int(11) NOT NULL PRIMARY KEY,
  `piezas_vendidas` double NOT NULL,
  `costo_unitario` double NOT NULL,
  `id_prod` varchar(100) NOT NULL,
  `id_venta` int(11) NOT NULL,
  CONSTRAINT `fk_id_prod` FOREIGN KEY (`id_prod`) REFERENCES `producto` (`id_producto`),
  CONSTRAINT `fk_id_venta` FOREIGN KEY (`id_venta`) REFERENCES `venta` (`id_venta`)
);

-- usuario
CREATE TABLE `usuario` (
  `id_usuario` int(11) NOT NULL PRIMARY KEY,
  `nombre_usuario` varchar(45) NOT NULL,
  `email` varchar(60) NOT NULL,
  `user` varchar(45) NOT NULL UNIQUE KEY COMMENT 'Sera el identificador para iniciar sesion',
  `password` longblob NOT NULL,
  `estado` int(11) NOT NULL COMMENT '1 - Activo\n2 - Inactivo'
);
