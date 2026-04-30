class_name LibraryCard
extends Control

func _ready() -> void:
	%Save.pressed.connect(download)
	pass

func processModel(data):
	for i in data:
		%Model.processModification(i)

func giveInfo(modelName,room,userName):
	%Name.text = modelName
	%PartyCode.text = "Party ID: " + str(int(room))
	%UserName.text = userName

func download():
	var gltf_document_save := GLTFDocument.new()
	var gltf_state_save := GLTFState.new()
	gltf_document_save.append_from_scene(%Model, gltf_state_save)
	# The file extension in the output `path` (`.gltf` or `.glb`) determines
	# whether the output uses text or binary format.
	# `GLTFDocument.generate_buffer()` is also available for saving to memory.
	gltf_document_save.write_to_filesystem(gltf_state_save, "user://" + %Name.text + ".glb")
