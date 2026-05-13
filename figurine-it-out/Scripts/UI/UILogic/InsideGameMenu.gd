extends MenuButton

@export var settingsIndex: int
@export var seePlayersIndex: int
@export var exitIndex: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var popup = get_popup()
	popup.id_pressed.connect(popupHandler)
	pass # Replace with function body.

func popupHandler(id:int):
	match id:
		exitIndex:
			exitRoom()
		seePlayersIndex:
			get_node("../UserList").visible = true

func exitRoom():
	ApiRequester.exitRoom()
