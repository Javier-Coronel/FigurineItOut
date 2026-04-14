extends Node3D

@onready var GuesserUI = %GuesserUI
@onready var CreatorUI = %CreatorUI
@onready var PartyCode = %PartyCode

var creator = false

var time := 0
const maxTime = 10 * 60
var timer := 0.0
var step := 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#region testing
	CreatorUI.get_node("MeshEditionButtonsContainer/MovementButton").pressed.connect(func ():
		%Model.processModification({"edition":"add", "meshType": "box"})
		)
	CreatorUI.get_node("MeshEditionButtonsContainer/RotateButton").pressed.connect(func ():
		%Model.processModification({"edition": "move", "mode": "object", "modifiedParts": ["0"], "position": {"x":"5", "y":"0", "z":"0"}})
		)
	CreatorUI.get_node("MeshEditionButtonsContainer/ScaleButton").pressed.connect(func ():
		%Model.processModification({"edition":"add", "meshType": "cone"})
		)
	CreatorUI.get_node("MeshEditionButtonsContainer/PaintButton").pressed.connect(func ():
		%Model.processModification({"edition": "move", "mode": "object", "modifiedParts": ["0","1"], "position": {"x":"0", "y":"0", "z":"5"}})
		)
	CreatorUI.get_node("MeshEditionButtonsContainer/GeometriCreatorButton").pressed.connect(func ():
		%Model.processModification({"edition":"add", "meshType": "torus"})
		%Model.processModification({"edition": "move", "mode": "object", "modifiedParts": ["2"], "position": {"x":"-5", "y":"0", "z":"0"}})
		%Model.processModification({"edition":"add", "meshType": "capsule"})
		%Model.processModification({"edition": "move", "mode": "object", "modifiedParts": ["2","3"], "position": {"x":"0", "y":"0", "z":"-5"}})
		)
	#endregion
	PartyCode.focus_entered.connect(func ():
		DisplayServer.clipboard_set(PartyCode.text)
		PartyCode.release_focus()
		pass)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer+=delta
	if(timer>step):
		timer=0
		
		if(time != 0):
			var dict = Time.get_time_dict_from_unix_time(int(maxTime+int(time/1000)-int(Time.get_unix_time_from_system())))
			GuesserUI.get_node("TimeLeft").text = str((str(dict["hour"]) + " : " if dict["hour"] !=0 else "") , dict["minute"], " : ", dict["second"])
			CreatorUI.get_node("TimeLeft").text = str((str(dict["hour"]) + " : " if dict["hour"] !=0 else "") , dict["minute"], " : ", dict["second"])
		
		var partyInfo = ApiRequester.getPacketsOfType("partyStart")
		if(partyInfo.size()!=0):
			partyInfo = partyInfo[0]
			PartyCode.text = str(int(partyInfo["partyId"]))
			if(partyInfo.has("partyCode")):
				PartyCode.text = PartyCode.text + " | " + partyInfo["partyCode"]
			var progression = partyInfo.get("objectProgression", [])
			for i in progression:
				%Model.processModification(i)
		
		var edits = ApiRequester.getPacketsOfType("editModel")
		if edits.size() != 0:
			for i in edits:
				%Model.processModification(i)
		
		var timeLeft = ApiRequester.getPacketsOfType("timeLeft")
		if(timeLeft.size()!=0):
			time = timeLeft[0]["time"]
		
		var solved = ApiRequester.getPacketsOfType("solved")
		if(solved.size()!=0):
			GuesserUI.visible = true
			CreatorUI.visible = false
			creator = false
			GuesserUI.get_node("Comments/ObjectToGuessInfo").text = solved[0]["concept"]
		
		var beCreator = ApiRequester.getPacketsOfType("beCreator")
		if(beCreator.size()!=0):
			GuesserUI.visible = false
			CreatorUI.visible = true
			creator = true
			CreatorUI.get_node("ObjectToGuessInfo").text = beCreator[0]["concept"]
			time = beCreator[0]["time"]
			
		
