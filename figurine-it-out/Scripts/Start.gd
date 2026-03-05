extends Node

@export_file("*.tscn") var onNotValidCookieScene
@export_file("*.tscn") var onValidCookieScene

func _ready() -> void:

    if(checkValidToken()):
        get_tree().change_scene_to_file(onValidCookieScene)
    else:
        get_tree().change_scene_to_file(onNotValidCookieScene)

func checkValidToken() -> bool:
    var logInCookie := ConfigFile.new()
    var err = logInCookie.load("user://logincookie.ini")
    # Check that the file exists
    if(err!=OK):
        return false
    # Check that the cookie isnt expired
    var maxAge = int(logInCookie.get_value("cookie", "maxAge"))
    var creationDate = int(logInCookie.get_value("cookie", "creationDate"))
    if(Time.get_unix_time_from_datetime_dict(Time.get_date_dict_from_system(true))>(maxAge+creationDate)):
        return false
    
    return true