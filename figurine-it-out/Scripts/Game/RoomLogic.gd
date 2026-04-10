extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


var time := 0.0
var step := 1.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time+=delta
	if(time>step):
		time=0
		var solved = ApiRequester.getPacketsOfType("solved")
		if(solved.size()!=0):
			%GuesserUI.visible = true
			%CreatorUI.visible = false
			%GuesserUI.get_node("Comments/ObjectToGuessInfo").text = solved[0]["concept"]
		
		var beCreator = ApiRequester.getPacketsOfType("beCreator")
		if(beCreator.size()!=0):
			%GuesserUI.visible = false
			%CreatorUI.visible = true
			%CreatorUI.get_node("ObjectToGuessInfo").text = beCreator[0]["concept"]
		
	
