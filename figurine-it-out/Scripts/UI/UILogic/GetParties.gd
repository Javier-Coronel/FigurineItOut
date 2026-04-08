extends VBoxContainer

var button = load(ResourceManager.Objects["InstantiableButton"])

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ApiRequester.request(
		(func(_result, _response_code, _headers, body):
			var data = JSON.new()
			data.parse(body.get_string_from_utf8())
			for i in data.data:
				var nodeToAdd = button.instantiate()
				var buttonToAdd = nodeToAdd.get_node("Button")
				buttonToAdd.text = str(int(i))
				buttonToAdd.pressed.connect(
					func():
						ApiRequester.joinRoom(int(i))
						)
				add_child(nodeToAdd)
			)
		,HTTPClient.METHOD_GET,
		"currentParties",
		""
	)
