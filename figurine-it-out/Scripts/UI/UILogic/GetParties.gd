extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ApiRequester.request(
		(func(_result, _response_code, _headers, body):
			var data = JSON.new()
			data.parse(body.get_string_from_utf8())
			print(body.get_string_from_utf8())
			print(data.data)
			for i in data.data:
				print(i)
				var buttonToAdd = Button.new()
				buttonToAdd.text = str(int(i))
				buttonToAdd.pressed.connect(
					func():
						ApiRequester.joinRoom(int(i))
						)
				add_child(buttonToAdd)
			)
		,HTTPClient.METHOD_GET,
		"currentParties",
		""
	)
