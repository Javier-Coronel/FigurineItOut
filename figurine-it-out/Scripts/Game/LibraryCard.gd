class_name LibraryCard
extends Control

func _ready() -> void:
	
	pass

func processModel(data):
	for i in data:
		%Model.processModification(i)

func giveInfo(name,room,userName):
	%Name.text = name
	%PartyCode.text = "Party ID: " + str(int(room))
	%UserName.text = userName
	pass
