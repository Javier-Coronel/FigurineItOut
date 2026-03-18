const DataTypes = require("sequelize").DataTypes;
const _user = require("./user");
const _player = require("./player");
const _party = require("./party");
const _playedParty  = require("./playedParty")

function initModels(sequelize) {
  const user = _user(sequelize, DataTypes);
  const player = _player(sequelize, DataTypes);
  const party = _party(sequelize, DataTypes);
  const PlayedParty = _playedParty(sequelize,DataTypes);
  
  player.belongsToMany(party, {
    through: PlayedParty,
    foreignKey: "id_player",
  });

  party.belongsToMany(player, {
    through: PlayedParty,
    foreignKey: "id_party",
  });
  //user.sync({ alter: true })
  //player.sync({ alter: true })
  //party.sync({ alter: true })
  return {
    user,
    player,
    party,
    PlayedParty,
  };
}
module.exports = initModels;
module.exports.initModels = initModels;
module.exports.default = initModels;
