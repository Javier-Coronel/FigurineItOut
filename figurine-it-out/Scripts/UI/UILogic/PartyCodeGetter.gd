extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text=""
	pass # Replace with function body.


var timer: float = 0.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer+=delta
	if(text==""&&timer>0):
		
		var info = ApiRequester.getPacketsOfType("partyStart")
		timer = 0
		if(info.size()!=0):
			info = info[0]
			text = str(int(info["partyId"]))
			if(info.has("partyCode")):
				text = text + " | " + info["partyCode"]
