const express = require("express");
const path = require("path");
const cors = require("cors");

const userRoutes = require("./routes/userRoutes");
const playerRoutes = require("./routes/playerRoutes");

const app = express();
const port = process.env.PORT || 3000;

app.use(express.json());
app.use(cors());
app.use("/api/users", userRoutes);
app.use("/api/players", playerRoutes);

if (process.env.NODE_ENV !== "test") {
  app.listen(port, () => {
    console.log("Servidor activo en el puerto ", port);
  });
}
module.exports = app;