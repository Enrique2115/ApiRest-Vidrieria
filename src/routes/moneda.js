const { Router } = require("express");

const router = Router();

const db = require('../settings/db');

router.get('/moneda', (req, res) => {
    db.query('SELECT * FROM tipo_moneda', (err, rows, fields) => {
        if (!err) {
            res.json(rows);
        } else {
            console.log(err);
        }
    });
});

router.get('/moneda/:id', (req, res) => {
    const { id } = req.params;
    db.query('SELECT * FROM tipo_moneda WHERE id_tipo = ?', [id], (err, rows, fields) => {
        if (!err) {
            if (rows[0] != null) {
                res.json(rows[0]);
            } else {
                res.json({status: 'Id de Moneda no encontrado'});
            }
        } else {
            console.log(err);
        }
    });
});

router.post('/moneda', (req, res) =>{
    const { nombre } = req.body;
    const query = `
        SET @nombre = ?;
        CALL sp_moneda(@nombre);
    `;
    db.query(query, [nombre], (err, rows, fields) =>{
        if (!err) {
            res.json({status: 'Moneda Guardada'});
        } else {
            console.log(err);
        }
    });
});

router.delete('/moneda/:id', (req, res) => {
    const {id} = req.params;
    const query = 'DELETE FROM tipo_moneda WHERE id_tipo = ?';

    db.query(query, [id], (err, rows, fields) => {
        if (!err) {
            res.json({status: 'Moneda Eliminada'});
        } else {
            console.log(err);
        }
    });
});

module.exports = router;