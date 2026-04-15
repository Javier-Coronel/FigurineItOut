extends Control

var privateRoom: bool = false
var customDataset: String = ""

func _ready():
	%PrivateRoom.toggled.connect(func (value): privateRoom = value)
	%CustomDataset.pressed.connect(
		func ():
			%DatasetSelectorDialog.visible = true
	)
	%DatasetSelectorDialog.file_selected.connect(
		func (file):
			var dataset = FileAccess.open(file, FileAccess.READ)
			customDataset = dataset.get_as_text()
			
	)
	%Start.pressed.connect(
		func (): 
			ApiRequester.createRoom(privateRoom, customDataset)
	)
	
