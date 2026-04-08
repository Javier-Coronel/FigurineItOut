class_name ResourceManager
extends Object

static var Scenes := {
	"StartScene": "res://Scenes/StartScene.tscn",
	"LogInUser": "res://Scenes/UI/LogInUser.tscn",
	"LoggedUser": "res://Scenes/UI/LoggedUser.tscn",
	"SignInUser": "res://Scenes/UI/SignInUser.tscn",
	"CreateParty": "res://Scenes/UI/CreateParty.tscn",
	"PartySelector": "res://Scenes/UI/PartySelector.tscn",
	"OnParty": "res://Scenes/UI/OnParty.tscn",
}
static var Objects:={
	"Comment":"res://Objects/Comment.tscn",
	"OwnComment":"res://Objects/OwnComment.tscn",
	"InstantiableButton":"res://Objects/InstantiableButton.tscn"
}
static func getTokenLocalization()->String:
	if(OS.is_debug_build()):
		return "user://logincookie" + OS.get_cmdline_args()[2] + ".ini"
	return "user://logincookie.ini"

static func getToken()->String:
	var data = ConfigFile.new()
	var err = data.load(getTokenLocalization())
	if(err!=OK): return ""
	return data.get_value("cookie","token","")
