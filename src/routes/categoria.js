const { Router } = require('express');
const router = Router();

const db = require('../settings/db');

router.get('/categoria', (req, res) => {

    db.query('SELECT * FROM categoria ORDER BY id_categoria', (err, rows, fields) => {
        if (!err) {
            res.json(rows);
        } else {
            console.log(err);
        }
    });
});

router.post('/addCategoria', (req, res) => {
    const { id, nombre } = req.body;
    const query = `
        SET @id = ?;
        SET @nombre = ?;
        CALL sp_categoriaAdd(@id, @nombre);
    `;

    db.query(query, [id, nombre], (err, rows, fields) => {
        if (!err) {
            res.json({status: 'Categoria Guardada'});
        } else {
            console.log(err);
        }
    });
});

router.get('/cantidadCategorias', (req, res) => {

    db.query('SELECT COUNT(id_categoria) + 1 cantidad FROM categoria;', (err, rows, fields) => {
        if (!err) {
            res.json(rows[0]);
        } else {
            console.log(err);
        }
    });
});

module.exports = router;