-- StoreProcedure
--

-- sp_buscarCategoria
DELIMITER $$
CREATE PROCEDURE `sp_buscarCategoria`(
	_criterio VARCHAR(80)
)
BEGIN
	SELECT c.id_categoria, c.nombre, d.alto, d.largo, d.color, d.forma, d.espesor 
	FROM categoria c 
    INNER JOIN detalle_categoria d 
	ON c.id_categoria = d.id_categoria
	WHERE c.nombre LIKE CONCAT('%', _criterio, '%')
	ORDER BY c.id_categoria;
END$$
DELIMITER ;

-- sp_buscarProducto
DELIMITER $$
CREATE PROCEDURE `sp_buscarProducto`(
	_criterio VARCHAR(80),
    _estado BOOLEAN
)
BEGIN
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
DELIMITER ;

-- sp_buscarProveedor
DELIMITER $$
CREATE PROCEDURE `sp_buscarProveedor`(
	_criterio VARCHAR(80),
    _estado BOOLEAN
)
BEGIN
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
DELIMITER ;

-- sp_categoriaAdd
DELIMITER $$
CREATE PROCEDURE `sp_categoriaAdd`(
	_id VARCHAR(50),
	_nombre VARCHAR(45),
    _alto DECIMAL(4,2),
    _largo DECIMAL(4,2),
    _color VARCHAR(25),
    _forma VARCHAR(45),
    _espesor INT
)
BEGIN
	DECLARE _idDetalle int;
    SET _idDetalle =  (select count(id_detalle_categoria) from detalle_categoria) + 1;
    
	INSERT INTO categoria(id_categoria, nombre)
    VALUES (_id, _nombre);
    
	SET _idDetalle =  (select count(id_detalle_categoria) from detalle_categoria) + 1;
	INSERT INTO detalle_categoria(id_detalle_categoria, alto, largo, color, forma, espesor, id_categoria)
    VALUES(_idDetalle, _alto, _largo, _color, _forma, _espesor, _id);
END$$
DELIMITER ;

-- sp_cliente
DELIMITER $$
CREATE PROCEDURE `sp_cliente`(
	_dni VARCHAR(8),
    _nombre VARCHAR(100),
    _direccion VARCHAR(100),
    _telef VARCHAR(15),
    _estado INT
)
BEGIN
	DECLARE _id int;
    SET _id =  (select count(id_cliente) from cliente) + 1;
	INSERT INTO cliente (id_cliente, dni, nombre, direccion, telef, estado) 
    VALUES(_id, _dni, _nombre, _direccion, _telef, _estado);
END$$
DELIMITER ;

-- sp_comprobante
DELIMITER $$
CREATE PROCEDURE `sp_comprobante`(
    _fecha DATE,
    _tipo INT,
    _n_orden INT,
    _id_cliente INT
)
BEGIN
	DECLARE _id int;
    SET _id =  (select count(id_comprobante) from comprobante) + 1;
	INSERT INTO comprobante (id_comprobante, fecha_emision, tipo, n_orden, id_cliente) 
    VALUES(_id, _fecha, _tipo, _n_orden, _id_cliente);
END$$
DELIMITER ;

-- sp_inhabilitarProducto
DELIMITER $$
CREATE PROCEDURE `sp_inhabilitarProducto`(
	_id VARCHAR(50)
)
BEGIN
	UPDATE producto SET estado = 0 WHERE id_producto = _id ;
END$$
DELIMITER ;

-- sp_inhabilitarProveedor
DELIMITER $$
CREATE PROCEDURE `sp_inhabilitarProveedor`(
	_id VARCHAR(50)
)
BEGIN
	UPDATE PROVEEDOR SET estado = 0 WHERE id_proveedor = _id;
END$$
DELIMITER ;

-- sp_login
DELIMITER $$
CREATE PROCEDURE `sp_login`(
	_user VARCHAR(45),
    _password VARCHAR(50),
    OUT _existe INT,
	OUT _user_name CHAR(30)
)
BEGIN 
	SET _existe = 0;
    SET _user_name = "";
	SELECT nombre_usuario, id_usuario INTO _user_name, _existe FROM usuario WHERE user = _user AND password = _password;
