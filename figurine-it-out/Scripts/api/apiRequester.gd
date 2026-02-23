extends Node

static var baseURL: String = ""#"https://pokeapi.co/api/v2/"#"http://localhost:3000/api/"

func request(functionToCall: Callable, type: HTTPClient.Method, rute: String, body: String) -> void:
	var newRequest = HTTPRequestSimplifier.new()
	newRequest.functionToCall = functionToCall
	add_child(newRequest)
	newRequest.try_request(type, baseURL+rute, body)
	pass
