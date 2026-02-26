// Importar libreria para manejo de ficheros de configuración dependiendo de la variable de entorno NODE_ENV
require("dotenv").config({
  path: `.env.${process.env.NODE_ENV || "development"}`,
});

module.exports = {
  port: process.env.PORT || 3000,
  db: {
    host: process.env.DB_HOST || "localhost",
    user: process.env.DB_USER || "root",
    password: process.env.DB_PASSWORD || "test",
    name: process.env.DB_NAME || "figurineItOut ",
    port: process.env.DB_PORT || 3306,
  },
  secretKey: process.env.SECRET_KEY || "default_secret",
};

console.log("DBNAME:",process.env.DB_NAME);
console.log("DBHOST:",process.env.DB_HOST);
console.log("DBUSER:",process.env.DB_USER);
console.log("DBPORT:",process.env.DB_PORT);
console.log("NODE_ENV:",process.env.NODE_ENV);
