extends MarginContainer

var optionsScene = preload("res://Scenes/optionsmenu.tscn")

func _on_MenuButton_pressed():
	var optionsInstance = optionsScene.instance()
	get_tree().root.get_node("Game").call_deferred("add_child", optionsInstance)

