const { WebSocketServer } = require("ws");
const { WebSocket } = require("ws");

function Socket() {
  const port = process.env.WSPORT || 8090;

  const wss = new WebSocketServer({ port: port });

  /**
   * Each item will contain:
   * * RoomId: id for the room.
   * * RoomCode?: code to enter the room.
   * * Users: the websockets to wich the data will be sended to.
   */
  const rooms = [];

  wss.on("connection", function connection(ws, req) {
    let partyId = -1 
    
    console.log("started testing");
    if (req.url.includes("create")) {
      rooms.push({ roomId: rooms.length, users: [ws] });
      if (req.url.includes("private")) {
        // we will need to send the key later
        console.log("create private room");
      }
      if (req.url.includes("custom")) {
        // we will add custom sets later
      }
      partyId = rooms.length-1
    } else if (req.url.includes("join")) {
      let data = {};
      console.log(req.url)
      req.url
        .replace("/path?", "")
        .split("&")
        .forEach((i) => (data[req.url.split("=")[0]] = req.url.split("=")[1]));
        console.log(data)
      if (rooms[parseInt(data["join"])]) {
        rooms[parseInt(data["join"])].users.append(ws);
        console.log("joined on " + data["join"]);
        partyId = parseInt(data["join"])
        console.log(rooms)
      }
    } else {
      console.error("client not stated as creating or joining");
      return;
    }
    ws.on("open", function open() {});
    ws.on("error", console.error);

    ws.on("message", function message(data, isBinary) {
      const clients = rooms[partyId].users
      /*wss.clients*/
      clients.forEach(function each(client) {
        if (client.readyState === WebSocket.OPEN) {
          client.send(data, { binary: isBinary });
        }
      });
    });

    ws.on("close", function close(code, reason) {
      console.log(code);
    });
    ws.send("finished");
  });
}
module.exports.run = Socket;
