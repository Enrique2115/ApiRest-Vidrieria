const { Router } = require("express");

const router = Router();

const db = require('../settings/db');

router.get('/producto', (req, res) => {
    db.query('SELECT  * FROM PRODUCTO WHERE estado = 1', (err, rows, fields) =>{
        if (!err) {
            res.json(rows);
        } else {
            console.log(err);
        }
    });
});

router.get('/productoInactivo', (req, res) => {

    db.query('SELECT * FROM producto WHERE estado = 0', (err, rows, fields) => {
        if (!err) {
            res.json(rows);
        } else {
            console.log(err);
        }
    });
});

router.post('/buscarProd', (req, res) => {
    const { nombre, radio } = req.body;
    const query = `
        SET @nombre = ?;
        SET @radio = ?;
        CALL sp_buscarProducto(@nombre, @radio);
    `;

    db.query(query, [nombre, radio], (err, rows, fields) => {
        if (!err) {
            res.json(rows[2]);
        } else {
            console.log(err);
            res.json({status: 'Id de producto no encontrado'});
        }
    });

});

router.post('/addProducto', (req, res) => {
    const { id, nombre_producto, stock, precio_costo, precio_venta, estado, id_proveedor, id_categoria } = req.body;
    const query = `
        SET @id = ?;
        SET @nombre = ?;
        SET @stock = ?;
        SET @pre_costo = ?;
        SET @pre_venta = ?;
        SET @estado = ?;
        SET @id_proveedor = ?;
        SET @id_categoria = ?;
        CALL sp_productoAdd(@id, @nombre, @stock, @pre_costo, @pre_venta, @estado, @id_proveedor, @id_categoria);
    `;

    db.query(query, [id, nombre_producto, stock, precio_costo, precio_venta, estado, id_proveedor, id_categoria], (err, rows, fields) => {
        if (!err) {
            res.json({status: 'Producto Guardado'});
        } else {
            console.log(err.sqlMessage);
        }
    });
});

router.put('/updateProducto/:id', (req, res) => {
    const {  nombre_producto, stock, precio_costo, precio_venta, estado, id_proveedor, id_categoria } = req.body;
    const { id } = req.params;
    const query = `
        SET @id = ?;
        SET @nombre = ?;
        SET @stock = ?;
        SET @pre_costo = ?;
        SET @pre_venta = ?;
        SET @estado = ?;
        SET @id_proveedor = ?;
        SET @id_categoria = ?;
        CALL sp_productoUpdate(@id, @nombre, @stock, @pre_costo, @pre_venta, @estado, @id_proveedor, @id_categoria);
    `;


    db.query(query, [id,  nombre_producto, stock, precio_costo, precio_venta, estado, id_proveedor, id_categoria], (err, rows, fields) => {
        if (!err) {
            res.json({status: 'Producto Actualizado'});                
        } else {
            console.log(err.sqlMessage);
        }
    });
});

router.delete('/deleteProducto/:id', (req, res) => {
    const {id} = req.params;
    const query = 'DELETE FROM producto WHERE id_producto = ?';

    db.query(query, [id], (err, rows, fields) => {
        if (!err) {
            res.json({status: 'Producto Eliminado'});
        } else {
            console.log(err);
        }
    });
});

router.put('/updateStock', (req, res) => {
    const { cantidad, id_producto } = req.body;
    const query = `
        SET @cantidad = ?;
        SET @id_producto = ?;
        CALL sp_updateStock(@cantidad, @id_producto);
    `;

    db.query(query, [cantidad, id_producto], (err, rows, fields) => {
        if (!err) {
            res.json({status: 'Stock actualizado'});
        } else {
            console.log(err);
        }
    });

});

router.get('/cantidadProductos', (req, res) => {

    db.query('SELECT COUNT(id_producto) + 1 cantidad FROM producto;', (err, rows, fields) => {
        if (!err) {
            res.json(rows[0]);
        } else {
            console.log(err);
        }
    });
});

router.put('/inhabilitarProducto/:id', (req, res) => {
    const { id } = req.params;
    const query = `
        SET @id = ?;
        CALL sp_inhabilitarProducto(@id);
    `;

    db.query(query, [id], (err, rows, fields) => {
        if (!err) {
            res.json(rows);                  
        } else {
            console.log(err);
        }
    });
});


module.exports = router;