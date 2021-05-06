const { Router } = require("express");

const router = Router();

const db = require('../settings/db');

router.get('/comprobante', (req, res) => {
    db.query('SELECT * FROM comprobante', (err, rows, fields) => {
        if (!err) {
            res.json(rows);
        } else {
            console.log(err);
        }
    });
});

router.get('/comprobante/:id', (req, res) => {
    const { id } = req.params;
    db.query('SELECT * FROM comprobante WHERE id_comprobante = ?', [id], (err, rows, fields) => {
        if (!err) {
            if (rows[0] != null) {
                res.json(rows[0]);
            } else {
                res.json({status: 'Id de Comprobante no encontrado'});
            }
        } else {
            console.log(err);
        }
    });
});

router.post('/comprobante', (req, res) =>{
    const { fecha, tipo, orden, id_cliente } = req.body;
    const query = `
        SET @fecha = ?;
        SET @tipo = ?;
        SET @n_orden = ?;
        SET @id_cliente = ?;
        CALL sp_comprobante(@fecha, @tipo, @n_orden, @id_cliente);
    `;
    db.query(query, [fecha, tipo, orden, id_cliente ], (err, rows, fields) =>{
        if (!err) {
            res.json({status: 'Comprobante Guardado'});
        } else {
            console.log(err);
        }
    });
});

router.delete('/comprobante/:id', (req, res) => {
    const {id} = req.params;
    const query = 'DELETE FROM comprobante WHERE id_comprobante = ?';

    db.query(query, [id], (err, rows, fields) => {
        if (!err) {
            res.json({status: 'Comprobante Eliminado'});
        } else {
            console.log(err);
        }
    });
});

module.exports = router;