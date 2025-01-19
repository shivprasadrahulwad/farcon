const express = require("express");
const mongoose = require("mongoose");
const authRouter = require("./servers/routes/auth");
const userRouter = require("./servers/routes/user"); 


const PORT = 4000;
const app = express();

const DB = "mongodb+srv://shivprasadrahulwad:Rshivam1234@cluster.tegl0.mongodb.net/?retryWrites=true&w=majority&appName=Cluster"


app.use(express.json());
app.use(authRouter);
app.use(userRouter);



mongoose.connect(DB).then(() => {
    console.log("Connection successful");
}).catch((e) => {
    console.log(e);
});

app.listen(PORT, "0.0.0.0", () => {
    console.log(`Connected Port ${PORT}`);
});



