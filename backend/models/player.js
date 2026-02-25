const Sequelize = require("sequelize");
module.exports = function (sequelize, DataTypes) {
  return sequelize.define(
    "player",
    {
      id_player: {
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
      bannedby: {
        type: DataTypes.INTEGER,
        allowNull: true,
      }
    },
    {
      sequelize,
      tableName: "player",
      timestamps: false,
      indexes: [
        {
          name: "PRIMARY",
          unique: true,
          using: "BTREE",
          fields: [{ name: "id_player" }],
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
