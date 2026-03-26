const { WebSocketServer } = require("ws");
const { WebSocket } = require("ws");
const jwt = require("jsonwebtoken");
const config = require("./config/config");
const fs = require("node:fs");
const { parse } = require("csv-parse");
const partyController = require("./controllers/partyController");
const userController = require("./controllers/userController");

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
  console.log(codeCharacters);
  const wss = new WebSocketServer({ port: port });

  /**
   * Each item will contain:
   * * RoomCode?: keycode to enter the room.
   * * Users: the websockets to wich the data will be sended to.
   * * CurrentCreator: the websocket of the player thats currently modeling an object.
   * * CurrentConcept: the current concept thats currently being modeled.
   * * ObjectProgression: the steps that the current player modeling has done.
   * * Time: the time left for the current player.
   * * List?: the custom list of wich the conceps to figure will come.
   */
  const partys = new Map();

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
        if (data["user"]) {
          ws.close(1008, "An error ocured with the login data");
          return;
        }

        if (req.url.includes("create")) {
          let partyCreated = await partyController.createParty();
          if (partyCreated == -1) {
            ws.close(1008, "Unnable to create party, try again later");
            return;
          }

          partys.set(partyCreated, { users: [ws], CurrentCreator: ws });
          partyId = partyCreated;
          player = decoded.name;
          partyController.addUserToParty(decoded, partyId);
          let dataToSend = { partyId: partyId };
          if (req.url.includes("private")) {
            let code = "";
            for (let i = 0; i < 6; i++) {
              code +=
                codeCharacters[
                  Math.floor(Math.random() * codeCharacters.length)
                ];
            }
            dataToSend.partyCode = code;
          }
          if (req.url.includes("custom")) {
            // we will add custom sets later
          }
          ws.send(JSON.stringify(dataToSend));
        } else if (data["join"]) {
          if (partys[Number.parseInt(data["join"])]) {
            if (partys[Number.parseInt(data["join"])].partyCode) {
              if (
                !data["code"] ||
                partys[Number.parseInt(data["join"])].partyCode != data["code"]
              ) {
                ws.close(1008, "Not gived correct password");
                return;
              }
            }
            partys[Number.parseInt(data["join"])].users.push(ws);
            partyId = parseInt(data["join"]);
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
      const clients = partys[partyId].users;
      let jsonData = JSON.stringify(data);

      clients.forEach(function each(client) {
        if (client.readyState === WebSocket.OPEN) {
          switch (jsonData.type) {
            case "comment":
              if (jsonData.comment == partys[partyId].CurrentConcept) {
                client.send(
                  JSON.stringify({ type: "solved", by: player, concept: partys[partyId].CurrentConcept }),
                );
              } else {
                client.send(
                  JSON.stringify({ type: "comment", text: jsonData.text }),
                );
              }

              break;
            case "editModel":
              break;
            default:
              break;
          }

          client.send(data, { binary: isBinary });
        }
      });
    });

    ws.on("close", function close(code, reason) {
      partys[partyId].users.splice(partys[partyId].users.indexOf(ws));
      if (partys[partyId].users.length == 0) {
        partys.delete(partyId);
      }
      console.log("Socket closed with reason " + reason);
    });
    ws.send(partyId);
  });
}

module.exports.run = Socket;
