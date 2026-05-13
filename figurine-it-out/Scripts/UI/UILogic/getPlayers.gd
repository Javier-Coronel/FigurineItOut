extends VBoxContainer
var timer := 0.0
var step := 1

func _ready() -> void:
	get_parent().get_parent().focus_entered.connect(close)

func close():
	get_parent().get_parent().visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer+=delta
	if(timer>step):
		timer=0
		var playersInfo = ApiRequester.getPacketsOfType("playersName")
		if(playersInfo.size()!=0):
			playersInfo = playersInfo[-1]
			for toDelete in get_children():
				toDelete.queue_free()
			for user in playersInfo.get("players", []):
				var text = LineEdit.new()
				text.text = user
				text.alignment = HORIZONTAL_ALIGNMENT_CENTER
				text.size_flags_vertical = Control.SIZE_EXPAND_FILL
				text.editable = false
				text.focus_mode = Control.FOCUS_NONE
				add_child(text)
