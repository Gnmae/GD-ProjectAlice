extends TextureButton

var column : int

var type : String

var scene : String
var scene_bg : String

func _on_pressed() -> void:
	var node_selection_scene = get_parent()
	node_selection_scene.node_pressed(self)
