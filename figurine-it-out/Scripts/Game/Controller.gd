extends Camera3D

@export var onParty = false
var moving = true
var movementVelocity = 3
var rotationalVelocity = 1

func _ready() -> void:
	if onParty:
		%CommentInput.focus_entered.connect(func(): moving = false)
		%CommentInput.focus_exited.connect(func(): moving = true)

func _physics_process(delta):
	if !moving: return
	var appliedRotation = Input.get_vector( "rotateDown", "rotateUp", "rotateRigth", "rotateLeft")
	rotation = rotation + Vector3(appliedRotation.x, appliedRotation.y, 0) * delta * rotationalVelocity
	
	var movementZ = Input.get_axis("moveCloser", "moveFarther")
	var movementX = Input.get_axis("moveLeft", "moveRigth")
	var movementY = Input.get_axis("moveDown", "moveUp")
	
	position = position + (Vector3(movementX,movementY,movementZ).rotated(Vector3.UP, rotation.y)) * delta * movementVelocity
	
