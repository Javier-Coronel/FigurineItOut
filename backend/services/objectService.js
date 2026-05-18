const response = require("../controllers/response.js");
const initModels = require("../models/init-models.js").initModels;

const sequelize = require("../config/sequelize.js");
const { Op } = require("sequelize");
const config = require("../config/config");

const models = initModels(sequelize);

const Object = models.object;
const Party = models.party;
const Player = models.player;
const User = models.user;
const Moderator = models.moderator;
const PlayedParty = models.PlayedParty;
const fs = require("node:fs");
const path = "./public/models/";
const requestLimit = 15;
class ObjectService {
  async createObject(player, party, data, name) {
    if (data.length == 0) return;
    let user = await User.findOne({ where: { name: player } });
    player = await Player.findOne({ where: { id_user: user.id_user } });
    let nameInfo = [name, user.name, party, Date.now()].join("_");
    let route = path + nameInfo;
    
    try {
      await fs.writeFile(route, JSON.stringify(data, null, 2), (err) => {
        if (err) throw err;
        console.log("The file has been saved!");
      });
      await Object.create({
        name: nameInfo,
        route: route,
        id_party: party,
        id_player: player.id_player,
      });
    } catch (error) {
      console.log("Error saving the object", error);
    }
  }
  async objectsReader(values, res) {
    let result = [];
    let tried = 0
    for (let index = 0; index < values.length; index++) {
      const element = values[index];
      await fs.readFile(element.route, "utf8", async (err, data) => {
        tried++
        if (err) {
          if(tried == values.length){
            res.status(200).json(response.exito(result, "Objects obtained"));
          }
          throw err;
        }
        
        let value = { data: JSON.parse(data), name: element.name, room: element.party.id_party, userName: element.player.user.name };
        result.push(value);
        if (result.length == values.length) {
          res.status(200).json(response.exito(result, "Objects obtained"));
        }
      });
    }
  }
  async getObjects(page, res) {
    let values = await Object.findAll({
      offset: page * requestLimit,
      limit: requestLimit,
      include:[{
          model: Player,
          as: 'player',
          include:[{
            model: User,
            as: 'user'
          }]
          },
        {
            model: Party,
            as: 'party'
          }]
    });
    await this.objectsReader(values, res);
  }
  async getBannedObjects(page, res) {
    let values = await Object.findAll({
      where: { id_moderator: { [Op.not]: null } },
      offset: page * requestLimit,
      limit: requestLimit,
      include:[{
          model: Player,
          as: 'player',
          include:[{
            model: User,
            as: 'user'
          }]
          },
        {
            model: Party,
            as: 'party'
          }]
    });
    await this.objectsReader(values, res);
  }
  async getPlayerObjects(page, player, res) {
    let values = await Object.findAll({
      where: { id_player: player },
      offset: page * requestLimit,
      limit: requestLimit,
      include:[{
          model: Player,
          as: 'player',
          include:[{
            model: User,
            as: 'user'
          }]
          },
        {
            model: Party,
            as: 'party'
          }]
    });
    await this.objectsReader(values, res);
  }
  async getPartyObjects(page, party, res) {
    let values = await Object.findAll({
      where: { id_party: party },
      offset: page * requestLimit,
      limit: requestLimit,
      include:[{
          model: Player,
          as: 'player',
          include:[{
            model: User,
            as: 'user'
          }]
          },
        {
            model: Party,
            as: 'party'
          }]
    });
    await this.objectsReader(values, res);
  }
  async getAvalibleObjects(page, player, res) {
    let parties = await PlayedParty.findAll({attributes:["id_party"], where:{id_player: player}})
    for (let index = 0; index < parties.length; index++) {
      parties[index] = parties[index].id_party;
    }
    let values = await Object.findAll({
      where: { id_party: parties },
      offset: page * requestLimit,
      limit: requestLimit,
      include:[{
          model: Player,
          as: 'player',
          include:[{
            model: User,
            as: 'user'
          }]
          },
        {
            model: Party,
            as: 'party'
          }]
    });
    await this.objectsReader(values, res);
  }
  async getObject(id, res) {
    let value = await Object.findByPk(id,{include:[{
          model: Player,
          as: 'player',
          include:[{
            model: User,
            as: 'user'
          }]
          },
        {
            model: Party,
            as: 'party'
          }]});
    fs.readFile(value.route, "utf8", (err, data) => {
      if (err) throw err;
      res
        .status(200)
        .json(
          response.exito(
            { data: JSON.parse(data), name: value.name },
            "Objects obtained",
          ),
        );
    });
  }
}

module.exports = new ObjectService();
