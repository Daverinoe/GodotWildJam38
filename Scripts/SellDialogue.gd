extends Node2D

var value

#func _init():
#	get_node("SellDialogue/MarginContainer/Background/Sell").text = str(value)

func _physics_process(_delta):
	self.global_rotation = 0.0


#func _on_Background_gui_input(event):
#	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
#		get_tree().get_node("GUI/")
