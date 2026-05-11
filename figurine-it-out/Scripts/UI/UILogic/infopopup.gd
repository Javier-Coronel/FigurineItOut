class_name InfoPopUp
extends RichTextLabel
@export var velocity =1.0
static var popup := load(ResourceManager.Objects["PopUp"])
static func create()->Node:
	return popup.instantiate()

func load(textToAdd:String):
	text = textToAdd+"   "
	resized.connect(func():
		var target = Vector2(get_viewport().get_visible_rect().size.x - size.x, position.y)
		print(size.x)
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", target, velocity)
		tween.finished.connect(timer)
	)

func timer():
	var time = Timer.new()
	add_child(time)
	time.wait_time = 7
	time.timeout.connect(retract)
	time.start()

func retract():
	var target = position+Vector2(size.x,0)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", target, velocity)
	tween.finished.connect(func ():
		queue_free()
		)
