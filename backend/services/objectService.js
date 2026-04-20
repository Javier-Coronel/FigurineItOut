const response = require("../controllers/response.js");
const initModels = require("../models/init-models.js").initModels;

const sequelize = require("../config/sequelize.js");
//const { Op } = require("sequelize");
const config = require("../config/config");

const models = initModels(sequelize);

const Object = models.object;
const Party = models.party;
const Player = models.player;
const User = models.user;
const Moderator = models.moderator;

class ObjectService{
    async createObject(player, party, data, name) {
        console.log("asd")
        if(data.length == 0) return
        console.log("asd")
        player = User.findOne({where: { name: player.player }})
        console.log("asd")
        let nameInfo = [player.id_player, party, name, Date.now()].join("_")
        console.log(JSON.stringify({name: nameInfo, route: nameInfo, id_party: party, id_player: player.id_player}))
        await Object.create({name: nameInfo, route: nameInfo, id_party: party, id_player: player.id_player})
    }
}

module.exports = new ObjectService();
