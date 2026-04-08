const { WebSocketServer } = require("ws");
const { WebSocket } = require("ws");
const jwt = require("jsonwebtoken");
const config = require("./config/config");
const fs = require("node:fs");
const { parse } = require("csv-parse");
const partyController = require("./controllers/partyController");
const userController = require("./controllers/userController");
/**
 * Each key will be the id of a room
 * Each item will contain:
 * * RoomCode?: keycode to enter the room.
 * * Users: the websockets to wich the data will be sended to.
 * * CurrentCreator: the websocket of the player thats currently modeling an object.
 * * CurrentConcept: the current concept thats currently being modeled.
 * * ObjectProgression: the steps that the current player modeling has done.
 * * Time: the time left for the current player.
 * * RoundsLeft: the rounds that have left to finish the game, at start must be 10.
 * * List?: the custom list of wich the conceps to figure will come.
 */
//TODO if I have time left, add a minimun of 2 players for concepts to start appearing
const partys = new Map();
function Socket() {
  const port = process.env.WSPORT || 8090;
  const mainGuessList = [];

  fs.readFile(
    "./public/Pictionary_Data_From_coffeecoders10.csv",
    "utf8",
    (err, data) => {
      if (err) {
        console.error(err);
        return;
      }
      const parser = parse({
        delimiter: ",",
      });
      parser.on("readable", function () {
        let record;
        while ((record = parser.read()) !== null) {
          record.forEach((rec) => {
            mainGuessList.push(rec);
          });
        }
      });
      // Catch any error
      parser.on("error", function (err) {
        console.error(err.message);
      });
      parser.write(data);
      parser.end();
    },
  );
  const codeCharacters = [];
  for (let i = 0; i < 10; i++) {
    codeCharacters[i] = i;
  }
  for (let i = 0; i < 26; i++) {
    codeCharacters[i + 10] = String.fromCharCode(65 + i);
  }
  const wss = new WebSocketServer({ port: port });

  wss.on("connection", async function connection(ws, req) {
    let partyId = -1;
    let player = "";

    if (req.url.includes("user")) {
      let data = {};
      req.url
        .replace("/path?", "")
        .split("&")
        .forEach(
          (i) =>
            (data[i.split("=")[0]] = i.split("=")[1] ? i.split("=")[1] : ""),
        );
      jwt.verify(data["user"], config.secretKey, async (err, decoded) => {
        if (err) {
          ws.close(1008, "An error ocured with the login data");
          return;
        }

        if (req.url.includes("create")) {
          let partyCreated = await partyController.createParty();
          if (partyCreated == -1) {
            ws.close(1008, "Unnable to create party, try again later");
            return;
          }
          partys.set(partyCreated, { users: [ws], currentCreator: ws, roundsLeft:10, });
          partyId = partyCreated;
          player = decoded.name;
          partyController.addUserToParty(decoded, partyId);
          let dataToSend = { type: "partyStart", partyId: partyId };
          if (req.url.includes("private")) {
            let code = "";
            for (let i = 0; i < 6; i++) {
              code +=
                codeCharacters[
                  Math.floor(Math.random() * codeCharacters.length)
                ];
            }
            partys.get(partyId).partyCode = code;
            dataToSend.partyCode = code;
          }
          if (req.url.includes("custom")) {
            // we will add custom sets later
          }
          let conceptList = (partys.get(partyId).list?partys.get(partyId).list:mainGuessList)
          partys.get(partyId).currentConcept = conceptList[Math.floor(Math.random() * conceptList.length)];
          ws.send(JSON.stringify(dataToSend));
        } else if (data["join"]) {
          if (partys.get(Number.parseInt(data["join"]))) {
            if (partys.get(Number.parseInt(data["join"])).partyCode) {
              if (
                !data["code"] ||
                partys.get(Number.parseInt(data["join"])).partyCode !=
                  data["code"]
              ) {
                ws.close(1008, "Not gived correct password");
                return;
              }
            }
            partys.get(Number.parseInt(data["join"])).users.push(ws);
            partyId = parseInt(data["join"]);
            player = decoded.name;
            partyController.addUserToParty(decoded, partyId);
          }
        } else {
          console.error("client not stated as creating or joining");
          ws.close(1008, "Not gived required data");
          return;
        }
      });
    } else {
      ws.close(1008, "Not logged or not given login data");
      return;
    }
    ws.on("open", function open() {});
    ws.on("error", console.error);

    ws.on("message", function message(data, isBinary) {
      const clients = partys.get(partyId).users;
      let jsonData = JSON.parse(data.toString());
      clients.forEach(function (client) {
        if (client.readyState === WebSocket.OPEN) {
          switch (jsonData.type) {
            /** 
             * comment: envia un comentario
             * editModel: modifica el modelo
             * 
            */
            case "comment":
              if (jsonData.comment == partys.get(partyId).CurrentConcept) {
                client.send(
                  JSON.stringify({
                    type: "solved",
                    by: player,
                    concept: partys.get(partyId).CurrentConcept,
                  }),
                );
              } else {
                if (client != ws)
                  client.send(
                    JSON.stringify({
                      type: "comment",
                      text: jsonData.comment,
                      player: player,
                    }),
                  );
              }

              break;
            case "editModel":
              break;
            default:
              break;
          }
        }
      });
    });

    ws.on("close", function close(code, reason) {
      if (partyId!=-1) {
        console.log(partys.get(partyId));
        partys
          .get(partyId)
          .users.splice(partys.get(partyId).users.indexOf(ws), 1);
        if (partys.get(partyId)?.users.length == 0) {
          partys.delete(partyId);
        }
      }
      console.log("Socket closed with reason " + reason);
    });
  });
}
function getParties(req, res) {
  let parties = [];
  for (const i of partys.keys()) {
    parties.push(i);
  }
  res.status(200).json(parties);
}
module.exports.partys = getParties;
module.exports.run = Socket;
