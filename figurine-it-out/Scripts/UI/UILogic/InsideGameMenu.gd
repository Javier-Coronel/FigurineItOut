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
		settingsIndex:
			#TODO: Add settings
			print("TODO: Add settings")
			pass
		seePlayersIndex:
			#TODO: Add being able to see players
			print("TODO: Add seePlayers")
			pass

func exitRoom():
	ApiRequester.exitRoom()
