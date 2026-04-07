extends Control

var privateRoom: bool = false
var customDataset: String = ""

func _ready():
	%PrivateRoom.toggled.connect(func (value): privateRoom = value)
	%Start.pressed.connect(
		func (): 
			ApiRequester.createRoom(privateRoom, customDataset)
	)
	
