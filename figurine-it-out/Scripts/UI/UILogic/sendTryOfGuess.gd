extends Button
var ownComment = load(ResourceManager.Scenes["OwnComment"])
func _ready():
    pressed.connect(postGuess)

func postGuess():
    ApiRequester.socket.send_text(JSON.stringify({"type": "comment", "comment": %CommentInput.text}))
    var comment = ownComment.instantiate()
    comment.get_node("Comment").text = %CommentInput.text
    %CommentContainer.add_child(comment)
    %CommentInput.text = ""
