extends MarginContainer

var optionsScene = preload("res://Scenes/optionsmenu.tscn")
var instructionScene = preload("res://Scenes/instructionScene.tscn")

func _on_MenuButton_pressed():
	var optionsInstance = optionsScene.instance()
	get_tree().root.get_node("Game").call_deferred("add_child", optionsInstance)



func _on_Button_pressed():
	var instructionInstance = instructionScene.instance()
	self.call_deferred("add_child", instructionInstance)
