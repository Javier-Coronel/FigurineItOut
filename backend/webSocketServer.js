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
 * * OnTimeRunOut: the timeout function that contains what will happen after no one could guess the object on time.
 * * RoundsLeft: the rounds that have left to finish the game, at start must be 10.
 * * List?: the custom list of wich the conceps to figure will come.
 */
//TODO if I have time left, add a minimun of 2 players for concepts to start appearing
const partys = new Map();
function Socket() {
  const port = process.env.WSPORT || 8090;
  const defaultTimer = 10 * 60 * 1000;
  const mainGuessList = [];

  function  read(data, arrayToPush){
      const parser = parse({
        delimiter: ",",
      });
      parser.on("readable", function () {
        let record;
        while ((record = parser.read()) !== null) {
          record.forEach((rec) => {
            arrayToPush.push(rec);
          });
        }
      });
      // Catch any error
      parser.on("error", function (err) {
        console.error(err.message);
      });
      parser.write(data);
      parser.end();
  }
  fs.readFile(
    "./public/Pictionary_Data_From_coffeecoders10.csv",
    "utf8",
    (err, data) => {
      if (err) {
        console.error(err);
        return;
      }
      read(data, mainGuessList)
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

  function newConcept(partyId) {
    let conceptList = partys.get(partyId).list
      ? partys.get(partyId).list
      : mainGuessList;
    partys.get(partyId).currentConcept =
      conceptList[Math.floor(Math.random() * conceptList.length)];
    partys.get(partyId).objectProgression = [];
    partys.get(partyId).currentCreator =
      partys.get(partyId).users[
        Math.floor(Math.random() * partys.get(partyId).users.length)
      ];
    partys.get(partyId).time = Date.now();
    partys.get(partyId).onTimeRunOut = setTimeout(() => {
      solvedConcept(partyId);
      newConcept(partyId);
    }, defaultTimer);
    partys.get(partyId).currentCreator.send(
      JSON.stringify({
        type: "beCreator",
        concept: partys.get(partyId).currentConcept,
        time: partys.get(partyId).time,
      }),
    );
    partys.get(partyId).users.forEach(function (client) {
      client.send(
        JSON.stringify({
          type: "timeLeft",
          time: partys.get(partyId).time,
        }),
      );
    });
  }
  function solvedConcept(partyId, solver = false) {
    let dataToSave = JSON.stringify(partys.get(partyId).objectProgression);
    //TODO save object
    
    let dataToSend = {
      type: "solved",
      concept: partys.get(partyId).currentConcept,
    };
    if (solver) dataToSend.by = solver;
    partys.get(partyId).users.forEach(function (client) {
      client.send(JSON.stringify(dataToSend));
    });
  }
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
          console.log(err.message)
          ws.close(1008, "An error ocured with the login data");
          return;
        }

        if (req.url.includes("create")) {
          let partyCreated = await partyController.createParty();
          if (partyCreated == -1) {
            ws.close(1008, "Unnable to create party, try again later");
            return;
          }
          partys.set(partyCreated, {
            users: [ws],
            currentCreator: ws,
            roundsLeft: 10,
          });
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
            partys.get(partyId).list = []
            read(data["custom"], partys.get(partyId).list)
          }
          newConcept(partyId);
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
            let dataToSend = {
              type: "partyStart",
              objectProgression: partys.get(partyId).objectProgression,
              partyId: partyId,
              time: partys.get(partyId).time,
            };
            if (partys.get(partyId).partyCode)
              dataToSend.partyCode = partys.get(partyId).partyCode;
            ws.send(JSON.stringify(dataToSend));
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
        switch (jsonData.type) {
          /**
           * comment: envia un comentario
           * editModel: modifica el modelo
           *
           */
          case "comment":
            if (jsonData.comment == partys.get(partyId).currentConcept) {
              clearTimeout(partys.get(partyId).onTimeRunOut)
              solvedConcept(partyId, player); 
              newConcept(partyId);
            } else {
              clients.forEach(function (client) {
                if (client != ws && client.readyState === WebSocket.OPEN)
                  client.send(
                    JSON.stringify({
                      type: "comment",
                      text: jsonData.comment,
                      player: player,
                    }),
                  );
              });
            }

            break;
          case "editModel":
            if (partys.get(partyId).currentCreator == ws) {
              partys.get(partyId).objectProgression.push(jsonData.change);
              clients.forEach(function (client) {
                if (client != ws && client.readyState === WebSocket.OPEN) {
                  client.send(jsonData);
                }
              });
            }
            break;
          default:
            break;
        }
      
    });

    ws.on("close", function close(code, reason) {
      if (partyId != -1) {
        partys
          .get(partyId)
          .users.splice(partys.get(partyId).users.indexOf(ws), 1);
        if (partys.get(partyId)?.users.length == 0) {
          clearTimeout(partys.get(partyId).onTimeRunOut)
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
