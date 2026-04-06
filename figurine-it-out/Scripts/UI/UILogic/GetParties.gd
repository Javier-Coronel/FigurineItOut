extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ApiRequester.request(
		(func(_result, _response_code, _headers, body):
			var data = JSON.new()
			data.parse(body.get_string_from_utf8())
			for i in data:
				var buttonToAdd = Button.new()
				buttonToAdd.text = i
				buttonToAdd.pressed.
			)
		,HTTPClient.METHOD_GET,
		"currentParties",
		""
	)
