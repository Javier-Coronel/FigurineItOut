class_name OnParty
extends Node3D

@onready var GuesserUI = %GuesserUI
@onready var CreatorUI = %CreatorUI
@onready var PartyCode = %PartyCode

var creator = false
 
@export var gizmo: Gizmo3D

var _add : bool

enum Edition {NONE, SELECT, ADD, TRANSFORM, PAINT, CREATEGEOMETRY, DUPLICATE, DELETE}
var actualEdition: Edition = Edition.NONE
enum Selection {NONE, VERTEX, EDGE, FACE, OBJECT}
var actualSelection: Selection = Selection.OBJECT
var selected = []

var time := 0
const maxTime = 10 * 60
var timer := 0.0
var step := 0.1
const meshTypes:=["box","sphere","plane","torus","cylinder","capsule","cone"]
var lastTransformValue = 0
var currTransformValue = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CreatorUI.get_node("MeshEditionButtonsContainer/AddButton").get_popup().index_pressed.connect(
		func (i):
			%Model.processModification({"edition":"add", "meshType":meshTypes[i]})
			ApiRequester.socket.send_text(str(JSON.stringify({"type":"editModel","edition":"add", "meshType":meshTypes[i]})))
			pass
	)
	CreatorUI.get_node("MeshEditionButtonsContainer/PaintButton").popup_closed.connect(func ():
		passData()
		print(tempSelection)
		actualEdition = Edition.PAINT
		if(actualSelection == Selection.OBJECT):
			if(selected.size()==0):return
			var selectedPos = []
			for obj in selected: selectedPos.append(obj.get_index())
			%Model.processModification({"mode":"object", "edition":"paint", "modifiedParts":selectedPos, "color":CreatorUI.get_node("MeshEditionButtonsContainer/PaintButton").color})
			ApiRequester.socket.send_text(str(JSON.stringify({"type":"editModel", "mode":"object", "edition":"paint", "modifiedParts":selectedPos, "color":CreatorUI.get_node("MeshEditionButtonsContainer/PaintButton").color.to_html(false)})))
			
		)
	CreatorUI.get_node("MeshEditionButtonsContainer/DeleteObject").pressed.connect(func ():
		passData()
		actualSelection = Selection.OBJECT
		actualEdition = Edition.DELETE
		if(selected.size()==0):return
		var selectedPos = []
		for obj in selected: selectedPos.append(obj.get_index())
		%Model.processModification({"edition":"del", "modifiedParts":selectedPos})
		ApiRequester.socket.send_text(str(JSON.stringify({"type":"editModel", "edition":"del", "modifiedParts":selectedPos})))
		)
	gizmo.transform_begin.connect(func(_mode): 
		print(gizmo.position)
		lastTransformValue = gizmo.position
		)
	gizmo.transform_changed.connect(func (_mode, value):
		currTransformValue = value
		)
	gizmo.transform_end.connect(func (mode):
		var typeOfEdition = ""
		var objectIndex = []
		for i in gizmo._selections.keys():
			print("modeler Scale", i.name, (i.scale), "modeler rot",  (i.rotation), "modeler pos",  (i.position))
			objectIndex.append(i.get_index())
		objectIndex.sort()
		match mode:
			Gizmo3D.TransformMode.ROTATE:
				typeOfEdition = "rot"
			Gizmo3D.TransformMode.TRANSLATE:
				typeOfEdition = "move"
			Gizmo3D.TransformMode.SCALE:
				typeOfEdition = "scale"
				
				
		ApiRequester.socket.send_text(str(JSON.stringify({"type":"editModel", "mode":"object","edition":typeOfEdition, "value":currTransformValue, "modifiedParts": objectIndex})))
		pass)
	CreatorUI.get_node("SelectionButtonsContainer/VertexButton").pressed.connect(func ():
		%Model.actualSelection = %Model.Selection.VERTEX
		)
	CreatorUI.get_node("SelectionButtonsContainer/EdgeButton").pressed.connect(func ():
		%Model.actualSelection = %Model.Selection.EDGE
		)
	CreatorUI.get_node("SelectionButtonsContainer/FaceButton").pressed.connect(func ():
		%Model.actualSelection = %Model.Selection.FACE
		)
	CreatorUI.get_node("SelectionButtonsContainer/ObjectButton").pressed.connect(func ():
		%Model.actualSelection = %Model.Selection.OBJECT
		)
	PartyCode.focus_entered.connect(func ():
		DisplayServer.clipboard_set(PartyCode.text)
		PartyCode.release_focus()
		pass)

