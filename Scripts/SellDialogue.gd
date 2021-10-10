extends Node2D

var value = 0

func _init():
	self.global_rotation = 0.0

func _physics_process(_delta):
	self.global_rotation = 0.0

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		self.call_deferred("queue_free")


func _on_MarginContainer_gui_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		get_tree().root.get_node("Game").currentMoney += value
		get_parent().call_deferred("queue_free")
