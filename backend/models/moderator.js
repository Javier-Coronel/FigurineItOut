const Sequelize = require("sequelize");
module.exports = function (sequelize, DataTypes) {
  return sequelize.define(
    "moderator",
    {
      id_moderator: {
        autoIncrement: true,
        type: DataTypes.INTEGER,
        allowNull: false,
        primaryKey: true,
      },
      id_user: {
        type: DataTypes.INTEGER,
        allowNull: false,
        primaryKey: true,
        unique: "user",
      },
    },
    {
      sequelize,
      tableName: "moderator",
      timestamps: false,
      indexes: [
        {
          name: "PRIMARY",
          unique: true,
          using: "BTREE",
          fields: [{ name: "id_moderator" }],
        },
        {
          name: "id_user",
          unique: true,
          using: "BTREE",
          fields: [{ name: "id_user" }],
        },
      ],
    },
  );
};
