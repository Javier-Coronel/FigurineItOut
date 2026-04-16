class_name ModelEditor
extends Node3D

var timer := 0.0
var step := 1.0

enum Edition {NONE, SELECT, ADD, MOVEMENT, ROTATION, SCALE, PAINT, CREATEGEOMETRY}
var actualEdition: Edition = Edition.NONE
enum Selection {NONE, VERTEX, EDGE, FACE, OBJECT}
var actualSelection: Selection = Selection.NONE

const startingChild := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer+=delta
	if(timer>step):
		timer=0

## Process the given data to edit the model
func processModification(modification):
	if modification.get("mode", "") == "object":
		match modification["edition"]:
			"move":
				print("Moving")
				moveObjects(modification["modifiedParts"], modification["position"])
			"rot":
				print("Rotation")
				rotateObjects(modification["modifiedParts"], modification["rotation"])
			"scale":
				print("Scaling")
				scaleObjects(modification["modifiedParts"], modification["scale"])
			"paint":
				print("Paint")
				paintObjects(modification["modifiedParts"], modification["color"])
			"creageo":
				print("CreateGeometry")
			_:
				print("Unknow edition")
	elif modification.get("mode", "") == "vertex":
		match modification["edition"]:
			"move":
				print("Moving")
				moveVertex(modification["objects"], modification["modifiedParts"], modification["position"])
			"rot":
				print("Rotation")
				rotateVertex(modification["objects"], modification["modifiedParts"], modification["rotation"])
			"scale":
				print("Scaling")
				scaleVertex(modification["objects"], modification["modifiedParts"], modification["scale"])
			"paint":
				print("Paint")
				paintVertex(modification["objects"], modification["modifiedParts"], modification["color"])
			"creageo":
				print("CreateGeometry")
			_:
				print("Unknow edition")
		pass
	else:
		match modification["edition"]:
			"add":
				print("Addition")
				add(modification["meshType"])
			"del":
				print("Deleting objects")
				delete(modification["modifiedParts"])
			_:
				print("Unknow edition")
	pass

## Adds either a box, sphere, plane, torus, cylinder, capsule or cone
func add(meshType: String):
	var child = MeshInstance3D.new()
	var mesh:PrimitiveMesh
	match meshType:
		"box":
			mesh = BoxMesh.new()
		"sphere":
			mesh = SphereMesh.new()
		"plane":
			mesh = PlaneMesh.new()
		"torus":
			mesh = TorusMesh.new()
		"cylinder":
			mesh = CylinderMesh.new()
		"capsule":
			mesh = CapsuleMesh.new()
		"cone":
			mesh = CylinderMesh.new()
			mesh.top_radius = 0
	mesh.request_update()
	
	var model: ArrayMesh = ArrayMesh.new()
	model.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES,mesh.get_mesh_arrays())
	child.mesh = model
	add_child(child)
## Moves objects or vertex to a position, if there are multiple objects or vertex the position will be the center
func moveObjects(parts, positionData):
	
	var tempFather = Node3D.new()
	add_child(tempFather)
	for object in parts:
		print(get_child(int(parts[0])+startingChild).name)
		get_child(int(parts[0])).reparent(tempFather)
	tempFather.position = Vector3(float(positionData["x"]),float(positionData["y"]),float(positionData["z"]))
	for child in tempFather.get_children():
		#var globPosition = child.global_position
		child.reparent(self)
		#child.position = globPosition
	remove_child(tempFather)
	tempFather.queue_free()


func rotateObjects(parts, rotationData):
	pass

func scaleObjects(parts, scaleData):
	pass

func paintObjects(parts, color):
	pass

func delete(positions):
	positions.reverse()
	for i in positions:
		get_child(int(i)).queue_free()

func moveVertex(objects, vertex, positionData):
	pass
func rotateVertex(objects, vertex, rotationData):
	pass
func scaleVertex(objects, vertex, scaleData):
	pass
func paintVertex(objects, vertex, color):
	pass

## Destroy any son that this node has.
func clear():
	for i in get_children():
		i.queue_free()
