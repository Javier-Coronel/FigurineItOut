const express = require("express");
const path = require("path");
const cors = require("cors");

const userRoutes = require("./routes/userRoutes");
const playerRoutes = require("./routes/playerRoutes");
const ws = require("./webSocketServer");

const app = express();
const port = process.env.PORT || 3000;

app.use(express.json());
app.use(cors());
app.use("/api/users", userRoutes);
app.use("/api/players", playerRoutes);
app.get("/api/currentParties", (req,res)=>{
  console.log(ws.partys.keys())
  let parties = []
  for (const i of ws.partys.keys()){
    parties.push(i)
  }
  res.status(200).json(parties)
})

if (process.env.NODE_ENV !== "test") {
  app.listen(port, () => {
    console.log("Servidor activo en el puerto ", port);
  });
}
ws.run()
module.exports = app;