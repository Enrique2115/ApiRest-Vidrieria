const {Router} = require('express');
const router = Router();

router.get('/', (req, res) => {
    const data = {
        "name": "Luis Enrique",
        "telef": "Joven de 20 años"
    };
    res.json(data);
});

module.exports = router;