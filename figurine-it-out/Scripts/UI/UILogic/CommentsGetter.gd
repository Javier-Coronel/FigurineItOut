extends VBoxContainer
var comment = load(ResourceManager.Objects["Comment"])

var time: float = 0
var step: float = 0.1
func _ready():
	get_parent().get_v_scroll_bar().changed.connect(func():
		get_parent().scroll_vertical = int(get_parent().get_v_scroll_bar().max_value) - int(get_parent().get_v_scroll_bar().page)
		)
func _process(delta):
	time += delta
	if time>step:
		time = 0
		var comments = ApiRequester.getPacketsOfType("comment")
		for i in comments:
			var commentToPost = comment.instantiate()
			commentToPost.get_node("Comment").text = i["text"]
			commentToPost.get_node("User").text = i["player"]
			%CommentContainer.add_child(commentToPost)
