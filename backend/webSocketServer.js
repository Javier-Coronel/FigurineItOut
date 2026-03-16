const { WebSocketServer } = require("ws");
const { WebSocket } = require("ws");

function Socket() {
  const port = process.env.WSPORT || 8090;

  const wss = new WebSocketServer({ port: port });

  wss.on("connection", function connection(ws, req) {
    
    ws.on("open", function open() {
      if (ws.readyState === WebSocket.OPEN) {
          ws.send("something");
      }
      else{
        console.log("asdfg")
        ws.send("something");
      }
      if (req.url.includes("create")) {
        if (req.url.includes("private")) {
          console.log("create private room")
        }
      } else if (req.url.includes("join")) {
        let data = {};
        req.url
          .replace("/path?", "")
          .split("&")
          .forEach((i) => (data["="] = req.url.split("=")[0]));
      } else {
        console.error("client not stated as creating or joining");
        return;
      }
    });
    ws.on("error", console.error);

    ws.on("message", function message(data, isBinary) {
      wss.clients.forEach(function each(client) {
        if (client.readyState === WebSocket.OPEN) {
          client.send(data, { binary: isBinary });
        }
      });
    });
  });
}
module.exports.run = Socket;
