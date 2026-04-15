extends Node

func _process(_delta: float) -> void:

	if(checkValidToken()):
		get_tree().change_scene_to_file(ResourceManager.Scenes["LoggedUser"])
	else:
		get_tree().change_scene_to_file(ResourceManager.Scenes["LogInUser"])

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
