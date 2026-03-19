extends Node

#region APIRest part

static var baseURL: String = "http://localhost"

static var apiRestPort: String = ":3000/api/"

func request(functionToCall: Callable, type: HTTPClient.Method, rute: String, body: String) -> void:
	var newRequest = HTTPRequestSimplifier.new()
	newRequest.functionToCall = functionToCall
	add_child(newRequest)
	newRequest.try_request(type, baseURL+apiRestPort+rute, body)
	pass

#endregion

#region WebSocket part

var socket = WebSocketPeer.new()
@export var webSocketPort = ":8090"
func createRoom(private: bool = false, custom: String = ""):
	var info = "/path?create" + ("&private" if private else "") + (("&custom=" + custom) if custom!="" else "")
	socket.connect_to_url(baseURL+webSocketPort+info)

func joinRoom(id: int, code: String = ""):
	var info = "/path?join=" + str(id) + (("&code="+code) if code != "" else "")
	socket.connect_to_url(baseURL+webSocketPort+info)

func sendData(data, binary: bool = false):
	if (binary): socket.send(data)
	else: socket.send_text(data)

var time: float = 0
var step: float = 0.25
func _process(delta):
	time += delta
	if socket.get_requested_url() != "" && time>step:
		time = 0
		socket.poll()
		var state = socket.get_ready_state()
		if state == WebSocketPeer.STATE_OPEN:
			while socket.get_available_packet_count():
				var curPacket = socket.get_packet()
				print("Packet: ", curPacket)
				
		elif state == WebSocketPeer.STATE_CONNECTING:
			while socket.get_available_packet_count():
				print("Packet: ", socket.get_packet())
		elif state == WebSocketPeer.STATE_CLOSING:
			# Keep polling to achieve proper close.
			pass
		elif state == WebSocketPeer.STATE_CLOSED:
			var code = socket.get_close_code()
			var reason = socket.get_close_reason()
			print("WebSocket closed with code: %d, reason %s. Clean: %s" % [code, reason, code != -1])
			set_process(false) # Stop processing.
#endregion
