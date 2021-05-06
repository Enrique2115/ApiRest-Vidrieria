const { Router } = require("express");

const router = Router();

const db = require('../settings/db');

router.get('/usuario', (req, res) => {
    db.query('SELECT * FROM usuario', (err, rows, fields) => {
        if (!err) {
            res.json(rows);
        } else {
            console.log(err);
        }
    });
});

router.get('/usuario/:id', (req, res) => {
    const { id } = req.params;
    db.query('SELECT * FROM usuario WHERE id_usuario = ?', [id], (err, rows, fields) => {
        if (!err) {
            if (rows[0] != null) {
                res.json(rows[0]);
            } else {
                res.json({status: 'Id de Usuario no encontrado'});
            }
        } else {
            console.log(err);
        }
    });
});

router.post('/usuario', (req, res) =>{
    const { nombre, email, user, password, estado } = req.body;
    const query = `
        SET @nombre = ?;
        SET @email = ?;
        SET @user = ?;
        SET @password = ?;
        SET @estado = ?;
        CALL sp_usuario(@nombre, @email, @user, @password, @estado);
    `;
    db.query(query, [nombre, email, user, password, estado ], (err, rows, fields) =>{
        if (!err) {
            res.json({status: 'Usuario Guardado'});
        } else {
            console.log(err);
        }
    });
});

router.delete('/usuario/:id', (req, res) => {
    const {id} = req.params;
    const query = 'DELETE FROM usuario WHERE id_usuario = ?';

    db.query(query, [id], (err, rows, fields) => {
        if (!err) {
            res.json({status: 'Usuario Eliminado'});
        } else {
            console.log(err);
        }
    });
});

router.post('/login', (req, res) =>{
    const { user, password } = req.body;
    const query = `
        SET @user = ?;
        SET @password = ?;
        CALL sp_login(@user, @password, @a, @b);
        SELECT @a AS id, @b AS usuario;
    `;
    db.query(query, [ user, password ], (err, rows, fields) =>{
        if (!err) {
            res.json(rows[3][0]);
            //console.log(rows[3][0].id);

        } else {
            console.log(err);
        }
    });
});



module.exports = router;