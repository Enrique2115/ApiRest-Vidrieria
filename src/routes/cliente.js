const { Router } = require("express");

const router = Router();

const db = require('../settings/db');

router.get('/cliente', (req, res) => {
    db.query('SELECT * FROM cliente', (err, rows, fields) => {
        if (!err) {
            res.json(rows);
        } else {
            console.log(err);
        }
    });
});

router.get('/cliente/:id', (req, res) => {
    const { id } = req.params;
    db.query('SELECT * FROM cliente WHERE id_cliente = ?', [id], (err, rows, fields) => {
        if (!err) {
            if (rows[0] != null) {
                res.json(rows[0]);
            } else {
                res.json({status: 'Id de Cliente no encontrado'});
            }
        } else {
            console.log(err);
        }
    });
});

router.post('/cliente', (req, res) =>{
    const { dni, nombre, direccion, telef, estado } = req.body;
    const query = `
        SET @dni = ?;
        SET @nombre = ?;
        SET @direccion = ?;
        SET @telef = ?;
        SET @estado = ?;
        CALL sp_cliente(@dni, @nombre, @direccion, @telef, @estado);
    `;
    db.query(query, [dni, nombre, direccion, telef, estado ], (err, rows, fields) =>{
        if (!err) {
            res.json({status: 'Cliente Guardado'});
        } else {
            console.log(err);
        }
    });
});

router.delete('/Cliente/:id', (req, res) => {
    const {id} = req.params;
    const query = 'DELETE FROM cliente WHERE id_cliente = ?';

    db.query(query, [id], (err, rows, fields) => {
        if (!err) {
            res.json({status: 'Cliente Eliminado'});
        } else {
            console.log(err);
        }
    });
});

module.exports = router;