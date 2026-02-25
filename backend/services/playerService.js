const response = require("../controllers/response.js");
const initModels = require("../models/init-models.js").initModels;

const sequelize = require("../config/sequelize.js");
const { Op } = require("sequelize");

const models = initModels(sequelize);

const Player = models.player;

class PlayerService {
    async createPlayer(player){
        const result = await Player.create(player);
        return result;
    }
    async updateUserBan(id_player, mod){

    }
}

module.exports = new PlayerService();
