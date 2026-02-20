const express = require("express");
const cors = require("cors");
const bodyParser = require("body-parser")

const UserRoute = require("./routes/user.routes");
const ToDoRoute = require('./routes/todo.router');
const ohRoute = require('./routes/oh.router');
const maquinaRoute = require('./routes/maquina.router');
const usuarioRoute = require('./routes/usuario.router');
const linkRoute = require('./routes/link.router');

const app = express();

app.use(cors());
app.use(bodyParser.json())

app.use("/",UserRoute);
app.use("/",ToDoRoute);

module.exports = app;