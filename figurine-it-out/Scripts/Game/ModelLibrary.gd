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
		if (currentPage == 0):
			%PageBack.disabled = true
		if (currentModels < 30):
			%PageNext.disabled = true
		else:
			%PageNext.disabled = false
	)
	%PageNext.pressed.connect(
		func():
		currentPage += 1
		updatePage()
		if (currentPage == 0):
			%PageBack.disabled = true
		if (currentModels < 30):
			%PageNext.disabled = true
		else:
			%PageNext.disabled = false
	)
	

func updatePage():
	var user = JSON.stringify({"user": ResourceManager.getToken()})
	ApiRequester.request(
		(func(_result, response_code, _headers, body):
			var data = JSON.new()
			data.parse(body.get_string_from_utf8())
			#if(data.get("ok") == null || !data.ok):return
			data = data.data
			print(data["ok"])
			if(!data["ok"]):return
			var cont = 0
			for i in data["data"]:
				print(i)
				var model = modelCard.instantiate()
				model.processModel(i["data"])

				%ModelContainer.add_child(model)

			),
		HTTPClient.METHOD_GET,
		"objects/getAvalibleObjects/" + str(currentPage),
		user
		)
