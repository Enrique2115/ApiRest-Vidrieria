const express = require("express");
const mysql = require("mysql");
const morgan = require("morgan");
const pool = require("./settings/db");

const app = express();

//Settings
const port = process.env.PORT || 3000;
app.set("json spaces", 2);

//middleware
app.use(morgan("dev"));
app.use(express.json());

app.use(require("./routes/info"));
app.use(require("./routes/proveedor"));
app.use(require("./routes/producto"));
app.use(require("./routes/tipo_comprobante"));
app.use(require("./routes/moneda"));
app.use(require("./routes/comprobante"));
app.use(require("./routes/cliente"));
app.use(require("./routes/usuario"));
app.use(require("./routes/categoria"));

app.listen(port, () => console.log(`Servidor corriendo en el puerto  ${port}`));
