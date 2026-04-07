const response = require("../controllers/response.js");
const initModels = require("../models/init-models.js").initModels;

const sequelize = require("../config/sequelize.js");
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const { Op } = require("sequelize");
const config = require("../config/config");

const models = initModels(sequelize);

const User = models.user;

class UserService {
  async signin(req, res) {
    const { name, password } = req.body;

    try {
      const user = await User.findOne({ where: { name } });
      if (!user) {
        return res
          .status(401)
          .json(response.error("User not found"));
      }

      // Verificar la contraseña
      const validPassword = await bcrypt.compare(password, user.password);
      if (!validPassword) {
        return res
          .status(401)
          .json(response.error("Wrong password"));
      }
      // Generar el token JWT
      const token = jwt.sign(
        {
          "sub": user.id_user,
          "name": user.name,
          "email": user.email,
        },
       config.secretKey,
        { expiresIn: "7d" }
      );
      // Añadimos el token a la respuesta, se tratara en el cliente
      user.dataValues.cookie = {
        token: token,
        httpOnly: true, // Evita que JavaScript acceda a la cookie
        secure: process.env.NODE_ENV === 'production', // Solo en HTTPS en producción
        sameSite: process.env.NODE_ENV === 'production' ? "strict" : 'Lax', // Protección CSRF // Lax en desarrollo
        maxAge: 1000 /*milisegundos*/ * 60 /*segundos*/ * 60 /*minutos*/ * 24 /*horas*/ * 7 /*dias*/, // 7 dias en milisegundos
        // domain: "localhost",
      }

      //Eliminar la contraseña del objeto de respuesta
      delete user.dataValues.password;

      res.cookie("token", token, {
        httpOnly: true, // Evita que JavaScript acceda a la cookie
        secure: process.env.NODE_ENV === 'production', // Solo en HTTPS en producción
        sameSite: process.env.NODE_ENV === 'production' ? "strict" : 'Lax', // Protección CSRF // Lax en desarrollo
        maxAge: 3600000, // 1 hora en milisegundos
        // domain: "localhost",
      });

      return res.status(200).json(response.exito(user, "Succesfull login"));
    } catch (err) {
      console.error(err);
      return res.status(500).json(response.error("Internal server error"));
    }
  }
  async signout(req, res) {
    res.clearCookie('token', { httpOnly: true, secure: process.env.NODE_ENV === 'production' });
    res.status(200).json(response.exito( null, "Succesfull logout"));
  }
  async getAllUsers() {
    const result = await User.findAll();
    return result;
  }
  async getUserById(id_user) {
    const result = await User.findByPk(id_user);
    return result;
  }
  async updatePassword(id, user) {}
  async deleteUser(id_user) {
    const numFilas = await User.destroy({
      where: { id_user: id_user },
    });
    return numFilas;
  }
}

module.exports = new UserService();
