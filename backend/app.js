const express = require("express");
const cors = require("cors");
const bodyParser = require("body-parser")
const UserRoute = require("./routes/user.routes");
const ToDoRoute = require('./routes/todo.router');
const app = express();

app.use(cors());
app.use(bodyParser.json())

app.use("/",UserRoute);
app.use("/",ToDoRoute);

module.exports = app;