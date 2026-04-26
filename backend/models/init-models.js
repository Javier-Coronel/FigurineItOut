const DataTypes = require("sequelize").DataTypes;
const _user = require("./user");
const _player = require("./player");
const _party = require("./party");
const _playedParty  = require("./playedParty")
const _object = require("./object")
const _moderator = require("./moderator")

function initModels(sequelize) {
  const user = _user(sequelize, DataTypes);
  const player = _player(sequelize, DataTypes);
  const party = _party(sequelize, DataTypes);
  const PlayedParty = _playedParty(sequelize,DataTypes);
  const object = _object(sequelize, DataTypes);
  const moderator = _moderator(sequelize, DataTypes);

  player.belongsToMany(party, {
    through: PlayedParty,
    foreignKey: "id_player",
  });

  party.belongsToMany(player, {
    through: PlayedParty,
    foreignKey: "id_party",
  });

  object.belongsTo(player, {foreignKey: "id_player"});
  player.hasMany(object, { foreignKey: "id_player", as: "object"});
  
  object.belongsTo(party, {foreignKey: "id_party"});
  party.hasMany(object, { foreignKey: "id_party", as: "object"});
  
  player.hasOne(user, { foreignKey: "id_user"})
  user.belongsTo(player, { foreignKey: "id_user", as: "player"})
  
  moderator.hasOne(user, { foreignKey: "id_user"})
  user.belongsTo(moderator, { foreignKey: "id_user", as: "moderator"})
  
  //user.sync({ alter: true })
  //player.sync({ alter: true })
  //party.sync({ alter: true })
  //moderator.sync({ alter: true })
  //PlayedParty.sync({ alter: true })
  //object.sync({ alter: true })
  return {
    user,
    player,
    party,
    PlayedParty,
    moderator,
    object,
  };
}
module.exports = initModels;
module.exports.initModels = initModels;
module.exports.default = initModels;