END$$
DELIMITER ;

-- sp_moneda
DELIMITER $$
CREATE PROCEDURE `sp_moneda`(
	_nombre VARCHAR(50)
)
BEGIN
	DECLARE _id int;
	SET _id =  (select count(id_tipo) from tipo_moneda) + 1;
	INSERT INTO tipo_moneda (id_tipo, nombre) VALUES (_id, _nombre);
END$$
DELIMITER ;

-- sp_productoAdd
DELIMITER $$
CREATE PROCEDURE `sp_productoAdd`(
	_id VARCHAR(80),
    _nombre VARCHAR(50),
    _stock INT,
    _pre_costo DOUBLE(5,2),
    _pre_venta DOUBLE(5,2),
    _estado INT,
    _id_proveedor VARCHAR(50),
    _id_categoria VARCHAR(50)
)
BEGIN
	INSERT INTO producto (id_producto, nombre_producto, stock, precio_costo, precio_venta, estado, id_proveedor, id_categoria)
	VALUES (_id, _nombre, _stock, _pre_costo, _pre_venta, _estado, _id_proveedor, _id_categoria);
END$$
DELIMITER ;

-- sp_productoUpdate
DELIMITER $$
CREATE PROCEDURE `sp_productoUpdate`(
	_id VARCHAR(80),
    _nombre VARCHAR(50),
    _stock INT,
    _pre_costo DOUBLE(5,2),
    _pre_venta DOUBLE(5,2),
    _estado INT,
    _id_proveedor VARCHAR(50),
    _id_categoria VARCHAR(50)
)
BEGIN
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
DELIMITER ;

-- sp_proveedorAdd
DELIMITER $$
CREATE PROCEDURE `sp_proveedorAdd`(
	_id VARCHAR(50),
	_razon VARCHAR(50),
	_direccion VARCHAR(60),
    _telef VARCHAR(10),
    _email VARCHAR(80),
    _ciudad VARCHAR(45),
    _estado INT
    )
BEGIN
	INSERT INTO proveedor(id_proveedor, razon_social, direccion, celular, email, ciudad, estado)
	VALUES (_id, _razon, _direccion, _telef, _email, _ciudad, _estado);
END$$
DELIMITER ;

-- sp_proveedorUpdate
DELIMITER $$
CREATE PROCEDURE `sp_proveedorUpdate`(
	_id VARCHAR(50),
	_razon VARCHAR(50),
	_direccion VARCHAR(60),
    _telef VARCHAR(10),
    _email VARCHAR(80),
    _ciudad VARCHAR(45),
	_estado INT
    )
BEGIN
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
DELIMITER ;

-- sp_tipo_comprobante
DELIMITER $$
CREATE PROCEDURE `sp_tipo_comprobante`(
	_nombre VARCHAR(50)
)
BEGIN
	DECLARE _id int;
	SET _id =  (select count(id_tipo) from tipo_comprobante) + 1;
	INSERT INTO tipo_comprobante (id_tipo, nombre) VALUES (_id, _nombre);
END$$
DELIMITER ;

-- sp_updateStock
DELIMITER $$
CREATE PROCEDURE `sp_updateStock`(
	_cantidad INT,
    _id_producto VARCHAR(100)
)
BEGIN
	UPDATE producto SET stock = _cantidad WHERE id_producto = _id_producto;
END$$
DELIMITER ;

-- sp_usuario
DELIMITER $$
CREATE PROCEDURE `sp_usuario`(
	_nombre VARCHAR(45),
    _email VARCHAR(60),
    _user VARCHAR(45),
    _password VARCHAR(50),
    _estado INT
)
BEGIN
	DECLARE _id int;
	SET _id =  (select count(id_usuario) from usuario) + 1;
	INSERT INTO usuario (id_usuario, nombre_usuario, email, user, password, estado) 
    VALUES (_id, _nombre, _email, _user, _password, _estado);
END$$
DELIMITER ;

-- sp_venta
DELIMITER $$
CREATE PROCEDURE `sp_venta`(
	_tipo_moneda INT,
    _id_comprobante INT,
    _sub_total DOUBLE,
    _igv DOUBLE,
    _total DOUBLE
)
BEGIN
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