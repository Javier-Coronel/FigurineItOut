extends Control

var currentPage := 0
var currentModels := 0
var modelCard = load(ResourceManager.Objects["LibraryModelCard"])

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	updatePage()
	%PageBack.pressed.connect(
		func():
		currentPage -= 1
		updatePage()
		get_node("ScrollContainer").scroll_vertical = 0
		%PageBack.disabled = true if currentPage == 0 else false
	)
	%PageNext.pressed.connect(
		func():
		currentPage += 1
		updatePage()
		get_node("ScrollContainer").scroll_vertical = 0
		%PageBack.disabled = true if currentPage == 0 else false
	)

func updatePage():
	var user = JSON.stringify({"user": ResourceManager.getToken()})
	ApiRequester.request(
		(func(_result, response_code, _headers, body):
			currentModels = 0
			for i in %ModelContainer.get_children():
				i.queue_free()
			var data = JSON.new()
			data.parse(body.get_string_from_utf8())
			#if(data.get("ok") == null || !data.ok):return
			data = data.data
			if(!data["ok"]):return
			var curContainer
			for i in data["data"]:
				if currentModels % 3 == 0:
					curContainer = HBoxContainer.new()
					curContainer.size_flags_vertical=Control.SIZE_EXPAND_FILL
					curContainer.size_flags_horizontal=Control.SIZE_EXPAND_FILL
					%ModelContainer.add_child(curContainer)
				currentModels+=1
				var model = modelCard.instantiate()
				model.giveInfo(i["name"],i["room"],i["userName"])
				print(i)
				var container = MarginContainer.new()
				
				container.size_flags_vertical=Control.SIZE_EXPAND_FILL
				container.size_flags_horizontal=Control.SIZE_EXPAND_FILL
				container.grow_vertical = Control.GROW_DIRECTION_END
				var modelContainer = AspectRatioContainer.new()
				container.add_child(modelContainer)
				modelContainer.stretch_mode = AspectRatioContainer.STRETCH_WIDTH_CONTROLS_HEIGHT
				modelContainer.alignment_vertical = AspectRatioContainer.ALIGNMENT_BEGIN
				modelContainer.size_flags_vertical=Control.SIZE_EXPAND_FILL
				modelContainer.size_flags_horizontal=Control.SIZE_EXPAND_FILL
				modelContainer.grow_vertical = Control.GROW_DIRECTION_END
				modelContainer.add_child(model)
				curContainer.add_child(container)
				model.resized.connect(func(): 
					modelContainer.custom_minimum_size.y = modelContainer.size.x
					)
				model.processModel(i["data"])
			if (currentModels < 30):
				%PageNext.disabled = true
			else:
				%PageNext.disabled = false
			),
		HTTPClient.METHOD_GET,
		"objects/getAvalibleObjects/" + str(currentPage),
		user
		)
