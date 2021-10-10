extends Node2D

var level1 = "res://Scenes/Level1.tscn"




func _on_Start_pressed():
	get_tree().change_scene(level1)


func _on_Exit_pressed():
	get_tree().exit()
