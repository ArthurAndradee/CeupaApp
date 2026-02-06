const app = require("./app");
// const UserModel = require('./models/user.model')
const db = require('./config/db')

const port = 5000;

app.get('/',(req,res)=>{
    res.send("Hello World")
})

app.listen(port,()=>{
    console.log(`Server Listening on Port http://localhost:${port}`);
})