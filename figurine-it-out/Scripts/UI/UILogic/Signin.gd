extends Button

@export var user: LineEdit
@export var email: LineEdit
@export var password: LineEdit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_up.connect(trySignin)
	pass # Replace with function body.

func trySignin() -> void:
	if !(checkUser() || checkPassword() || checkEmail()):	return
	disabled = true
	text = "Espera"
	var createUser = JSON.stringify({"name": user.text, "email": email.text, "password": password.text})
	
	print(createUser)
	
	ApiRequester.request(
		(func (_result, _response_code, _headers, body):
			var data = JSON.new()
			data.parse(body.get_string_from_utf8())
			print(body.get_string_from_utf8())
			print(data.data["message"])
			disabled = false
			text = ""),
		HTTPClient.METHOD_POST,
		"players/",
		createUser)
	

func checkUser() -> bool:
	var validUser = true
	validUser = validUser && !user.text.is_empty()
	if !validUser: print("Usuario no valido")
	return validUser

func checkEmail() -> bool:
	var validEmail = true
	validEmail = validEmail && !email.text.is_empty()
	if !validEmail: print("Correo no valido")
	return validEmail

func checkPassword() -> bool:
	var validPassword = true
	validPassword = validPassword && !password.text.is_empty()
	if !validPassword: print("Contraseña no valida")
	return validPassword
