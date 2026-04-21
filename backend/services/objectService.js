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
const fs = require("node:fs");
const path = "./public/models/"
class ObjectService{
    async createObject(player, party, data, name) {
        if(data.length == 0) return
        let user = await User.findOne({where: { name: player }})
        player = await Player.findOne({where: { id_user: user.id_user}})
        let nameInfo = [name, user.name, party, Date.now()].join("_")
        let route = path+nameInfo
        console.log(JSON.stringify({name: nameInfo, route: route, id_party: party, id_player: player.id_player}))
        try {
            await fs.writeFile(route, JSON.stringify(data, null, 2), (err) => {
                if (err) throw err;
                console.log('The file has been saved!');});
            await Object.create({name: nameInfo, route: route, id_party: party, id_player: player.id_player})
        }catch(error){
            console.log("Error saving the object", error)
        }
    }
    
    async getObjects(){

    }
}

module.exports = new ObjectService();
