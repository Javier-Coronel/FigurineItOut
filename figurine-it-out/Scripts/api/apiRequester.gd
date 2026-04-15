extends Node

static var baseURL: String = "localhost"

#region APIRest part

static var apiRestPort: String = ":3000/api/"

func request(functionToCall: Callable, type: HTTPClient.Method, rute: String, body: String) -> void:
	var newRequest = HTTPRequestSimplifier.new()
	newRequest.functionToCall = functionToCall
	add_child(newRequest)
	newRequest.try_request(type, "http://"+baseURL+apiRestPort+rute, body)
	pass

#endregion

#region WebSocket part

var socket = WebSocketPeer.new()
@export var webSocketPort = ":8090"
func createRoom(private: bool = false, custom: String = ""):
	var info = "/path?create" + ("&user="+ResourceManager.getToken()) + ("&private" if private else "") + (("&custom=" + custom.replace(" ", ".")) if custom!="" else "")
	socket.connect_to_url(baseURL+webSocketPort+info)
	get_tree().change_scene_to_file(ResourceManager.Scenes["OnParty"])

func joinRoom(id: int, code: String = ""):
	var info = "/path?join=" + str(id) + ("&user="+ResourceManager.getToken()) + (("&code="+code) if code != "" else "")
	socket.connect_to_url(baseURL+webSocketPort+info)
	get_tree().change_scene_to_file(ResourceManager.Scenes["OnParty"])

func exitRoom():
	socket.close()
	get_tree().change_scene_to_file(ResourceManager.Scenes["LoggedUser"])
	socket = WebSocketPeer.new()

func sendData(data, binary: bool = false):
	if (binary): socket.send(data)
	else: socket.send_text(data)

var time: float = 0
var step: float = 0.1
var unprocesedPackets: Array = []
func _process(delta):
	time += delta
	if socket.get_requested_url() != "" && time>step:
		time = 0
		for i in socket.handshake_headers:
			print(i)
		socket.poll()
		for i in socket.handshake_headers:
			print(i)
		var state = socket.get_ready_state()
		if state == WebSocketPeer.STATE_OPEN:
			while socket.get_available_packet_count():
				unprocesedPackets.append( socket.get_packet())
				
		elif state == WebSocketPeer.STATE_CONNECTING:
			while socket.get_available_packet_count():
				unprocesedPackets.append( socket.get_packet())
		elif state == WebSocketPeer.STATE_CLOSING:
			# Keep polling to achieve proper close.
			pass
		elif state == WebSocketPeer.STATE_CLOSED:
			var code = socket.get_close_code()
			var reason = socket.get_close_reason()
			#TODO: add a notification what the reason was
			print("WebSocket closed with code: %d, reason %s. Clean: %s" % [code, reason, code != -1])
			get_tree().change_scene_to_file(ResourceManager.Scenes["LoggedUser"])
			socket = WebSocketPeer.new()

func getPacketsOfType(type:String)->Array[Variant]:
	var packets = []
	var pos:int = 0
	for i in unprocesedPackets:
		var data = JSON.parse_string(i.get_string_from_utf8())
		if(data["type"] == type):
			unprocesedPackets.remove_at(pos)
			packets.append(data)
		pos+=1
	return packets
#endregion
