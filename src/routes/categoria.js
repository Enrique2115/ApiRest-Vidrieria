const { Router } = require('express');
const router = Router();

const db = require('../settings/db');

router.get('/categoria', (req, res) => {
    const query = `
        SELECT c.id_categoria, c.nombre, d.alto, d.largo, d.color, d.forma, d.espesor 
        FROM categoria c 
        INNER JOIN detalle_categoria d 
        ON c.id_categoria = d.id_categoria
        ORDER BY c.id_categoria;
    `; 
    db.query(query, (err, rows, fields) => {
        if (!err) {
            res.json(rows);
        } else {
            console.log(err);
        }
    });
});

router.post('/addCategoria', (req, res) => {
    const { id, nombre, alto, largo, color, forma, espesor } = req.body;
    const query = `
        SET @id = ?;
        SET @nombre = ?;
        SET @alto = ?;
        SET @largo = ?;
        SET @color = ?;
        SET @forma = ?;
        SET @espesor = ?;
        CALL sp_categoriaAdd(@id, @nombre, @alto, @largo, @color, @forma, @espesor);
    `;

    db.query(query, [id, nombre, alto, largo, color, forma, espesor], (err, rows, fields) => {
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

router.post('/buscarCategoria', (req, res) => {
    const { criterio } = req.body;
    const query = `
        SET @nombre = ?;
        CALL sp_buscarCategoria(@nombre);
    `;

    db.query(query, [criterio], (err, rows, fields) => {
        if (!err) {
            res.json(rows[1]);
        } else {
            console.log(err);
            res.json({status: 'Id de Categoria no encontrado'});
        }
    });

});

module.exports = router;