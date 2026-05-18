extends Button

@export var user: LineEdit
@export var password: LineEdit
@export var confirmPassword: LineEdit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_up.connect(trySignin)
	pass # Replace with function body.

func trySignin() -> void:
	if !(checkUser()):	
		var infoPopUp = InfoPopUp.create()
		get_tree().current_scene.add_child(infoPopUp)
		infoPopUp.velocity = 0.25
		infoPopUp.load("Please add a user")
		
		return
	if !(checkPassword()):
		var infoPopUp = InfoPopUp.create()
		get_tree().current_scene.add_child(infoPopUp)
		infoPopUp.velocity = 0.25
		infoPopUp.load("Please add a password")
		return
	disabled = true
	text = "Wait"
	var createUser = JSON.stringify({"name": user.text, "password": password.text})
	
	print(createUser)
	
	ApiRequester.request(
		(func (_result, _response_code, _headers, body):
			var data = JSON.new()
			data.parse(body.get_string_from_utf8())
			print(body.get_string_from_utf8())
			print(data.data["message"])
			disabled = false
			text = ""
			if(data.data["ok"]):
				ApiRequester.request(
					(func (_result, response_code, _headers, body):
						var logindata = JSON.new()
						logindata.parse(body.get_string_from_utf8())
						print(body.get_string_from_utf8())
						print(logindata.data["message"])
						if(response_code==200):
							var cookie = ConfigFile.new()
							cookie.set_value("cookie", "token", logindata.data["data"]["cookie"]["token"])
							cookie.set_value("cookie", "maxAge", logindata.data["data"]["cookie"]["maxAge"])
							cookie.set_value("cookie", "creationDate", Time.get_unix_time_from_datetime_dict(Time.get_date_dict_from_system(true)))
							cookie.set_value("cookie", "httpOnly", logindata.data["data"]["cookie"]["httpOnly"])
							cookie.set_value("cookie", "secure", logindata.data["data"]["cookie"]["secure"])
							cookie.set_value("cookie", "sameSite", logindata.data["data"]["cookie"]["sameSite"])
							cookie.save(ResourceManager.getTokenLocalization())
							get_tree().change_scene_to_file(ResourceManager.Scenes["LoggedUser"])
							return
						var infoPopUp = InfoPopUp.create()
						get_tree().current_scene.add_child(infoPopUp)
						infoPopUp.velocity = 0.25
						infoPopUp.load("Error: " + logindata.data["message"])
						user.text = ""
						password.text = ""
						disabled = false
						text = "Log in"),
					HTTPClient.METHOD_POST,
					"users/signin",
					createUser)
				pass
			else:
				var infoPopUp = InfoPopUp.create()
				get_tree().current_scene.add_child(infoPopUp)
				infoPopUp.velocity = 0.25
				infoPopUp.load(data.data["message"])
				pass),
		HTTPClient.METHOD_POST,
		"players/",
		createUser)
	

func checkUser() -> bool:
	var validUser = true
	validUser = validUser && !user.text.is_empty()
	if !validUser: print("Usuario no valido")
	return validUser


func checkPassword() -> bool:
	var validPassword = true
	validPassword = validPassword && !password.text.is_empty()
	validPassword = validPassword && password.text == confirmPassword.text
	if !validPassword: print("Password not valid")
	return validPassword
