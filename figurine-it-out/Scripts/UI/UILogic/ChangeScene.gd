class_name ChangeScene
extends BaseButton

@export_file("*.tscn")  var sceneToGo

func _ready() -> void:
    if sceneToGo == null:
        set("text","WARNING!!! Add an scene to the ChangeScene")
    else:
        pressed.connect(goto)

func goto(goingTo: String = sceneToGo):
    if goingTo == null: pass
    get_tree().change_scene_to_file(goingTo)
    