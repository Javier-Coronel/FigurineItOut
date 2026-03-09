extends MenuButton

@export var logoutIndex: int
@export var settingsIndex: int
@export var exitIndex: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var popup = get_popup()
	popup.id_pressed.connect(popupHandler)
	pass # Replace with function body.

func popupHandler(id:int):
	match id:
		logoutIndex:
			logout()
		settingsIndex:
			#TODO: Add settings
			print("TODO: Add settings")
			pass
		exitIndex:
			get_tree().quit()
			pass

func logout():
	ApiRequester.request(
		(func(result, response_code, headers, body):
			var logInCookie := ConfigFile.new()
			var err = logInCookie.load("user://logincookie.ini")
			# Check that the file exists
			if(err!=OK):
				return false
			logInCookie.erase_section("cookie")
			logInCookie.save("user://logincookie.ini")
			get_tree().change_scene_to_file(SceneManager.Scenes["LogInUser"])),
		HTTPClient.METHOD_POST,
		"users/signout",
		""
	)
