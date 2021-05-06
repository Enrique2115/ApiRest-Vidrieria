const { Router } = require("express");

const router = Router();

const db = require('../settings/db');

router.get('/tipo_comprobante', (req, res) => {
    db.query('SELECT * FROM tipo_comprobante', (err, rows, fields) => {
        if (!err) {
            res.json(rows);
        } else {
            console.log(err);
        }
    });
});

router.get('/tipo_comprobante/:id', (req, res) => {
    const { id } = req.params;
    db.query('SELECT * FROM tipo_comprobante WHERE id_tipo = ?', [id], (err, rows, fields) => {
        if (!err) {
            if (rows[0] != null) {
                res.json(rows[0]);
            } else {
                res.json({status: 'Id Tipo Comprobante no encontrado'});
            }
        } else {
            console.log(err);
        }
    });
});

router.post('/tipo_comprobante', (req, res) =>{
    const { nombre } = req.body;
    const query = `
        SET @nombre = ?;
        CALL sp_tipo_comprobante(@nombre);
    `;
    db.query(query, [nombre], (err, rows, fields) =>{
        if (!err) {
            res.json({status: 'Tipo Comprobante Guardado'});
        } else {
            console.log(err);
        }
    });
});

router.delete('/tipo_comprobante/:id', (req, res) => {
    const {id} = req.params;
    const query = 'DELETE FROM tipo_comprobante WHERE id_tipo = ?';

    db.query(query, [id], (err, rows, fields) => {
        if (!err) {
            res.json({status: 'Tipo Comprobante Eliminado'});
        } else {
            console.log(err);
        }
    });
});

module.exports = router;