const Sequelize = require("sequelize");
module.exports = function (sequelize, DataTypes) {
  return sequelize.define(
    "object",
    {
      id_object: {
        autoIncrement: true,
        type: DataTypes.INTEGER,
        allowNull: false,
        primaryKey: true,
      },
      name: {
        type: DataTypes.STRING(250),
        allowNull: false,
      },
      route: {
        type: DataTypes.STRING(250),
        allowNull: false,
      },
      creation_date: {
        type: DataTypes.DATE,
        allowNull: true,
        defaultValue: DataTypes.NOW,
      },
      id_party: {
        type: DataTypes.INTEGER,
        allowNull: false,
      },
      id_player: {
        type: DataTypes.INTEGER,
        allowNull: false,
      },
      id_moderator: {
        type: DataTypes.INTEGER,
        allowNull: true,
      },
    },
    {
      sequelize,
      tableName: "object",
      timestamps: false,
      indexes: [
        {
          name: "PRIMARY",
          unique: true,
          using: "BTREE",
          fields: [{ name: "id_object" }],
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
        {
          name: "id_moderator",
          using: "BTREE",
          fields: [{ name: "id_moderator" }],
        },
      ],
    },

  );
};