extends Camera3D

var editing = false
var typeOfSelected: ModelEditor.Selection = ModelEditor.Selection.VERTEX



func _physics_process(delta):
	var movementZ = Input.get_axis("moveCloser", "moveFarther")
	var movementX = Input.get_axis("moveLeft", "moveRigth")
	var movementY = Input.get_axis("moveDown", "moveUp")
	
	position = position + (Vector3(movementX,movementY,movementZ).rotated(Vector3.UP, rotation.y)) * delta
	
