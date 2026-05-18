const response = require("../controllers/response.js");
const initModels = require("../models/init-models.js").initModels;

const sequelize = require("../config/sequelize.js");
const bcrypt = require("bcrypt");
const { Op } = require("sequelize");

const models = initModels(sequelize);

const Player = models.player;
const User = models.user

class PlayerService {
  async createPlayer(player, res) {
    try {
      // Validar si todos los campos fueron proporcionados
      if (player == undefined || !player.name || !player.password) {
        return res
          .status(400)
          .json(response.error("Faltan campos por informar"));
      }

      // Verificar si el usuario ya existe
      const existingUser = await User.findOne({ where: {name: player.name} });
      if (existingUser) {
        return res
          .status(400)
          .json(
            response.error(
              "Ya existe un usuario con ese correo electrónico o nombre.",
            ),
          );
      }
      player.password = await bcrypt.hash(player.password, 10);

      const userResult = await User.create(player);

      const playerResult = await Player.create({id_user: userResult.dataValues.id_user});

      // Responder con éxito
      delete userResult.dataValues.password; // Eliminar la contraseña del objeto de respuesta
      userResult.dataValues.id_player = playerResult.dataValues.id_player
      userResult.dataValues.bannedby = playerResult.dataValues.bannedby
      res
        .status(201)
        .json(response.exito(userResult, "Usuario registrado exitosamente"));
    } catch (error) {
      console.error("Error al registrar el usuario:" + error);
      res
        .status(500)
        .json(
          response.error(
            "Error al registrar el usuario, intenta nuevamente",
          ),
        );
    }
  }
  async updateUserBan(id_player, mod) {}
}

module.exports = new PlayerService();
