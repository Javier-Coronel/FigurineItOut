extends Button

@export var user: LineEdit
@export var password: LineEdit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_up.connect(tryLogin)
	pass # Replace with function body.

func tryLogin() -> void:
	if !(checkUser() || checkPassword()):	return
	print("Usuario ", user.text, " contraseña ", password.text)
	for i in range(278,279):
		ApiRequester.request((func(a):
			var jason = JSON.new()
			jason.parse(a.get_string_from_utf8())
			print(jason.data["sprites"]["front_default"])
			print(jason.data["name"])
			
			ApiRequester.request((func(b):
				var image = Image.new()
				var error = image.load_png_from_buffer(b)
				if error != OK:
					push_error("Couldn't load the image.")

				var texture = ImageTexture.create_from_image(image)

				# Display the image in a TextureRect node.
				var texture_rect = TextureRect.new()
				add_child(texture_rect)
				texture_rect.texture = texture
			), HTTPClient.METHOD_GET, jason.data["sprites"]["front_default"], "")
		), HTTPClient.METHOD_GET, str("https://pokeapi.co/api/v2/pokemon/",i), "")

func checkUser() -> bool:
	var validUser = true
	validUser = validUser && !user.text.is_empty()
	if !validUser: print("Usuario no valido")
	return validUser

func checkPassword() -> bool:
	var validPassword = true
	validPassword = validPassword && !password.text.is_empty()
	if !validPassword: print("Contraseña no valida")
	return validPassword
