extends VBoxContainer
var comment = load(ResourceManager.Objects["Comment"])

var time: float = 0
var step: float = 0.1
func _process(delta):
	time += delta
	if time>step:
		time = 0
		var comments = ApiRequester.getPacketsOfType("comment")
		for i in comments:
			var commentToPost = comment.instantiate()
			commentToPost.get_node("Comment").text = i["text"]
			commentToPost.get_node("Comment/User").text = i["player"]
			%CommentContainer.add_child(commentToPost)
