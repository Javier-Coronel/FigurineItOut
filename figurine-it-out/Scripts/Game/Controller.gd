extends Camera3D

var editing = false
var typeOfSelected: ModelEditor.Selection = ModelEditor.Selection.VERTEX



func _physics_process(delta):
	var movement = Vector3()
	
	if(Input.is_action_pressed("moveCloser")):
		movement.z = -1
	elif(Input.is_action_pressed("moveFarther")):
		movement.z = 1
	
	if(Input.is_action_pressed("moveRigth")):
		movement.x = 1
	elif(Input.is_action_pressed("moveLeft")):
		movement.x = -1
	
	if(Input.is_action_pressed("moveUp")):
		movement.y = 1
	elif(Input.is_action_pressed("moveDown")):
		movement.y = -1
	
	position = position + (movement.rotated(Vector3.UP, rotation.y)) * delta

	
