const { Router } = require('express');
const router = Router();

const db = require('../settings/db');

router.get('/proveedor', (req, res) => {

    db.query('SELECT * FROM proveedor', (err, rows, fields) => {
        if (!err) {
            res.json(rows);
        } else {
            console.log(err);
        }
    });
});

router.get('/proveedor/:id', (req, res) => {
    const { id } = req.params;
    db.query('SELECT * FROM proveedor WHERE id_proveedor = ?', [id], (err, rows, fields) => {
        if (!err) {
            if (rows[0] != null) {
                res.json(rows[0]);
            } else {
                res.json({status: 'Id de proveedor no encontrado'});
            }
        } else {
            console.log(err);
        }
    });

});

router.post('/addProveedor', (req, res) => {
    const { razon, direccion, telef, email, ciudad, estado } = req.body;
    const query = `
        SET @razon = ?;
        SET @direccion = ?;
        SET @telef = ?;
        SET @email = ?;
        SET @ciudad = ?;
        SET @estado = ?;
        CALL sp_proveedorAdd( @razon, @direccion, @telef, @email, @ciudad, @estado);
    `;

    db.query(query, [razon, direccion, telef, email, ciudad, estado], (err, rows, fields) => {
        if (!err) {
            res.json({status: 'Proveedor Guardado'});
        } else {
            console.log(err);
        }
    });
});

router.put('/updateProveedor/:id', (req, res) => {
    const { razon, direccion, telef, email, ciudad, estado } = req.body;
    const { id } = req.params;
    const query = `
        SET @id = ?;
        SET @razon = ?;
        SET @direccion = ?;
        SET @telef = ?;
        SET @email = ?;
        SET @ciudad = ?;
        SET @estado = ?;
        CALL sp_proveedorUpdate(@id, @razon, @direccion, @telef, @email, @ciudad, @estado);
    `;


    db.query(query, [id, razon, direccion, telef, email, ciudad, estado], (err, rows, fields) => {
        if (!err) {
            res.json(rows[7][0]);                  
        } else {
            console.log(err);
        }
    });
});

router.delete('/deleteProveedor/:id', (req, res) => {
    const {id} = req.params;
    const query = 'DELETE FROM proveedor WHERE id_proveedor = ?';

    db.query(query, [id], (err, rows, fields) => {
        if (!err) {
            res.json({status: 'Proveedor Eliminado'});
        } else {
            console.log(err);
        }
    });
});


module.exports = router;