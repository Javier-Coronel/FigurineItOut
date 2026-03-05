## Class that will request one api endpoint and return the received data to the original object that requested
class_name HTTPRequestSimplifier
extends HTTPRequest

var functionToCall: Callable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	request_completed.connect(_http_request_completed)
	pass # Replace with function body.

## Called when trying to connect with the server to pass information
func try_request(type: HTTPClient.Method, rute: String, body: String, ) -> void:
	var headers = ["Content-Type: application/json"]
	request(rute, headers, type, body)
	pass

func _http_request_completed(result, response_code, headers, body):
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("Ha habido un error.")
	print(response_code)
	functionToCall.call(result, response_code, headers, body)
	queue_free()
