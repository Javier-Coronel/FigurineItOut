extends Node

@export var enterButton:Button
@export var exitButton:Button

func _ready():
	var valid = checkValidToken()
	enterButton.pressed.connect(func():
		if(valid):
			get_tree().change_scene_to_file(ResourceManager.Scenes["LoggedUser"])
		else:
			get_tree().change_scene_to_file(ResourceManager.Scenes["LogInUser"]))
	
	enterButton.text = "Play" if valid else "Log in"
	exitButton.pressed.connect(func():
		get_tree().quit()
		)

func _process(_delta: float) -> void:
	pass

func checkValidToken() -> bool:
	var logInCookie := ConfigFile.new()
	var err = logInCookie.load(ResourceManager.getTokenLocalization())
	# Check that the file exists
	if(err!=OK):
		return false
	# Check that the section exists
	if(!logInCookie.has_section("cookie")):
		return false
	# Check that the cookie isnt expired
	var maxAge = int(logInCookie.get_value("cookie", "maxAge"))/1000
	var creationDate = int(logInCookie.get_value("cookie", "creationDate"))
	if(Time.get_unix_time_from_datetime_dict(Time.get_date_dict_from_system(true))>(maxAge+creationDate)):
		return false
	return true