func passData(toTransform = false):
	if(toTransform):
		gizmo.clear_selection()
		for i in selected:
			gizmo.select(i)
	else:
		selected = tempSelection
		#gizmo.clear_selection()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	_add = Input.is_action_pressed("addTarget")
	
	timer+=delta
	if(timer>step):
		timer=0
		
		if(time != 0):
			var dict = Time.get_time_dict_from_unix_time(int(maxTime+int(time/1000)-int(Time.get_unix_time_from_system())))
			var curtime = str((str(dict["hour"]) + " : " if dict["hour"] !=0 else "") , (("0" if str(dict["minute"]).length()==1 else "")+str(dict["minute"])), " : ", ("0" if str(dict["second"]).length()==1 else "")+str(dict["second"]))
			GuesserUI.get_node("TimeLeft").text = curtime
			CreatorUI.get_node("TimeLeft").text = curtime
	
		var partyInfo = ApiRequester.getPacketsOfType("partyStart")
		if(partyInfo.size()!=0):
			partyInfo = partyInfo[0]
			PartyCode.text = str(int(partyInfo["partyId"]))
			if(partyInfo.has("partyCode")):
				PartyCode.text = PartyCode.text + " | " + partyInfo["partyCode"]
			var progression = partyInfo.get("objectProgression", [])
			for i in progression:
				%Model.processModification(i)
			time = partyInfo.get("time", time)
			GuesserUI.get_node("Comments/ObjectToGuessInfo").text = ("_".repeat(int(partyInfo["hint"])) if partyInfo.get("hint", false) else "")
		
		
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
			GuesserUI.get_node("Comments/LastSolved").text = "Last concept: " + solved[0]["concept"] + ((", by " + solved[0]["by"]) if solved[0].has("by") else "")
			%Model.clear()
			gizmo.clear_selection()
		
		var hint = ApiRequester.getPacketsOfType("hint")
		if(hint.size()!=0):
			GuesserUI.get_node("Comments/ObjectToGuessInfo").text = "_".repeat(int(hint[0]["hint"]))
		
		var beCreator = ApiRequester.getPacketsOfType("beCreator")
		if(beCreator.size()!=0):
			GuesserUI.visible = false
			CreatorUI.visible = true
			creator = true
			CreatorUI.get_node("ObjectToGuessInfo").text = beCreator[0]["concept"]
			time = beCreator[0]["time"]
			
		


var tempSelection = []
func _input(event: InputEvent) -> void:
	if !creator: return
	# Prevent object picking if user is interacting with the gizmo
	if gizmo.hovering || gizmo.editing:
		return;
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# Raycast from the camera
		var camera := get_viewport().get_camera_3d()
		var dir := camera.project_ray_normal(event.position)
		var from := camera.project_ray_origin(event.position)
		var params = PhysicsRayQueryParameters3D.new()
		params.from = from
		params.to = from + dir * 1000.0
		var result = get_world_3d().direct_space_state.intersect_ray(params)
		if result.size() == 0:
			if(gizmo._selections.keys().size()!=0): tempSelection=gizmo._selections.keys()
			gizmo.clear_selection()
			return
		# If shift is held, add/remove the node to/from the target list. Otherwise set the target to just that node.
		var collider = result["collider"] as Node3D
		var node = collider.get_parent()
		match actualEdition:
			Edition.NONE: pass
			Edition.SELECT: pass
			Edition.PAINT:
				if(actualSelection == Selection.OBJECT):
					%Model.processModification({"mode":"object", "edition":"paint", "modifiedParts":[node.get_index()], "color":CreatorUI.get_node("MeshEditionButtonsContainer/PaintButton").color})
					ApiRequester.socket.send_text(str(JSON.stringify({"type":"editModel", "mode":"object", "edition":"paint", "modifiedParts":[node.get_index()], "color":CreatorUI.get_node("MeshEditionButtonsContainer/PaintButton").color.to_html(false)})))
			Edition.TRANSFORM:
				if !_add:
					gizmo.clear_selection()
					gizmo.select(node)
					return
				if !gizmo.deselect(node):
						gizmo.select(node)
			Edition.DELETE:
				%Model.processModification({"edition":"del", "modifiedParts":[node.get_index()]})
				ApiRequester.socket.send_text(str(JSON.stringify({"type":"editModel", "edition":"del", "modifiedParts":[node.get_index()]})))
				
			
