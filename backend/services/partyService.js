const response = require("../controllers/response.js");
const initModels = require("../models/init-models.js").initModels;

const sequelize = require("../config/sequelize.js");
const { Op } = require("sequelize");

const models = initModels(sequelize);

const Player = models.player;
const Party = models.party;
const PlayedParty = models.PlayedParty;

class PartyService {
  async createParty() {
    try {
      const partyResult = await Party.create();
      return partyResult.id_party;
    } catch (error) {
      console.error("Error al empezar una partida:" + error);
      return -1;
    }
  }
  async addUserToParty(user, party){
    let check = await PlayedParty.findAll({where: {id_player: user.sub, id_party: party}})
    if(check.length!=0) return 
    await PlayedParty.create({id_player: user.sub, id_party: party})
  }
}

module.exports = new PartyService();
