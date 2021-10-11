extends Node2D

var game = "res://Scenes/game.tscn"
var fishScene = preload("res://Scenes/fish.tscn")

export var numFish = 50

func _init():
	for fish in numFish:
		var fishInstance = fishScene.instance()
		fishInstance.get_node("Adolescence").wait_time = randi() % 100
		fishInstance.get_node("Adulthood").wait_time = randi() % 100
		fishInstance.position = Vector2(randf() * 1280, randf() * 720)
		self.call_deferred("add_child", fishInstance)


func _on_Start_pressed():
	get_tree().change_scene(game)


func _on_Exit_pressed():
	get_tree().quit()
