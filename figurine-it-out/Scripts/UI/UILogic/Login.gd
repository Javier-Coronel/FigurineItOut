extends Button

@export var user: LineEdit
@export var password: LineEdit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_up.connect(tryLogin)
	pass # Replace with function body.

func tryLogin() -> void:
	if !(checkUser() || checkPassword()):	return
	disabled = true
	text = "Espera"
	var createUser = JSON.stringify({"name": user.text, "password": password.text})
	
	print(createUser)
	
	ApiRequester.request(
		(func (result, response_code, headers, body):
			var data = JSON.new()
			data.parse(body.get_string_from_utf8())
			print(body.get_string_from_utf8())
			print(data.data["message"])
			if(response_code==200):
				var cookie = ConfigFile.new()
				cookie.set_value("cookie", "token", data.data["data"]["cookie"]["token"])
				cookie.set_value("cookie", "maxAge", data.data["data"]["cookie"]["maxAge"])
				cookie.set_value("cookie", "creationDate", Time.get_unix_time_from_datetime_dict(Time.get_date_dict_from_system(true)))
				cookie.set_value("cookie", "httpOnly", data.data["data"]["cookie"]["httpOnly"])
				cookie.set_value("cookie", "secure", data.data["data"]["cookie"]["secure"])
				cookie.set_value("cookie", "sameSite", data.data["data"]["cookie"]["sameSite"])
				cookie.save("user://logincookie.ini")
				
			disabled = false
			text = ""),
		HTTPClient.METHOD_POST,
		"users/signin",
		createUser)

func checkUser() -> bool:
	var validUser = true
	validUser = validUser && !user.text.is_empty()
	if !validUser: print("Usuario no valido")
	return validUser

func checkPassword() -> bool:
	var validPassword = true
	validPassword = validPassword && !password.text.is_empty()
	if !validPassword: print("Contraseña no valida")
	return validPassword
