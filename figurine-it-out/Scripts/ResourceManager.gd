class_name ResourceManager
extends Object

static var Scenes := {
	"StartScene": "res://Scenes/StartScene.tscn",
	"LogInUser": "res://Scenes/UI/LogInUser.tscn",
	"LoggedUser": "res://Scenes/UI/LoggedUser.tscn",
	"SignInUser": "res://Scenes/UI/SignInUser.tscn",
}

static func getTokenLocalization()->String:
	if(OS.is_debug_build()):
		return "user://logincookie" + OS.get_cmdline_args()[2] + ".ini"
	return "user://logincookie.ini"
