const Sequelize = require("sequelize");
module.exports = function (sequelize, DataTypes) {
  return sequelize.define(
    "playedparty",
    {
      id_played: {
        autoIncrement: true,
        type: DataTypes.INTEGER,
        allowNull: false,
        primaryKey: true,
      },
      id_player: {
        type: DataTypes.INTEGER,
        allowNull: false,
      },
      id_party: {
        type: DataTypes.INTEGER,
        allowNull: false,
      },
    },
    {
      sequelize,
      tableName: "playedparty",
      timestamps: false,
      indexes: [
        {
          name: "PRIMARY",
          unique: true,
          using: "BTREE",
          fields: [{ name: "id_played" }],
        },
        {
          name: "id_player",
          using: "BTREE",
          fields: [{ name: "id_player" }],
        },
        {
          name: "id_party",
          using: "BTREE",
          fields: [{ name: "id_party" }],
        },
      ],
    },
  );
};
