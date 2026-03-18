const { WebSocketServer } = require("ws");
const { WebSocket } = require("ws");
const jwt = require("jsonwebtoken");
const config = require("./config/config");
const partyController = require("./controllers/partyController");

function Socket() {
  const port = process.env.WSPORT || 8090;

  const wss = new WebSocketServer({ port: port });

  /**
   * Each item will contain:
   * * RoomCode?: keycode to enter the room.
   * * Users: the websockets to wich the data will be sended to.
   *
   */
  const partys = new Map();

  wss.on("connection", async function connection(ws, req) {
    let partyId = -1;
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
        if (req.url.includes("create")) {
          let partyCreated = await partyController.createParty();
          if ((partyCreated = -1)) partys.set(partyCreated, { users: [ws] });
          partyId = partyCreated;
          if (req.url.includes("private")) {
            // we will need to send the key later
          }
          if (req.url.includes("custom")) {
            // we will add custom sets later
          }
        } else if (data["join"]) {
          if (partys[Number.parseInt(data["join"])]) {
            partys[Number.parseInt(data["join"])].users.push(ws);
            partyId = parseInt(data["join"]);
          }
        } else {
          console.error("client not stated as creating or joining");
          return;
        }
      });
    }
    ws.on("open", function open() {});
    ws.on("error", console.error);

    ws.on("message", function message(data, isBinary) {
      const clients = partys[partyId].users;

      clients.forEach(function each(client) {
        if (client.readyState === WebSocket.OPEN) {
          client.send(data, { binary: isBinary });
        }
      });
    });

    ws.on("close", function close(code, reason) {
      console.log(code);
    });
    ws.send(partyId);
  });
}
module.exports.run = Socket;
