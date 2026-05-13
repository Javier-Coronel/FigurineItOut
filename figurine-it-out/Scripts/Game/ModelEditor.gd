class_name ModelEditor
extends Node3D

var timer := 0.0
var step := 1.0

@export var gizmo: Gizmo3D 

const startingChild := 0
var material = StandardMaterial3D.new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	material.vertex_color_use_as_albedo = true
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	timer+=delta
#	if(timer>step):
#		timer=0

## Process the given data to edit the model
func processModification(modification):
	if modification.get("mode", "") == "object":
		match modification["edition"]:
			"move":
				print("Moving")
				moveObjects(modification["modifiedParts"], modification["value"])
			"rot":
				print("Rotation")
				rotateObjects(modification["modifiedParts"], modification["value"])
			"scale":
				print("Scaling")
				scaleObjects(modification["modifiedParts"], modification["value"])
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
	var mdt = MeshDataTool.new()
	mdt.create_from_surface(model, 0)
	for i in range(mdt.get_vertex_count()):
		mdt.set_vertex_color(i,Color.WHITE)
	child.mesh = model
	child.material_override = material
	child.create_trimesh_collision()
	add_child(child)

func clearGizmo():
	
	gizmo._edit.mode = Gizmo3D.TransformMode.NONE

## Moves objects to a position, if there are multiple objects the position will be the center
func moveObjects(parts, positionData):
	var tempFather = Node3D.new()
	add_child(tempFather)
	positionData = positionData.replace("(","").replace(")","").split(", ")
	positionData = Vector3(float(positionData[0]),float(positionData[1]),float(positionData[2]))
	var toAppend = []
	for object in parts:
		toAppend.append(get_child(int(object)))
	#	gizmo.select(get_child(int(object)))
	for i in toAppend:
		i.get_tree()
		i.reparent(tempFather)
	#gizmo._edit.mode = Gizmo3D.TransformMode.TRANSLATE
	#gizmo._apply_transform(positionData, 0)
	
	#gizmo.clear_selection()
	tempFather.position = Vector3(float(positionData["x"]),float(positionData["y"]),float(positionData["z"]))
	for child in tempFather.get_children():
		#var globPosition = child.global_position
		child.reparent(self)
		#child.position = globPosition
	remove_child(tempFather)
	tempFather.queue_free()
	toAppend = get_children()
	toAppend.sort_custom(func(a, b): return int(a.name.replace("@MeshInstance3D@","")) < int(b.name.replace("@MeshInstance3D@","")))
	
	for i in toAppend:
		i.reparent(get_parent())
		i.reparent(self)
	for object in parts:
		print("guesser Pos", get_child(int(object)).name, (get_child(int(object)).position))
	

func calculateObjectCenter(objects: Array) -> Vector3:
	var zero = Vector3.ZERO
	for i in objects: zero += i.position
	return Vector3(
		zero/objects.size())
		
func rotateObjects(parts, rotationData):
	var tempFather = Node3D.new()
	add_child(tempFather)
	var toAppend = []
	for object in parts:
		toAppend.append(get_child(int(object)))
	tempFather.position = calculateObjectCenter(toAppend)
	for i in toAppend:
		i.reparent(tempFather)
	rotationData = rotationData.replace("(","").replace(")","").split(", ")
	
	rotationData = Vector3(float(rotationData[0]),float(rotationData[1]),float(rotationData[2]))
	tempFather.rotation = Vector3(float(rotationData["x"]),float(rotationData["y"]),float(rotationData["z"]))
	for child in tempFather.get_children():
		#var globPosition = child.global_position
		child.reparent(self)
		#child.position = globPosition
	remove_child(tempFather)
	tempFather.queue_free()
	toAppend = get_children()
	toAppend.sort_custom(func(a, b): return int(a.name.replace("@MeshInstance3D@","")) < int(b.name.replace("@MeshInstance3D@","")))
	
	for i in toAppend:
		i.reparent(get_parent())
		i.reparent(self)
	pass

func scaleObjects(parts, scaleData):
	var tempFather = Node3D.new()
	add_child(tempFather)
	var toAppend = []
	for object in parts:
		toAppend.append(get_child(int(object)))
	tempFather.position = calculateObjectCenter(toAppend)
	for i in toAppend:
		i.reparent(tempFather)
	scaleData = scaleData.replace("(","").replace(")","").split(", ")
	
	scaleData = Vector3(float(scaleData[0]),float(scaleData[1]),float(scaleData[2]))
	#tempFather.global_scale(Vector3.ONE + scaleData)
	
	for i in toAppend:
		var new_transform := Transform3D()
		new_transform.basis = new_transform.basis.scaled(scaleData + Vector3.ONE)
		var base := Transform3D(Basis.IDENTITY, tempFather.position)
		new_transform = base * (new_transform * (base.inverse() * i.global_transform))
		# Recalculate orthogonalized scale without moving origin.
		
		new_transform.basis = GizmoHelper.scaled_orthogonal(i.global_transform.basis, scaleData + Vector3.ONE)
		
		#_compute_transform(_edit.mode, item.target_global, item.target_original, motion, snap, is_local_coords, _edit.plane != TransformPlane.VIEW)
		gizmo._transform_gizmo_apply(i, new_transform, false)
		gizmo._update_transform_gizmo()
	
	for child in tempFather.get_children():
		#var globPosition = child.global_position
		child.reparent(self)
		#child.position = globPosition
	remove_child(tempFather)
	tempFather.queue_free()
	toAppend = get_children()
	toAppend.sort_custom(func(a, b): return int(a.name.replace("@MeshInstance3D@","")) < int(b.name.replace("@MeshInstance3D@","")))
	print(toAppend)
	for i in toAppend:
		i.reparent(get_parent())
		i.reparent(self)

func paintObjects(parts, color):
	for object in parts:
		var model = get_child(int(object)).mesh
		var meshDataTool = MeshDataTool.new()
		meshDataTool.create_from_surface(model,0)
		for i in range(meshDataTool.get_vertex_count()):
			meshDataTool.set_vertex_color(i,Color(color))
		get_child(int(parts[0])).mesh.clear_surfaces()
		meshDataTool.commit_to_surface(model)
		get_child(int(object)).mesh = model
	
func duplicateObject(position):
	var object = MeshInstance3D.new()
	object.mesh = get_child(int(position)).mesh.duplicate()
	add_child(object)

func delete(positions):
	positions.reverse()
	for i in positions:
		var toDelete = get_child(int(i))
		toDelete.reparent(get_parent().get_parent())
		toDelete.queue_free()

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
