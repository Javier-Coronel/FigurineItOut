class_name ChangeScene
extends BaseButton

@export var sceneToGo: String

func _ready() -> void:
	if sceneToGo == null:
		set("text","WARNING!!! Add an scene to the ChangeScene")
	else:
		pressed.connect(goto)

func goto(goingTo: String = sceneToGo):
	
	if goingTo == null: 
		return
	elif goingTo == "exit": 
		get_tree().quit()
		return
	get_tree().change_scene_to_file(ResourceManager.Scenes[sceneToGo])
	
