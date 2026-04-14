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
	match modification["edition"]:
		"add":
			print("Addition")
			add(modification["meshType"])
		"move":
			print("Moving")
			move(modification["mode"], modification["modifiedParts"], modification["position"])
		"rot":
			print("Rotation")
			rotationToMake(modification["mode"], modification["modifiedParts"], modification["rotation"])
		"scale":
			print("Scaling")
			scaleToMake(modification["mode"], modification["modifiedParts"], modification["scale"])
		"paint":
			print("Paint")
			paint(modification["mode"], modification["modifiedParts"], modification["color"])
		"creageo":
			print("CreateGeometry")
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
func move(mode, parts, positionData):
	match mode:
		"object":
			var tempFather = Node3D.new()
			add_child(tempFather)
			for object in parts:
				get_child(int(object)).reparent(tempFather)
			tempFather.position = Vector3(float(positionData["x"]),float(positionData["y"]),float(positionData["z"]))
			for child in tempFather.get_children():
				#var globPosition = child.global_position
				child.reparent(self)
				#child.position = globPosition
			tempFather.queue_free()
		_:
			pass
	pass

func rotationToMake(mode, parts, rotationData):
	pass

func scaleToMake(mode, parts, scaleData):
	pass

func paint(mode, parts, color):
	pass

## Destroy any son that this node has.
func clear():
	for i in get_children():
		i.queue_free()
