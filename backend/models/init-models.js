const DataTypes = require("sequelize").DataTypes;
const _user = require("./user");
const _player = require("./player");

function initModels(sequelize) {
    const user = _user(sequelize, DataTypes);
    const player = _player(sequelize, DataTypes);
    //proveedor.belongsTo(empresa, {foreignKey: "empresaIdEmpresa"});
    //empresa.hasMany(proveedor, { as: "proveedor"});
    
    return {
        user,
        player
    };
}
module.exports = initModels;
module.exports.initModels = initModels;
module.exports.default = initModels;