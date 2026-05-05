extends Control

@export var gizmo: Gizmo3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gizmo.visibility_changed.connect(func():
		print(!gizmo.visible)
		if !gizmo.visible:
			mouse_filter = Control.MOUSE_FILTER_STOP
			mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_INHERITED
			var a = InputEventMouseButton.new()
			a.position = get_global_mouse_position()
			a.button_index = MOUSE_BUTTON_LEFT
			a.pressed = true
			Input.parse_input_event(a)
			await get_tree().process_frame
			a.pressed = false
			Input.parse_input_event(a)
		else: 
			mouse_filter = Control.MOUSE_FILTER_IGNORE
			mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_DISABLED
			)
	pass # Replace with function body.
