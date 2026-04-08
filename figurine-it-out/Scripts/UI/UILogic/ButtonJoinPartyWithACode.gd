extends Button

@export var room: LineEdit
@export var password: LineEdit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_up.connect(tryJoin)
	pass # Replace with function body.

func tryJoin() -> void:
	if !(checkRoom() || checkPassword()): return
	disabled = true
	text = "Espera"
	ApiRequester.joinRoom(int(room.text), password.text.to_upper())
	disabled = false
	text = ""

func checkRoom() -> bool:
	var validRoom = true
	validRoom = validRoom && !room.text.is_empty()
	if !validRoom: print("Sala no valida")
	return validRoom

func checkPassword() -> bool:
	var validPassword = true
	if !validPassword: print("Contraseña no valida")
	return validPassword
