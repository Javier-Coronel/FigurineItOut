const DataTypes = require("sequelize").DataTypes;
const _user = require("./user");
const _player = require("./player");

function initModels(sequelize) {
    const user = _user(sequelize, DataTypes);
    const player = _player(sequelize, DataTypes);
    
    //user.sync({ alter: true })
    //player.sync({ alter: true })
    return {
        user,
        player
    };
}
module.exports = initModels;
module.exports.initModels = initModels;
module.exports.default = initModels;