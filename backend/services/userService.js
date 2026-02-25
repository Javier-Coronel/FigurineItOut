const response = require("../controllers/response.js");
const initModels = require("../models/init-models.js").initModels;

const sequelize = require("../config/sequelize.js");
const { Op } = require("sequelize");

const models = initModels(sequelize);

const User = models.user;

class UserService {
  async signin() {
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
      //Eliminar la contraseña del objeto de respuesta
      delete user.dataValues.password;

      return res.status(200).json(response.exito(user, "Succesfull login"));
    } catch (err) {
      console.error(err);
      return res.status(500).json(response.error("Internal server error"));
    }
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
