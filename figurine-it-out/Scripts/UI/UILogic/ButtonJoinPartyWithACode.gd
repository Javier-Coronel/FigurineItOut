extends Button

@export var room: LineEdit
@export var password: LineEdit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_up.connect(tryJoin)
	pass # Replace with function body.

func tryJoin() -> void:
	if !(checkRoom()): 
		var infoPopUp = InfoPopUp.create()
		infoPopUp.velocity = 0.5
		get_tree().current_scene.add_child(infoPopUp)
		infoPopUp.load("Error, the info is empty")
		return
	disabled = true
	text = "Wait"
	ApiRequester.joinRoom(int(room.text.split("|")[0].strip_edges()), (room.text.split("|")[1].strip_edges().to_upper()) if room.text.contains("|") else "")
	disabled = false
	text = ""

func checkRoom() -> bool:
	var validRoom = true
	validRoom = validRoom && !room.text.is_empty()
	if !validRoom: print("Sala no valida")
	return validRoom
